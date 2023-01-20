# Hello, RxSwift!

```swift
Observable.combineLatest(firstName.rx.text, lastName.rx.text) { $0 + " " + $1 }
    .map { "Greetings, \($0)" }
    .bind(to: greetingLabel.rx.text)
```

- 두개의 텍스트필드에 있는 값을 공백으로 연결하고
- 문자열 앞 부분에 greetings라는 접두어를 추가
- 그리고 이 문자열을 레이블에 추가 → 텍스트 필드에 새로운 값이 입력될 때 마다 반복 실행
- **위 코드를 Rx를 사용안하면 엄청 길어질 것**

### 단순하고 직관적인 코드 작성이 가능

- RxSwift의 장점 → 단순하고 직관적인 코드를 작성할 수 있다
- RxSwift는 코드를 새로운 데이터에 반응하며 순차적으로 처리하게 함으로써 비동기 프로그래밍을 쉽게 도와줌

### apple이 제공했던 비동기 API

- **NotificationCenter : 사용자가 장치의 방향을 변경하거나 키보드가 등장하고 사라지는 것과 같이 이벤트가 발생할 때마다 코드를 실행**
- **Delegate Pattern : 임의의 시간에 다른 클래스 나 API에 의해 실행될 메소드를 정의합니다. 예를 들어 Application Delegate에서 새 알림이 도착할 때 수행해야 할 작업을 정의하지만 이 코드가 언제 실행되는지 또는 실행될 지 알 수 없음.**
- **Grand Central Dispatch (GCD) : Serial Queue에서 순차적으로 실행되도록 코드를 예약하거나 우선 순위가 다른 여러 Queue에서 동시에 많은 수의 작업을 실행**
- **Closure : 클래스간에 전달할 수있는 분리 된 코드. 각 클래스가 실행 여부를 결정**

**하지만 apple의 SDK내의 API를 통한 복합적인 비동기 코드는 부분별로 나눠서 쓰기 매우 어려움**

## Ex

```swift
var a = 1
var b = 2
a + b

a = 12

//3
//12
```

- a가 값을 바꾸고 실행해도 a + b값은 바뀌지 않는다. 만약 a와 b의 값이 바뀔 때마다 계산을 다시 실행해야 한다면?
- 명령형 코드에서는 복잡해진다.

```swift
let aa = BehaviorSubject(value: 1)
let bb = BehaviorSubject(value: 2)

Observable.combineLatest(aa, bb) { $0 + $1 }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
    
aa.onNext(12)

//3
//14
```

- Rxswift는 값이나 상태에 따라서 값이 바뀌는 프로그래밍을 쉽게 할 수 있다. => 반응형 프로그래밍