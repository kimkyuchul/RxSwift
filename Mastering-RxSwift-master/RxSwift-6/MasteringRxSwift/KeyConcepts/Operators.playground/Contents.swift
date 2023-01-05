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
 # Operators
 */
//ObservableType과Observable 클래스에는 복잡한 논리를 구현하기 위해 많은 메서드가 포함되어 있다. 이 메서드들을 Operator라고 부른다


let bag = DisposeBag()

// 연산자는 보통 subscribe 메소드 앞에 위치
// 그래야 subscribe애서 우리가 원하는 최종 값 방출 가능
Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .take(5) // 처음 5개의 요소만 전달
    .filter { $0.isMultiple(of: 2) } // 짝수만 구독자로 전달
    .subscribe { print($0) }
    .disposed(by: bag)


// 연산자는 새로운 옵저버블을 리턴하기 때문에,
// 두 개이상의 연산자를 연달아 호출 할 수 있다
// 하지만 호출 순서에 따라다른 결과가 나오기 때문에 호출 순서에 주의











