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
 # zip
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

// //combineLatest랑 비슷함 하지만 한번 결합된 애는 재방출 하지 않음 -> 첫 번째 요소는 첫 번째 요소와 연결, 두번째 요소는 두 번째 요소와 연결
// 발생 순서가 같은 Event 끼리 병합하여 방출
// 이벤트끼리 쌍을 이루지 않으면 방출하지 않음

Observable.zip(numbers, strings) { "\($0) - \($1)" }
    .subscribe{ print($0) }
    .disposed(by: bag)

numbers.onNext(1)
strings.onNext("one")

numbers.onNext(2) // 아직 2와 결합할 짝이없어서 방출 안됨 combineLatest와의 차이점
strings.onNext("two") // 항상 방출된 순서대로 짝을 맞춤

//numbers.onCompleted() // 하나라도 onCompleted가 전달되면 이후에는 넥스트 이벤트 전달되지 않음.
numbers.onError(MyError.error)
strings.onNext("three")
strings.onCompleted()

let first = Observable.of(1, 2, 3, 4)
let second = Observable.of("A", "B", "C")

Observable.zip(first, second)
    .subscribe(onNext: { print("\($0)" + $1) })
    .disposed(by: bag)








