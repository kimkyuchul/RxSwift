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
 # debounce
 */


let disposeBag = DisposeBag()

// debounce, throttle. 둘 다 짧은시간동안 반복적으로 방출되는 이벤트를 제어함
// 지정된 시간동안 새로운 이벤트가 방출 되지 않으면 가장 마지막에 전달된 이벤트를 구독자에게 전달한다.
// 지정된 시간 이내에 넥스트 이벤트를 방출헸다면 타이머를 초기화 함
// 타이머를 초기화 하고 다시 지정된 시간동안 대기한다 -> 이 시간 이내에 다른 이벤트가 방출되지 않는다면 마지막 이벤트를 방출하고, 이벤트가 방출된다면 타이머를 초기화 한다.
// debounce는 이벤트가 전달된 다음 지정된 시간까지 다음 이벤트가 전달되지 않는다면 방출.

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1)
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create {
      
   }
}

buttonTap
    // 파라미터로 1초
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) } // 10, 20
   .disposed(by: disposeBag)

// 지정된 시간동안 새로운 이벤트가 방출 되지 않으면 가장 마지막에 전달된 이벤트를 구독자에게 전달
// 위의 포문은 둘다 0.3, 0.5초마다 요소를 방출하는데 디바운스 파라미터로 1초를 지정했기 때문에 모두 방출되지 않고 마지막 파라미터인 10, 20이 방출되는 것
// 타이머를 지정해두고 타이머가 끝난 시점에 가장 최근의 값을 방출해준다.

