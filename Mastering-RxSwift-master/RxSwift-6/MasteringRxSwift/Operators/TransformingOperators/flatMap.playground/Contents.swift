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
 # flatMap
 */

let disposeBag = DisposeBag()

let redCircle = "๐ด"
let greenCircle = "๐ข"
let blueCircle = "๐ต"

let redHeart = "โค๏ธ"
let greenHeart = "๐"
let blueHeart = "๐"

// ์๋ณธ ์ต์ ๋ฒ๋ธ์ด ๋ฐฉ์ถํ๋ ๊ฐ์ ๊ฐ์ํ๊ณ , ์ต์ ๊ฐ์ ํ์ธํ  ์ ์๋ค.
// ์ด๋ฒคํธ ์ํ์ค๋ฅผ ๋ค๋ฅธ ์ด๋ฒคํธ ์ํ์ค๋ก ๋ณํ
// Observable์ ์ด๋ฒคํธ๋ฅผ ๋ฐ์ ์๋ก์ด Observable๋ก ๋ณํ

Observable.from([redCircle, greenCircle, blueCircle])
    .flatMap { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart)
                .take(5)
        case greenCircle:
            return Observable.repeatElement(greenHeart)
                .take(5)
        case blueCircle:
            return Observable.repeatElement(blueHeart)
                .take(5)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// ์์๋ฅผ ๋ณด๋ฉด ๋ค์ฃฝ๋ฐ์ฃฝ์ -> ์ง์ฐ์์ด ๋ฐฉ์ถํ๊ธฐ ๋๋ฌธ

// FlatMap ์ฐ์ฐ์๋ ์ต์ ๋ฒ๋ธ์์ ๋ฐฉ์ถ๋ ๊ฐ์ ๋ณ๊ฒฝํ ๋ค๋ฅธ ์ต์ ๋ฒ๋ธ๋ก ๋ฐฉ์ถ
// FlatMap ์ Inner Observable์ ํตํด์ ๋ณ๊ฒฝํ Result Observable๋ก ๋ฐฉ์ถ๋๋ฉด ์ง์ฐ์์ด ๋ฐฉ์ถ
// ์์ฐจ์ ์ผ๋ก ์๋ค์ด์ค๋ ํ์์ Interleaving




let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
    .flatMap({ $0.asObservable() })
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

subject.onNext(a)
subject.onNext(b)

a.onNext(11)
b.onNext(22)
a.onNext(13)

// ๋ชจ๋  ์ต์ ๋ฒ๋ธ์ ์ต์ข์ ์ผ๋ก ํ๋์ ์ต์ ๋ฒ๋ธ๋ก ํฉ์ณ์ง๊ณ , ๋ชจ๋  ํญ๋ชฉ๋ค์ด ์ด ์ต์ ๋ฒ๋ธ์ ํตํด์ ๊ตฌ๋์๋ก ์ ๋ฌ๋๋ค.
// ์๋ฐ์ดํธ ๋๋ ์ต์  ํญ๋ชฉ๋ค๋ ๊ตฌ๋์์๊ฒ ์ ๋ฌ๋๋ค.
// ๋คํธ์ํฌ๋ ์ฃผ๋ก ์ฌ์ฉ๋๋ค.
