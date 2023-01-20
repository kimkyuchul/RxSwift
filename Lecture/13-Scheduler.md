## **Scheduler란?**

- ios 앱을 만들다가 쓰레드 처리가 필요하다면 → GCD를 활용
- RxSwift는 **Scheduler를 사용**
- 스케줄러는 특정 코드가 실행되는 **context를** 추상화 한 것
    - **context는** Low 레벨 쓰레드가 될 수 있고, Dispatch Queue나 Operation Queue가 될 수 도 있다.
- **Scheduler는 추상화된 context이기 때문에  스레드와 1대1로 매칭되지 않는다.**
    - 하나의 스레드에 2개 이상의 개별 **Scheduler가** 존재하거나 하나의 **Scheduler**가 두개의 쓰레드에 걸쳐 있을 수 도 있다.
- 큰 틀에서 보면 GCD와 유사

## GCD vs RxSwift(**Scheduler)**

<aside>
💡 GCD( Main Queue, Global Queue )

</aside>

<aside>
💡 RxSwift ( Main Scheduler, Background Scheduler )

</aside>

- ex) UI를 업데이트 시키는 코드는 Main 쓰레드에서 실행 되어야 함
    - GCD 에서는 Main Queue(serial)에서 실행하고, RxSwift에서는 Main Scheduler에서 실행
- 네트워크 요청이나 파일 처리 요청을 Main에서 실행하면, 블로킹이 발생
    - GCD 에서는 Global Queue(concurrent)에서 실행하고, RxSwift에서는 Background Scheduler에서 실행

## 다시 알아보는 Serial, Concurrent

- **Serial**: 이전 작업이 끝나면 다음 작업을 순차적으로 실행하는 직렬 형태의 Queue. 하나의 작업을 실행하고 그 실행이 끝날 때까지 대기열에 있는 다은 작업을 잠시 미루고 있다가 직전의 작업이 끝나면 실행
- **Concurrent**: 이전 작업이 끝날 때 까지 기다리지 않고 병렬 형태로 동시에 실행되는 Queue. 즉 대기열에 있는 작업을 동시에 별도의 Thread를 사용하여 실행

## Serial Scheduler

### CurrentThreadScheduler

- 스케줄러를 별도로 지정하지 않는다면 이 스케줄러가 사용됨

### Main Scheduler

- 메인 쓰레드와 연관된 스케줄러
- 메인 큐처럼 UI를 업데이트할 때 사용

### SerialDispatchQueueScheduler

- 순차적으로 진행되는 Serial 비동기 작업을 실행할 DispatchQueue를 직접 지정하고 싶다면 사용
- 컨커런트 디스패치 큐에 전달된 경우에도 시리얼 디스패치 큐로 변환
- 앞에서 설명한 Main Scheduler는 SerialDispatchQueueScheduler의 한 종류
- 시리얼 스케줄러는 `observeOn`를 위한 특정 최적화를 가능하게 해줌

## Concurrent Scheduler

### ConcurrentDispatchQueueScheduler

- 병렬적으로 진행되는 Concurrent 비동기 작업을 실행할 DispatchQueue를 직접 지정하고 싶다면
- 특정 `dispatch_queue_t`에서 실행되어야 하는 추상적인 작업에서 사용 시리얼 디스패치 큐에도 보낼 수 있으며 아무런 문제가 발생하지 않음
- Background 작업을 실행할 때는 ConcurrentDispatchQueueScheduler를 사용

### OperationQueueScheduler

- 실행 순서를 제외하거나, 동시에 진행 가능한 작업 수를 제한하고 싶다면
- 이 Queue는 DispatchQueue가 아닌 OperationQueue를 통해서 생성

### Test에 활용되는 Scheduler

- TestScheduler
- Custom Scheduler

## Ex)

```swift
let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observe(on: backgroundScheduler) // 이 아래부터는 다 백그라운드 스레드에서 실행된다. 이어지는 연산자가 실행하는 스케줄러를 지정한다. observe(on:) 메서드로 지정한 스케줄러는 다른 스케줄러로 변경하기 전까지 계속 사용됨
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
// 아무것도 출력되지 않음 -> 옵저버블이 생성된 것도 아니고 연산자가 호출된 것도 아님
// 옵저버블이 어떤 요소를 방출하고, 어떻게 처리해야할 지를 나타낼 뿐이다.
// 옵저버블이 생성되고 연산자가 호출되는 시점은 바로 구독이 시작되는 시점!!
    .subscribe(on: MainScheduler.instance) //subscribe 메서드가 호출하는 스케줄러를 지정하는 것이 아님, 이어지는 연산자가 호출되는 스케줄러를 지정하는 것도 아님
// 옵저버블이 시작되는 시점에 어떠한 스케줄러를 사용할지 지정하는 것!
// observe(on:)과 달리 호출 시점이 중요하지 않음 (어디서 호출해도 상관 없음)
    .observe(on: MainScheduler.instance) // subscribe를 메인 스레드에서 실행하고 싶다면.
    .subscribe {
          print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
          print($0)
       }
    .disposed(by: bag)

/* 결과
Main Thread >> filter
Main Thread >> filter
Main Thread >> filter
Background Thread >> map
Main Thread >> filter
Background Thread >> map
Main Thread >> filter
Main Thread >> filter
Background Thread >> map
Main Thread >> filter
Main Thread >> filter
Background Thread >> map
Main Thread >> filter
Main Thread >> subscribe
next(4)
Main Thread >> subscribe
next(8)
Main Thread >> subscribe
next(12)
Main Thread >> subscribe
next(16)
Main Thread >> subscribe
completed
*/
```