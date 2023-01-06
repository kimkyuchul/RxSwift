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
 # BehaviorSubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let p = PublishSubject<Int>()

p.subscribe { print("PublishSubject >>", $0) }
    .disposed(by: disposeBag)

//PublishSubject 와 비슷하지만 초기 이벤트를 가진 Subject 입니다. subscribe 될때 가장 최신의 .next 이벤트를 전달
let b = BehaviorSubject<Int>(value: 0)

b.subscribe { print("BehaviorSubject >>", $0) }
    .disposed(by: disposeBag)

// BehaviorSubject를 생성하면, 내부에 next 이벤트가 하나 생성된다.
// 여기에는 생성자로 저장한 값이 전달
// 새로운 구독자가 추가되면 저장되어있던 넥스트이벤트가 바로 전달된다.

b.onNext(1)

//만약 여기서 새로운 옵저버를 추가하면 BehaviorSubject는 어떤이벤트를 전달 할까?

b.subscribe { print("BehaviorSubject2 >>", $0) }
    .disposed(by: disposeBag)

// b.onCompleted()
b.onError(MyError.error)

b.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)


// BehaviorSubject는 새로운 넥스트 이벤트가 생기면 기존에 있던 이벤트를 교체하는 방식
// 결과적으로 가장 최신 이벤트를 옵저버에게 전달함.
// 사용 : 항상 최신 데이터로 채워놓아야 하는 경우에 사용 (유저 프로필)











