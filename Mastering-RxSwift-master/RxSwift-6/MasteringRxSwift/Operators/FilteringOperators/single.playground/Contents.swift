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
 # single
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 원본 옵저버블에서 첫번째 요소만 방출하거나, 조건에 맞는 첫번째 요소만 방출한다.
// 두 개 이상의 요소가 방출되닌 경우 에러가 발생
// 무한한 이벤트 스트림이 아닌 하나의 결과, 에러를 처리하고자 할 때 사용
// HTTP 요청처럼 한 번의 응답 / 에러를 처리할 때 사용합

Observable.just(1)
    .single()
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

Observable.from(numbers)
    .single { $0 == 3 }
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

let subject = PublishSubject<Int>()

subject.single()
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

subject.onNext(100)
//하나의 요소를 방출했다고 해서 바로 completed가 발생하면 안됨
//다른요소가 방출될 수도 있기 때문
//그래서 single옵저버블은 원본 옵저버블에서 conpleted 이벤트를 전달할 때 까지 대기

subject.onNext(1) // 에러

    





