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
 # withLatestFrom
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

// triggerObservable.withLatestFrom(dataObservable)
// 연산자를 호출하는 옵저버블(triggerObservable), 파라미터로 전달하는 옵저버블(dataObservable)
// triggerObservable가 넥스트 이벤트를 방출하면, dataObservable이 가장 최근에 방출한 넥스트 이벤트를 구독자에게 전달
// ex) 회원가입 버튼을 누를 때 텍스트 필드에 입력된 값들을 가져올 때 사용 할 수 있음

trigger.withLatestFrom(data)
    .subscribe { print($0) }
    .disposed(by: bag)

data.onNext("hello") // 아직 trigger 서브젝트가 넥스트 이벤트를 전달하지 않았기 때문에 전달되지 않음
trigger.onNext(())
trigger.onNext(()) // 트리거 옵저버블로 넥스트 이벤트가 전달되면 데이터 옵저버블에 있는 최신 넥스트 이벤트를 구독자에게 전달

//data.onCompleted() // onCompleted 전달 안됨
//data.onError(MyError.error) // error는 바로 전달
//trigger.onNext(())
trigger.onCompleted() // 바로 구독자에게 전달됨

// 한쪽 Observable의 이벤트가 발생할 때 두개의 Observable을 병합
// 트리거 옵저버블에서 Next 이벤트가 발생하면 데이터 옵저버블에서 발생한 가장 최근 Next이벤트가 방출






