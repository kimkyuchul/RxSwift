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
 # timeout
 */


let bag = DisposeBag()

let subject = PublishSubject<Int>()

//subject.timeout(.seconds(3), scheduler: MainScheduler.instance) //3초안에 이벤트가 전달되지 않으면 에러이벤트 발생하고 종료
//    .subscribe { print($0) }
//    .disposed(by: bag)

subject.timeout(.seconds(3), other: Observable.just(0), scheduler: MainScheduler.instance) // 두 번째 이벤트는 other의 0이 전달한 것, 3초의 outtime이 경과하면 other : Source 를 구독자에게 전달하며 종료
    .subscribe { print($0) }
    .disposed(by: bag)

Observable<Int>.timer(.seconds(2), period: .seconds(5), scheduler: MainScheduler.instance) // 첫번째 파라미터 5초 설정 시 타임아웃 에러, 첫 번쨰 파라미터 2, 두 번째 파라미터 5면 -> 0, 에러
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)




let button = UIButton(type: .system)
button.setTitle("눌러주세요", for: .normal)
button.sizeToFit()

// timeout.current.liveView = button

button.rx.tap
    .do(onNext: {
        print("tapped")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

// 5초 동안 탭 이벤트가 없으면 에러

