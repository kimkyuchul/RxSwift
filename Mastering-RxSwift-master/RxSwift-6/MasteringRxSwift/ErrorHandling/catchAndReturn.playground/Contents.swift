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
 # catchAndReturn
 */
// 옵저버블 대신 기본값을 리턴하는 연산자
let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()

subject
    .catchAndReturn(-1) // 파라미터 형식은 소스 옵저버블이 방출하는 형식과 같은 타입(서브젝트 타입)
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)

// 에러가 발생했을 때 사용할 기본 값이 있다면 catchAndReturn 연산자를 사용
// 에러의 종류와 상관없이 항상 동일한 값을 방출한다는 단점이 있음
// 나머지 경우 catch 연산자를 사용 -> 클로저를 통해 에러 처리 코드를 자유롭게 구현 가능한 장점이 있음

// 두 연산자와 달리 작업을 처음부터 시작하고 싶다면 retry 사용
