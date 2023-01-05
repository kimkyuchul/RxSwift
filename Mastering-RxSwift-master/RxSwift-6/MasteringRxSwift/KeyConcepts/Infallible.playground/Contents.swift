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
 # Infallible
 */
//에러 이벤트가 방출되지 않는 옵저버블
enum MyError: Error {
    case unknown
}

let observable = Observable<String>.create { observer in
    observer.onNext("Hello")
    observer.onNext("Observable")
    
    //observer.onError(MyError.unknown)
    
    observer.onCompleted()
    
    return Disposables.create()
}

// next와 completed만 방출하고 에러는 방출하지 않음
// Infallible은 리소스를 공유하지 않음
// 나중에 스케줄러 공부할 때 확인하기
let infallible = Infallible<String>.create { observer in
    
    //observer.onNext("Hello")
    observer(.next("hello"))
    
    observer(.completed)
    
    return Disposables.create()
}











