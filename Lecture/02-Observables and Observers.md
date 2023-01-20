# Observables and Observers

- Observable은 이벤트를 전달
- Observer은 Observable을 감시하고 있다가 전달되는 이벤트를 처리
- Observer가 Observable을 감시하는 것을 구독한다고 한다. → Subscribe
    - Observer를 구독자라고 부르기도 함
- • `observable` = `observable sequence` = `sequence`: 각각의 단어를 계속 보게 될 것인데 이는 곧 다 같은 말이다. (Everything is a sequence)
- 중요한 것은 이 모든 것들이 **비동기적(asynchronous**)이라는 것

## Observables의 세가지 이벤트

### Next

- Observables에서 발생한 새로운 이벤트는 Next이벤트를 통해 구독자로 전달
    - 이벤트에 값이 포함되어있다면 Next와 함께 전달
    - rxswift에서는 이것을 Emission(방출)이라고 한다.
- 최신(다음)값을 전송하는 이벤트

### Error, Completed

- Observables에서 에러가 발생하면 Error 이벤트가 전달
- Observables이 정상적으로 종료되면 Completed가 전달
- 두 이벤트는 Observables의 이벤트에서 가장 마지막에 전달
- Error, Completed 이벤트는 Emission이라고 부르지 않고, Notification이라고 부름

## Marble Diagram

<aside>
💡 -1--2--3--4--5--6--| // terminates normally

</aside>

<aside>
💡 -a--b--a--a--a---d---X // terminates with error

</aside>

- 선 위의 표시들은 개별 이벤트(Next 이벤트)
- terminates normally의 화살표 오른쪽에  표시된 vertical bar는 완료(Completed)를 나타냄 → Observables의 LifeCycle은 Completed가 발생한 시점에서 종료
- terminates with error의 화살표 오른쪽에  표시된 X는  에러(Error)를 나타냄 → Observables의 LifeCycle은 Completed와 동일하게 error가 발생한 시점에서 종료
- Observable과 연산자를 시각적으로 나타내 주는 것 → Marble Diagram
- RxMarbles, RXJS Marbles ← 요거를 통해 RxSwift의 흐름을 파악하는데 용이

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/631048c5-ea16-4b0a-bb5d-5d797c9f7f96/Untitled.png)

- 어떠한 값에다가 Just연산자를 사용하면 그 값이 그대로 나온다는 것을 알 수 있다.
- 하나의 항목을 방출하는 옵저버블을 생성

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b756967f-ab73-48a6-a973-7c2a11fe20b5/Untitled.png)

- 'filter(x => x > 10) → 10보다  큰 값만 방출

```swift
// Observable은 이벤트가 어떤 순서로 정의 되어야 하는지 정리하는 것 뿐
// Observable가 구독전까지는 값이 전달되지 않는다. -> subscribe 메소드를 호출해야함 (Observable과 Observers를 연결)

// #1 create 연산자를 통해 Observable를 직접 구현
let o1 = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted() // 이후에 다른 이벤트 전달 불가능
    
    return Disposables.create()
}
```