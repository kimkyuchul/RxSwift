//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
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

let disposeBag = DisposeBag()

Observable.just("Hello Rxswift")
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// a가 값을 바꾸고 실행해도 a + b값은 바뀌지 않는다. 만약 a와 b의 값이 바뀔 때마다 계산을 다시 실행해야 한다면?
// 명령형 코드에서는 복잡해진다.
    var a = 1
    var b = 2
    a + b

    a = 12

// Rxswift는 값이나 상태에 따라서 값이 바뀌는 프로그래밍을 쉽게 할 수 있다. => 반응형 프로그래밍

let aa = BehaviorSubject(value: 1)
let bb = BehaviorSubject(value: 2)

Observable.combineLatest(aa, bb) { $0 + $1 }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
    
aa.onNext(12)






















