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
 # publish
 */
let bag = DisposeBag()
// let subject = PublishSubject<Int>() 필요 없어짐
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).publish() // 연산자 내부에서 퍼블리쉬 서브젝트를 생성하고 멀티캐스트 연산자로 전달해줌 (별도의 파라미터 전달 x)

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect()

// 멀티캐스트를 이용하려면 퍼블리쉬 서브젝트를 생성하여야 햇는데
// 퍼블리쉬는 자동으로 해줌. 하지만 connect부분은 생략할 수 없음.









