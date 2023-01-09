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
 # groupBy
 */

let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]

// 옵저버블이 방출한 요소들을 원하는 방법으로 그루핑할 때 사용.
// 주로 flapMap연산자 같이 활용

Observable.from(words)
    .groupBy(keySelector: { $0.first ?? Character(" ") }) // 첫번째 문자열을 기준으로 정렬
    //.groupBy(keySelector: { $0.count } )
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
//    .subscribe(onNext: { groupedObservable in
//        print("== \(groupedObservable.key)")
//        groupedObservable.subscribe { print(" \($0) ") }
//    })
    .disposed(by: disposeBag) //4가지만 방출. 문자열 길이로만 방출하면 4가지로 그루핑되기 때문

Observable.range(start: 1, count: 10)
    .groupBy(keySelector: { $0.isMultiple(of: 2) })
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag) 







