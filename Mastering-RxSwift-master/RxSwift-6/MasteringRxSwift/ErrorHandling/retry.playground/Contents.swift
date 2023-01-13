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
 # retry
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")
    
    if attempts < 5 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    
    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

source
    .retry(7) // 인자 값을 안주면 에러가 발생 안할때 까지 반복함. 따라서 무한루프가 발생하지 않도록 주의해야한다.
    //재시도 횟수를 넣을 땐 원하는 횟수 +1 해야 함
    .subscribe { print($0) }
    .disposed(by: bag)

//네트워크 요청에서 제대로 된 값을 받지 못했을 경우, 재시도를 한다.
//최대 값만큼 재시도를 한 경우 에러전달하고 끝냄
//만약 사용자가 신호를 줬을때 재시도를 하고 싶을때는 retryWhen을 씀.




