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
 # concat
 */

let bag = DisposeBag()
let fruits = Observable.from(["๐", "๐", "๐ฅ", "๐", "๐", "๐"])
let animals = Observable.from(["๐ถ", "๐ฑ", "๐น", "๐ผ", "๐ฏ", "๐ต"])

// //๋๊ฐ์ ์ต์ ๋ฒ๋ธ ์ฐ๊ฒฐํ  ๋ ์ฌ์ฉ
// ์ฌ๋ฌ Sequence๋ฅผ ์์๋๋ก ๋ฌถ์

Observable.concat([fruits, animals])
    .subscribe { print($0) }
    .disposed(by: bag)

// ์ธ์คํด์ค ๋ฉ์๋๋ก ์ฐ๊ฒฐ๋ concat
fruits.concat(animals)
    .subscribe { print($0) }
    .disposed(by: bag)

animals.concat(fruits)
    .subscribe { print($0) }
    .disposed(by: bag)

// ์ฒซ ๋ฒ์งธ Sequence๊ฐ ์๋ฃ๋  ๋๊น์ง ๊ตฌ๋ํ๊ณ  ๋ค์ Sequence๋ฅผ ๊ฐ์ ๋ฐฉ๋ฒ์ผ๋ก ๊ตฌ๋
// Observable.concat(_:)๊ณผ ๋ฌ๋ฆฌ .concat(_:)์ ์์๋ค์ด ๊ฐ์ ํ์์ผ ๋ ๊ฐ๋ฅํฉ๋๋ค.













