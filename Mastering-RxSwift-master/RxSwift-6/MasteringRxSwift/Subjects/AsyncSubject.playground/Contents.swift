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
 # AsyncSubject
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

// 앞서 위에 3개는 서브젝트로 이벤트가 전달되면 즉시 구독자에 전달
// 반면 AsyncSubject는 서브젝트로 컴플리트 이벤트가 전달되지 전까지 어떠한 이벤트도 전달하지 않음
// 컴플리트 이벤트가 전달되면 그 시점에서 가장 최근 시점에 전달된 넥스트 이벤트 하나를 구독자에게 전달한다.

let subject = AsyncSubject<Int>()

subject
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)

// 가장 최근에 전달된 넥스트 이벤트와 컴플리티드 이벤트 전달됨
// subject.onCompleted()

subject.onError(MyError.error) // 에러 이벤트에서는 넥스트이벤트가 전달되지 않는다.

// AsyncSuject는 Completed이벤트가 전달된 시점으로 가장 최근에 전달된 하나의next 이벤트를 구독자에게 전달
// 만약 전달된 이벤트가 없다면 그냥 completed이벤트만 전달하고 종료
//




