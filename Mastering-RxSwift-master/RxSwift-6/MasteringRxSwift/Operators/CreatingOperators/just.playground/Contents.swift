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
 # just
 */

let disposeBag = DisposeBag()
let element = "π"

// νλμ ν­λͺ©μ λ°©μΆνλ μ΅μ λ²λΈμ μμ±
// μ΅μ λ²λΈνμ νλ‘ν μ½μ νμ λ©μλλ‘ μ μΈ λμ΄ μμ. νλΌλ―Έν°λ‘ νλμ μμλ₯Ό λ°μμ μ΅μ λ²λΈμ λ¦¬ν΄ν¨.
Observable.just(element) // νλΌλ―Έν°λ‘ μ λ¬νλ©΄ μ¬κΈ°μ μ μ₯λ λ¬Έμμ΄μ λ°©μΆνλ μ΅μ λ²λΈμ΄ μμ±
    //.subscribe { event in print(event) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.just([1, 2, 3])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// fromκ³Ό ν·κ°λ¦¬λ©΄ μλ
// justλ‘ μμ±λ μ΅μ λ²λΈμ νλΌλ―Έν°λ‘ μμ±λ μμλ₯Ό κ·Έλλ‘ λ°©μΆνλ€.

