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
 # just
 */

let disposeBag = DisposeBag()
let element = "😀"

// 하나의 항목을 방출하는 옵저버블을 생성
// 옵저버블타입 프로토콜의 타입 메소드로 선언 되어 있음. 파라미터로 하나의 요소를 받아서 옵저버블을 리턴함.
Observable.just(element) // 파라미터로 전달하면 여기에 저장된 문자열을 방출하는 옵저버블이 생성
    //.subscribe { event in print(event) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.just([1, 2, 3])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// from과 헷갈리면 안댐
// just로 생성된 옵저버블은 파라미터로 생성된 요소를 그대로 방출한다.

