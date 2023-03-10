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
 # flatMapLatest
 */

let disposeBag = DisposeBag()

let redCircle = "๐ด"
let greenCircle = "๐ข"
let blueCircle = "๐ต"

let redHeart = "โค๏ธ"
let greenHeart = "๐"
let blueHeart = "๐"

let sourceObservable = PublishSubject<String>()
let trigger = PublishSubject<Void>()

// ๋ชจ๋  ์ด๋ ์ต์ ๋ฒ๋ธ์ด ๋ฐฉ์ถํ๋ ์ด๋ฒคํธ๋ฅผ ํ๋๋ก ๋ณํฉํ์ง ์์
// ์๋ณธ ์ต์ ๋ฒ๋ธ์ด ์ด๋ฒคํธ๋ฅผ ๋ฐฉ์ถํ๊ณ , ์๋ก์ด ์ด๋ ์ต์ ๋ฒ๋ธ์ด ์์ฑ๋๋ฉด ๊ธฐ์กด์ ์๋ ์ด๋ ์ต์ ๋ฒ๋ธ์ ์ด๋ฒคํธ ๋ฐฉ์ถ์ ์ค๋จํ๊ณ  ์ข๋ฃ
// ์ด๋๋ถํฐ ์๋ก์ด ์ด๋ ์ต์ ๋ฒ๋ธ์ด ์ด๋ฒคํธ ๋ฐฉ์ถ์ ์์ํ๊ณ  result ์ต์ ๋ฒ๋ธ์ ์ด ์ด๋ ์ต์ ๋ฒ๋ธ์ ์ ๋ฌ

sourceObservable
    .flatMapLatest { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in redHeart}
                .take(until: trigger) // ํธ๋ฆฌ๊ฑฐ๋ก ์ฌ์ฉํ๋ ์ต์ ๋ฒ๋ธ์์ ์ด๋ฒคํธ๋ฅผ ๋ฐฉ์ถํ๊ธฐ ์ ๊น์ง๋ง ๋ฐฉ์ถ
        case greenCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in greenHeart}
                .take(until: trigger)
        case blueCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in blueHeart}
                .take(until: trigger)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceObservable.onNext(redCircle)

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    sourceObservable.onNext(greenCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    sourceObservable.onNext(blueCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    sourceObservable.onNext(redCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    trigger.onNext(())
}

// ์๋ก์ด ์ด๋ ์ต์ ๋ฒ๋ธ์ด ์์ฑ๋๋ฉด ๊ธฐ์กด ์ต์ ๋ฒ๋ธ์ ๋ฐ๋ก ์ข๋ฃ
// flatMap ์์ ๊ฐ์ฅ ์ต์ ์ ๊ฐ๋ง์ ํ์ธํ๊ณ  ์ถ์ ๋ ์ฌ์ฉ
// flatMap๊ณผ ๋์ผํ๊ฒ ์ด๋ฒคํธ๊ฐ ๋ค์ด์ค๋ฉด ์๋ก์ด Observable์ ๋ง๋ฌ ํ์ง๋ง ์ Observable์ ์์ฑํ๋ฉด ์๋์ ์ผ๋ก ์ด์ ์ Observable ๊ตฌ๋์ ํด์ง

struct Student {
  var score: BehaviorSubject<Int>
}

let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))

let student = PublishSubject<Student>()

student
   .flatMapLatest {
       $0.score
}
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)

student.onNext(ryan)
ryan.score.onNext(85)

student.onNext(charlotte)
ryan.score.onNext(95)
charlotte.score.onNext(100)


// first์ Latest์ ์ฐจ์ด
// first -> ๊ฐ์ฅ ๋จผ์  ์ด๋ฒคํธ ๋ฐฉ์ถ์ ์์ํ ์ต์ ๋ฒ๋ธ๋ง ๋ฐฉ์ธจ
// Latest -> ๊ฐ์ฅ ์ต์ ์ ๊ฐ์ ๋ฐฉ์ถ ( ์ฆ, ๊ฐ์ฅ ๋ฆ๊ฒ ๋ฐฉ์ถ๋ ์ด๋ฒคํธ)
