# Disposables

- 주어진 상황에 따라 dispose()의 구체적인 기능은 다르지만 **핵심은 리소스를 해제하고 이벤트 구독을 중지**
하는 것이다. 리소스 낭비와 불필요한 이벤트 수신으로 문제를 일으키지 않기 위해서다.
- subscribe 메서드에서 Completed나 Error가 나는 경우, 자동으로 리소스가 해제되지만 그래도 문서에서는 하라고 나와있다.
- Disposed는 옵저버블이 전달하는 이벤트는 아니다
- 파라미터로 클로저를 전달하면 옵저버와 관련된 모든 리소스가 전달된 이후에 호출

```swift
let subscription1 = Observable.from([1,2,3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed") //Disposed는 모든 리소스가 해제된 후에 호출
    })

subscription1.dispose() //dispose를 직접 호출하는 것 보다 disposebag를 호출 (공식문서에서 권장)

//1
//2
//3
// Completed
// Disposed
```

```swift
//이 경우 Disposed 출력문이 없지만, 리소스가 해지됨. Completed거나 Error면 자동으로 해지됨.
Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }
    .disposed(by: bag)

// 왜 ? Disposed가 출력되지 않았을까?
// Disposed는 옵져버블이 전달하는 이벤트가 아니다.
// 맨위 코드처럼 작성을 한다면, 리소스가 해지되는 시점에 자동으로 호출되는 것일 뿐이다.

// Completed거나 Error면 자동으로 리소스가 정리된다.
// 하지만, 공식문서에 따라면 가능하면 직접 정리하라고 나와있음.
// Subscription에 리턴형인 Disposable은 크게 **리소스해제**와 **실행취소**에 사용됨
```