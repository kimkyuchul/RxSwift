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
 # flatMapFirst #1
 */

let disposeBag = DisposeBag()

let redCircle = "๐ด"
let greenCircle = "๐ข"
let blueCircle = "๐ต"

let redHeart = "โค๏ธ"
let greenHeart = "๐"
let blueHeart = "๐"

// ๊ฐ์ฅ ๋จผ์  ๋ฐฉ์ถํ๋ ์ด๋ ์ต์ ๋ฒ๋ธ์ ๋ฐฉ์ถ

Observable.from([redCircle, greenCircle, blueCircle]) // ๋ ๋์ ๊ทธ๋ฆฐ์ ๋ฐ๊พผ๋ค๋ฉด ๊ทธ๋ฆฐ์ด ์ ์ผ ์ฒซ๋ฒ์งธ ์ด๋ ์ต์ ๋ฒ๋ธ์ด ๋จ!
    .flatMapFirst { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart)
                .take(5) // ์ฒซ๋ฒ์งธ ์ด๋ ์ต์ ๋ฒ๋ธ
        case greenCircle:
            return Observable.repeatElement(greenHeart)
                .take(5) // ๋๋ฒ์จฐ ์ด๋ ์ต์ ๋ฒ๋ธ
        case blueCircle:
            return Observable.repeatElement(blueHeart)
                .take(5) // ์ธ๋ฒ์งธ ์ด๋ ์ต์ ๋ฒ๋ธ
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// ๊ฐ์ฅ ๋จผ์  ์ด๋ฒคํธ ๋ฐฉ์ถ์ ์์ํ ์ต์ ๋ฒ๋ธ๋ง ์ฌ์ฉ -> ๋นจ๊ฐ ํํธ๋ง ๋ฐฉ์ถ


//: [Next](@next)





