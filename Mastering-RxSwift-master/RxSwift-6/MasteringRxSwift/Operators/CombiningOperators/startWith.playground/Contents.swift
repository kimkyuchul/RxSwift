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
 # startWith
 */

let bag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]

// 옵저버블 시퀀스 앞에 새로운 요소를 추가하는 startWith 연산자
// 옵저버블이 요소를 방출하기 전에 다른항목들을 앞에 추가
// 기본값을 추가할때 사용

Observable.from(numbers)
    .startWith(0) // 배열 맨 앞에 0이 붙음
    .startWith(-1, -2)
    .startWith(-3)
    .subscribe { print($0) }
    .disposed(by: bag)

// startWith로 추가한 값은 Last in first out -> 마지막에 호출한 연산자로 전달한 값이 가장 먼저 방출



