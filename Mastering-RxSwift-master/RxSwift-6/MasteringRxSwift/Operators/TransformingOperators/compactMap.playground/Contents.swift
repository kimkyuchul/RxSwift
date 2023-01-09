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
 # compactMap
 */

let disposeBag = DisposeBag()

// 옵저버블이 방출하는 이벤트에서 값을 꺼낸 다음 옵셔널 형태로 바꾸고 원하는 변환을 실행
// 그리고 최종 이벤트 결과가 nil이면 해당 이벤트는 전달하지 않고 필터링 한다.

let subject = PublishSubject<String?>()

subject
//    .filter { $0 != nil } // 만약 nil 값을 배출하고 싶지 않다면 -> 그러나 구독자로 전달하는 별이 여전히 옵셔널 형태로 전달됨 (언래핑이 필요)
//    .map { $0! } // 강제 언래핑
    .compactMap { $0 } // nil은 필터링 되고 언래핑되서 반환댐
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(10)
    .map { _ in Bool.random() ? "⭐️" : nil }
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: disposeBag)

// 옵저버블이 방출하는 데이터를 대상으로 변환을 실행
// 변환 결과가 nil이면 무시하고 방출하지 않음
// 반대로 결과가 nil이 아니면 언래핑 해서 방출 해줌!
