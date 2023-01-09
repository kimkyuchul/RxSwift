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
 # combineLatest
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()

// 합쳐질때 이벤트를 방출함.
// 여러 Observable에서 가장 최신의 값을 병합하여 방출
// 한 번 값을 방출한 이후에는 클로저가 각각의 Observable이 방출하는 최신의 값을 받음

Observable.combineLatest(greetings, languages) { lhs, rhs -> String in
    return "\(lhs) \(rhs)"
}
.subscribe{ print($0) }
.disposed(by: bag)

// 구독과 동시에 이벤트를 받고 싶다면 -> startWith로 초깃값을 설정하거나, BehaviorSubject를 활용 !
greetings.onNext("HI")
languages.onNext("world!")

greetings.onNext("hello")
languages.onNext("RxSwift")

greetings.onError(MyError.error) // 바로 종료

//greetings.onCompleted() // 아직 languages가 onCompleted 안되서 Completed 전달 안댐
languages.onNext("SwiftUI")

languages.onCompleted() // completed







