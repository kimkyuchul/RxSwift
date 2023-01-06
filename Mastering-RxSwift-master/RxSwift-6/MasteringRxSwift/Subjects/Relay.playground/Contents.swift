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
import RxCocoa

/*:
 # Relay
 */

let bag = DisposeBag()

// Relay는 RxCocoa 프레임워크를 통해 제공

let prelay = PublishRelay<Int>() // / 빈생성자로 생성하는것은 퍼블리쉬서브젝트와 동일
prelay.subscribe { print("1: \($0)") }
    .disposed(by: bag)

prelay.accept(1)

let brelay = BehaviorRelay(value: 1)
brelay.accept(2)

brelay.subscribe {
    print("2: \($0)")
}
.disposed(by: bag)

brelay.accept(3)
print(brelay.value)
// behavior안의 value는 읽기 전용이고 수정은 불가능하다.
// 바꾸고싶다면, accept이벤트를 통해 새로운 이벤트를 전달해야 한다.

// ReplaySubject와 동일하게  bufferSize개의 이벤트를 저장해 subscribe 될 때 저장된 이벤트를 모두 방출
let rrelay = ReplayRelay<Int>.create(bufferSize: 3)

(1...10).forEach{ rrelay.accept($0)}

rrelay.subscribe { print("3: \($0)") }
    .disposed(by: bag)








