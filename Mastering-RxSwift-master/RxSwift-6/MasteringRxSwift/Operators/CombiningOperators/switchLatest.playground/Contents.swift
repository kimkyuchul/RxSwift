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
 # switchLatest
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()


// 가장 최근 옵저버블 방출
// 가장 최근에 방출된 옵저버블을 구독하고, 이 옵저버블이 전달하는 이벤트를 구독자에게 전달하는 switchLatest 연산자

let source = PublishSubject<Observable<String>>() // 문자열을 방출하는 옵저버블을 방출하는 서브젝트

source
    .switchLatest()
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("1")
b.onNext("b")
source.onNext(a) // 최신 옵저버블은 a 이다 a에 관한 이벤트만 앞으로 전달

a.onNext("2")
b.onNext("b") // 전달되지 않음.

source.onNext(b) // b가 최신 옵저버블이 됨

a.onNext("3")
b.onNext("c")

//a.onCompleted() // 구독자로 전달되지 않음
//b.onCompleted() // 구독자로 전달되지 않음
//
//source.onCompleted() // 전달

a.onError(MyError.error) // 최신 구독자가 아니라서 에러 이벤트 전달 안됨
b.onError(MyError.error) // 최신 옵저버블은 에러 이벤트를 받으면 즉시 구독자에게 전달함







