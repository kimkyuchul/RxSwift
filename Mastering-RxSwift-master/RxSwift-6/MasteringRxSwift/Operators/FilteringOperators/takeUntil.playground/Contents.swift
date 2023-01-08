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
 # take(until:)
 */

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.take(until: trigger) // 파라미터로 옵저버블을 받음
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

subject.onNext(1) // 트리거가 넥스트 이벤트를 방출하지 않았기 때문에 잘 방출됨
subject.onNext(1) // 마찬가지

trigger.onNext(0) // 트리거에서 요소를 방출하면 컴플리티드 이벤트가 전달됨

subject.onNext(3)

//Rxswift6

let ssubject = PublishSubject<Int>()

// 클로저를 파라미터로 받는 take(until)은 true를 방출하면 옵저버블을 종료
ssubject.take(until: { $0 > 5 })
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

ssubject.onNext(1)
ssubject.onNext(1)
ssubject.onNext(6)














