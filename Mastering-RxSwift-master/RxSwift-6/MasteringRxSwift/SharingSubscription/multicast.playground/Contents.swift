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
 # multicast
 */

let bag = DisposeBag()
let subject = PublishSubject<Int>() // 멀티캐스트 이용하려면 있어야됨

// multicast 연산자는 하나의 옵저버블을 공유할떄 사용하는 연산자. 하지만 서브젝트를 따로 생성하고 이벤트가 방출되길 원하는 시점에 .connect() 를 호출해 주어야 함
// 원본 옵저버블에서 발생하는 이벤트는 구독자로 전달되는게 아니라 전달한 서브젝트로 이벤트가 전달
// 그리고 서브젝트는 이벤트를 등록된 다수의 구독자에게 전달
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).multicast(subject)

// 두개의 시퀀스가 개별적으로 시작되었고, 서로 공유되지 않음 (Rxswift의 기초 개념)

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect() // connect을 호춣해야 시퀀스가 시작됨
// 원본 옵저버블이 시퀀스가 시작되고 모든 이벤트는 파라미터로 전달한 서브젝트로 전달, 그리고 이 서브젝트는 등록된 모든 구독자에게 이벤트를 전달
//공유하기 전에는 두개의 구독자가 따로따로 실행된다.
//공유된 후에는 $0 이부분이 공유되고 있음을 확인 할 수 있다.
// 따라서 3초전에는 빨간공은 안나옴 !
// multicast를 통해서 이벤트가 시작되는 시퀀스가 동일해짐
//멀티캐스트를 직접사용하기보단, 멀티캐스트를 이용한 다른 연산자를 사용하는 경우가 많음.



















