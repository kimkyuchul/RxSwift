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
 # interval
 */

// 특정 주기마다 정수륿 방출하는 옵저버블이 필요하다면 이 연산자를 활용

// double, String은 못씀
let i = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

let subscriotion1 = i.subscribe { print("1 >> \($0)") }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscriotion1.dispose()
}

var subscription2 : Disposable?

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    subscription2 = i.subscribe { print("2 >> \($0)") }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    subscription2?.dispose()
}

// 새로운 구독이 추가되는 시점에 내부에 있는 타이머가 시작됨






