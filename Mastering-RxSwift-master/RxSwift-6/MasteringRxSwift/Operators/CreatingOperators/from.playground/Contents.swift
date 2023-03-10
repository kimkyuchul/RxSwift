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
 # from
 */

let disposeBag = DisposeBag()
let fruits = ["π", "π", "π", "π", "π"]
// μ²«λ²μ§Έ νλΌλ―Έν°λ‘ λ°°μ΄μ λ°λλ€. λ¦¬ν΄μΌλ‘ λ°°μ΄μ μμλ₯Ό νλμ© λ°©μΆν¨.
// μνμ€ νμμ μ λ¬ ν  μλ μμ
Observable.from(fruits)
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

//λ°°μ΄μ λ°μ νλνλ λ°©μΆνλ μ΅μ λ²λΈ μμ±.
//λ°°μ΄μ μ μ₯λ μμλ₯Ό μμλλ‘ λ°©μΆνλ μ΅μ λ²λΈμ΄ νμν  λ μ¬μ©.








