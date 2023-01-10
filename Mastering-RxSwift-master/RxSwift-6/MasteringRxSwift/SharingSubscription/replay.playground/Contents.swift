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
 # replay, replayAll
 */
// 컨넥티드 옵저버에 버퍼를 추가하고, 새로운 구독자에게 최근 이벤트를 전달
// multicast에 전달하는 파라미터 타입이 RepaySubject 라면 replay를 통해 단순화
// replay를 활용하면 3초뒤에 방출되어 전달받지 못했던 빨간 원 0, 1 값을 버퍼에 저장해두었다가 방출해줌.
let bag = DisposeBag()
// let subject = PublishSubject<Int>() 퍼블리시 서브젝트는 버퍼를 가지고 있지 않기 때문에 필요 없음
// let subject = ReplaySubject<Int>.create(bufferSize: 5) // 빨간 원 0과 1도 받음!
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).replay(5) // 버퍼 크기 5

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect()

//만약 3초 이전의 값들을 가져오고 싶다면, PublishSubject-> ReplaySubject로 바꾸면됨.

//replayall은 메모리 제한이 없어 특별한 이유가 없다면 사용하지 않아야함.
//버퍼크기를 제한해줄수 있는 replay는 메모리 효율을 위해 최소한으로 정하고 사용해야한다.













