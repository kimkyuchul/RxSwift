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
 # ReplaySubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// 두개 이상의 이벤트를 저장해두고, 새로운 구독자로 전달하고 싶다면 ReplaySubject을 사용
// ReplaySubject는 bufferSize 개의 이벤트를 저장해 subscribe 될 때 저장된 이벤트를 모두 방출

let rs = ReplaySubject<Int>.create(bufferSize: 3) // 3개의 이벤트를 저장하는 버퍼가 생성된 것

(1...10).forEach { rs.onNext($0) }

rs.subscribe{ print("Observer 1 >>", $0) }
    .disposed(by: disposeBag)

// 버퍼에는 마지막에 저장된 3개의 이벤트만 저장되므로 8,9,10이 나올것

rs.subscribe{ print("Observer 2 >>", $0) }
    .disposed(by: disposeBag)

rs.onNext(11) //가장오래된 애를 삭제하고 11이 추가된것

rs.subscribe{ print("Observer 3 >>", $0) }
    .disposed(by: disposeBag)

//rs.onCompleted()
rs.onError(MyError.error)

rs.subscribe{ print("Observer 4 >>", $0) } //버퍼에 저장되어있는 이벤트가 전달된 다음에 Completed 이벤트가 전달됨
    .disposed(by: disposeBag)


// 종료 여부에 상관없이 항상 버퍼에 저장되어있는 이벤트를 구독자에게 전달
// 버퍼는 메모리에 저장되기 때문에 메모리 사용량에 신경 써야함
// 필요이상의 메모리는 쓰는것은 X
// 사용 : 최신의 여러 값들을 보여주고 싶을 때 사용 (최근 검색어)




