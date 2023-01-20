# Create Operators

## **just**

```swift
let observable: Observable<Int> = Observable<Int>.just(1)
```

- 하나의 항목을 방출하는 옵저버블을 생성
- 옵저버블타입 프로토콜의 타입 메소드로 선언 되어 있음. 파라미터로 하나의 요소를 받아서 옵저버블을 리턴함.
- **just**는 오직 하나의 요소를 포함하는 **Observable Sequence**를 생성

## of

```swift
let observables = Observable.of(1, 2, 3)
```

- 만약 2개 이상의 옵저버블을 방출해야 한다면 -> of를 사용
- 파라미터가 가변 파라미터(여러개)로 선언

## **from**

```swift
let observables3 = Observable.from([1, 2, 3])
```

- 첫번째 파라미터로 배열을 받는다. 리턴으로 배열의 요소를 하나씩 방출함.
- 배열을 받아 하나하나 방출하는 옵저버블 생성.

- [x]  [**range**](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/range.playground/Contents.swift)
- [x]  **[generate](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/generate.playground/Contents.swift)**
- [x]  **[repeatElement](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/repeatElement.playground/Contents.swift)**
- [x]  **[deferred](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/deferred.playground/Contents.swift)**
- [x]  **[create](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/create.playground/Contents.swift)**
- [x]  **[empty](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/empty.playground/Contents.swift)**
- [x]  **[error](https://github.com/kimkyuchul/RxSwift/blob/main/Mastering-RxSwift-master/RxSwift-6/MasteringRxSwift/Operators/CreatingOperators/error.playground/Contents.swift)**