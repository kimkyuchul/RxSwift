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
 # throttle
 */

let disposeBag = DisposeBag()

// debounce, throttle. 둘 다 짧은시간동안 반복적으로 방출되는 이벤트를 제어함
// 지정된 주기 동안 하나의 이벤트만 구독자에게 전달
// 특정시간동안 발생한 이벤트 중 가장 최신의 이벤트를 방출
// ex) Tap을 여러번 했을 때 최신의 이벤트만 방출

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
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) } // 1초마다 하나씩 전달됨
   .disposed(by: disposeBag)

//throttle, debounce 차이점
//throttle 연산자는 넥스트 이벤트를 지정된 주기마다 하나씩 방출한다. -> 탭 이벤트나 델리게이트 구현할 떄 사용
//debounce는 이벤트가 전달된 다음 지정된 시간까지 다음 이벤트가 전달되지 않는다면 방출. -> 검색 기능을 구현할 때 사용 ( 사용자가 키워드를 입력할 때마다 네트워크 및 디비를 검색해야 한다 침 -> 문자가 입력될 때마다 검색하는건 효율적이지 않음. 사용자가 짧은 시가동안 문자를 검색할 땐 작업이 실행되지 않음. 그러다가 지정된 시간동안 문자가 입력되지 않으면 검색 작업을 시작함 -> 실시간 검색 기능을 구현 가능 )

//: [Next](@next)
