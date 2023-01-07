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
 # of
 */

let disposeBag = DisposeBag()
let apple = "🍏"
let orange = "🍊"
let kiwi = "🥝"

// 만약 2개 이상의 옵저버블을 방출해야 한다면 -> of를 사용
// 옵저버블 타입 프로토콜의 타입 메소드로 선언 되어있음. 파라미터가 가변 파라미터
// 방출할 요소를 원하는 수 만큼 전달 가능

Observable.of(apple, orange, kiwi) //파라미터가 가변 파라미터(여러개)로 선언
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

Observable.of([1, 2], [3, 4], [5, 6])
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

// just 연산자와 마찬가지로 배열이 그대로 방출됨 (각각 뭉땡히로 방출됨)
// 배열 안의 요소를 하나하나 방출하고 싶다면 ? -> from 연산자를 사용








