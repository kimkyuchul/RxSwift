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
 # sample
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

// dataObservable.withLatestFrom(triggerObservable)
// 연산자를 호출하는 옵저버블(dataObservable), 파라미터로 전달하는 옵저버블(triggerObservable)
// triggerObservable가 넥스트 이벤트를 전달 할 때 마다, dataObservable이 가장 최근 이벤트를 방출
// 이 부분은 withLatestFrom와 같음 하지만 동일한 넥스트 이벤트를 반복해서 방출하지 않는다는 차이가 있다.
// 동일한 넥스트 이벤트를 반복해서 방출하지 않는다는 차이가 중요

data.sample(trigger)
    .subscribe { print($0) }
    .disposed(by: bag)

trigger.onNext(()) // 아직 data 서브젝트가 넥스트 이벤트를 전달하지 않았기 때문에 전달되지 않음
data.onNext("hi") //이 때 바로 전달 안댐

trigger.onNext(())
trigger.onNext(()) //넥스트 이벤트 방출 안됨. 동일한 이벤트를 2번이상 방출안함.

//data.onCompleted()
//trigger.onNext(()) // Completed를 그대로 전달

data.onError(MyError.error)








