//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import RxSwift

/*:
 # Disposables
 */
// Disposed는 옵저버블이 전달하는 이벤트는 아니다
// 파라미터로 클로저를 전달하면 옵저버와 관련된 모든 리소스가 전달된 이후에 호출

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

var bag = DisposeBag()
Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }
    .disposed(by: bag)

bag = DisposeBag() //내가 원하는 시점에 해지하려면 그냥 이렇게 새로운 DisposeBag을 만들면 이전께 해지

//위처럼 리소스를 해지할 때는 DisposeBag을 활용

// subscribe Disposables을 실행 취소에 사용될 때
// 1초마다 1씩 증가해서 방출, 방출을 멈출 코드가 필요함.
let subscription2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

// 3초 뒤에 disposed를 호출
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
}

// completed메소드가 호출 안됨을 볼 수 있음.
// 이러한 이유러 dispose로 리소스를 해지하는 것은 피하는 것이 좋다.


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
