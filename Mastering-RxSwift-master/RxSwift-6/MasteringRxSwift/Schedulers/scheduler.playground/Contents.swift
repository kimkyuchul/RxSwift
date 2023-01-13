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
 # Scheduler
 */
// 옵저버블이 생성되는 시점을 잘 이해해야 한다
// observeOn과 subscribeOn의 차이를 알기!
let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observe(on: backgroundScheduler) // 이 아래부터는 다 백그라운드 스레드에서 실행된다. 이어지는 연산자가 실행하는 스케줄러를 지정한다. observe(on:) 메서드로 지정한 스케줄러는 다른 스케줄러로 변경하기 전까지 계속 사용됨
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
// 아무것도 출력되지 않음 -> 옵저버블이 생성된 것도 아니고 연산자가 호출된 것도 아님
// 옵저버블이 어떤 요소를 방출하고, 어떻게 처리해야할 지를 나타낼 뿐이다.
// 옵저버블이 생성되고 연산자가 호출되는 시점은 바로 구독이 시작되는 시점!!
    .subscribe(on: MainScheduler.instance) //subscribe 메서드가 호출하는 스케줄러를 지정하는 것이 아님, 이어지는 연산자가 호출되는 스케줄러를 지정하는 것도 아님
// 옵저버블이 시작되는 시점에 어떠한 스케줄러를 사용할지 지정하는 것!
// observe(on:)과 달리 호출 시점이 중요하지 않음 (어디서 호출해도 상관 없음)
    .observe(on: MainScheduler.instance) // subscribe를 메인 스레드에서 실행하고 싶다면.
    .subscribe {
          print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
          print($0)
       }
    .disposed(by: bag)

