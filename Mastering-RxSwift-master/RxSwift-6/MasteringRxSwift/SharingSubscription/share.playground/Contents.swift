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
 # share
 */
// 이 연산자를 설명하기에 앞서 multicast, publish, replay, refCount 기능이 통합된 연산자임
// share연산자가 리턴하는 옵저버블은 refCount옵저버블
// replay: 버퍼 사이즈
// whileConnected: 새로운 구독자(커넥션)가 추가되면 서브젝트를 생성하고 이어지는 구독자는 이 서브젝트를 공유, 커넥션이 종료되면 서브젝트는 사라지고 커넥션마다 새로운 서브젝트가 생성됨 → 커넥션은 다른 커넥션과 격리되어있음(isolated)
// forever: 모든 구독자(커넥션)이 하나의 서브젝트를 공유함
let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug()
    //.share() // replay: 0, scope: whileConnected(기본값)
    //.share(replay: 5) // 버퍼에 저장되어있던 레드볼 0, 1이 같이 전달
    .share(replay: 5, scope: .forever) // 모든 구독자가 하나의 서브젝트를 구독. 서브젝트를 공유만될분 sequence는 새로 시작됨( 검정볼 0,1,2,3,4 나온 후 -> 시퀀스 새로 시작 검정볼 0,1,2)

let observer1 = source
    .subscribe { print("🔵", $0) }

let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

// 모든 구독이 중지되면 내부에있는 커넥터블 옵저버블 역시 중지된다. 서브젝트를 공유하고있음

DispatchQueue.main.asyncAfter(deadline: .now() + 7) { //서브젝트는 사라지고 새로운 서브젝트를 생성
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

// https://huniroom.tistory.com/entry/RxSwift-sharing-Subscription-Operator-share

/*
----- RESULT ----- (replay: 0, scope: .whileConnected)
-> subscribed
-> Event next(0)
🔵 next(0)
-> Event next(1)
🔵 next(1)
-> Event next(2)
🔵 next(2)
-> Event next(3)
🔵 next(3)
🔴 next(3)
-> Event next(4)
🔵 next(4)
🔴 next(4)
-> isDisposed
-> subscribed
-> Event next(0)
⚫️ next(0)
-> Event next(1)
⚫️ next(1)
-> Event next(2)
⚫️ next(2)
-> isDisposed


----- RESULT -----(replay: 5, scope: .whileConnected)
-> subscribed
-> Event next(0)
🔵 next(0)
-> Event next(1)
🔵 next(1)
-> Event next(2)
🔵 next(2)
🔴 next(0)
🔴 next(1)
🔴 next(2)
-> Event next(3)
🔵 next(3)
🔴 next(3)
-> Event next(4)
🔵 next(4)
🔴 next(4)
-> isDisposed
-> subscribed
-> Event next(0)
⚫️ next(0)
-> Event next(1)
⚫️ next(1)
-> Event next(2)
⚫️ next(2)
-> isDisposed


----- RESULT -----(replay: 5, scope: .forever)
-> subscribed
-> Event next(0)
🔵 next(0)
-> Event next(1)
🔵 next(1)
-> Event next(2)
🔵 next(2)
🔴 next(0)
🔴 next(1)
🔴 next(2)
-> Event next(3)
🔵 next(3)
🔴 next(3)
-> Event next(4)
🔵 next(4)
🔴 next(4)
-> isDisposed
⚫️ next(0)
⚫️ next(1)
⚫️ next(2)
⚫️ next(3)
⚫️ next(4)
-> subscribed
-> Event next(0)
⚫️ next(0)
-> Event next(1)
⚫️ next(1)
-> Event next(2)
⚫️ next(2)
-> isDisposed
*/








