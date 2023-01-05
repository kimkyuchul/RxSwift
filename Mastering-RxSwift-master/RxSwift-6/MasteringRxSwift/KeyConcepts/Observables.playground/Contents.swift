//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
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
 # Observables
 */
// Observable은 이벤트가 어떤 순서로 정의 되어야 하는지 정리하는 것 뿐
// Observable가 구독전까지는 값이 전달되지 않는다. -> subscribe 메소드를 호출해야함 (Observable과 Observers를 연결)

// #1 create 연산자를 통해 Observable를 직접 구현
let o1 = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted() // 이후에 다른 이벤트 전달 불가능
    
    return Disposables.create()
}

//이벤트를 처리 Observers
o1.subscribe {
    print("== start ==")
    print($0)
    
    if let elem = $0.element { //형식이 옵셔널이기 때문에 옵셔널 바인딩이 필요
        print(elem)
    }
    print("== end ==")
}

print("------------------------------------")

// 개별 이벤트를 별도의 클로저에서 처리할 때 사용
// 사용하지 않을 파라미터는 nil로 생략가능
// next 이벤트에 저장된 값만 노출
o1.subscribe(onNext: { elem in // 클로저 파라미터로 next이벤트로 저장된 파라미터가 바로 전달 -> element 속성에 접근할 필요가 없음
    print(elem)
})

// #2 미리 정의된 규칙에 따라 이벤트를 전달 -> from 연산자를 통해 이벤트를 전달
Observable.from([0, 1]) // 순서대로 방출되는 Observable를 생성할 때는 from과 같은 연산자를 사용하는게 좋음


// Observables은 이벤트가 전달되는 순서를 정의한다.
// 실제 이벤트가 전달되는 시점은 옵저버가 구독을 시작한 시점이다.
// 중요한 개념 1가지: 옵저버는 동시에 두 개 이상의 이벤트를 처리하지 않는다.
// 바꾸어 말하면 옵저버블은 옵저버가 하나의 이벤트를 처리한 이후에, 이어지는 이벤트를 전달한다.











