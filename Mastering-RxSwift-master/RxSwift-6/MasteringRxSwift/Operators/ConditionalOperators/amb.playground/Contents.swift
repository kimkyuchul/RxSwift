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
 # amb
 */


let bag = DisposeBag()

enum MyError: Error {
   case error
}

// a,b,c중에 가장 먼저 이벤트를 방출하는 것부터 방출하기 시작한다.
// 여러 서버로 연결하고 가장 빠른 응답을 처리하는 패턴을 해결 할 수 있음

let a = PublishSubject<String>()
let b = PublishSubject<String>()
let c = PublishSubject<String>()

//a.amb(b)
Observable.amb([a,b,c])
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("A") // a가 b보다 먼저 이벤트를 방출 -> 그래서 amb는 a를 구독하고 b는 무시
b.onNext("B")

b.onCompleted() // 구독자에게 전달 안됨
a.onCompleted()

// 두개 이상의 소스 옵저버블 중에서 가장 먼저 이벤트를 전달하는 옵저버를 구독하고 나머지는 무시







