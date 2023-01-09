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

// 여러 Observable에 공통된 로직을 실행해야 할 때 merge 해서 Subscribe 할 수 있음
/*:
 # merge
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)

// concat과 혼동하지 않기 동작방식이 다르다.
// concat은 하나의 옵저버블이 completed된다음에 이어지는 옵저버블 방출.
// merge는 두개이상의 옵저버블을 연결하여 하나의 옵저버블로 합쳐진다음 순서대로 방출한다.
// merge는 옵저버블이 모두 종료해야 종료된다.

let source = Observable.of(oddNumbers, evenNumbers, negativeNumbers)

source
    //.merge()
    .merge(maxConcurrent: 2) // 병합 가능한 옵저버블 수를 제한
    .subscribe { print($0) }
    .disposed(by: bag)

oddNumbers.onNext(3)
evenNumbers.onNext(4)

evenNumbers.onNext(6)
oddNumbers.onNext(5)

negativeNumbers.onNext(-2) // merge(maxConcurrent: 2) -> 병합 대상에서 제외 ( 머지 연산자는 이런 연산자를 큐에 저장해뒀다가 병합 대상 중 하나가 컴플리티드 이벤트를 전달하면 순서대로 병합 대상에 추가한다. )

oddNumbers.onCompleted() // oddNumbers가 병합 대상에서 제외대고 큐에 저장되어 있던 negativeNumbers(-2)가 추가됨

//oddNumbers.onCompleted() // odd는 이제 새로운 이벤트 전달 불가능 even은가능
//oddNumbers.onError(MyError.error) // 하나라도 에러라면 그 즉시 중단되고 다음 이벤트는 받지 않는다.
//
//evenNumbers.onNext(8)
//
//evenNumbers.onCompleted()

// 둘다 종료해야 종료된다.


let first = Observable.of(1, 2, 3)
let second = Observable.of(4, 5, 6)

Observable.merge(first, second)
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)







