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
 # concatMap
 */

let disposeBag = DisposeBag()

let redCircle = "๐ด"
let greenCircle = "๐ข"
let blueCircle = "๐ต"

let redHeart = "โค๏ธ"
let greenHeart = "๐"
let blueHeart = "๐"

// flatMap๊ณผ ๋ค๋ฅด๊ฒ ๋ฐฉ์ถ ์์๋ฅผ ๋ณด์ฅ
// ์๋ณธ ์ต์ ๋ฒ๋ธ์ ์ด๋ฒคํธ ๋ฐฉ์ถ ์์์ ์ด๋ ์ต์ ๋ฒ๋ธ์ ์ด๋ฒคํธ ๋ฐฉ์ถ ์์๋ฅผ ๋์ผํ๋ค๋ ๊ฒ์ ๋ณด์ฅ
// ํ๋ฒ์ ํ๋์ ์ด๋ ์ต์ ๋ฒ๋ธ๋ง ๋ฐฉ์ถ


Observable.from([greenCircle, redCircle, blueCircle])
    .concatMap { circle -> Observable<String> in
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














