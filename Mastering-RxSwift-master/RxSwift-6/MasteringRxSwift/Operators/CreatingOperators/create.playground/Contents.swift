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
 # create
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// 앞에서 공부한 연산자들은 파라미터로 전달된 요소를 방출하는 옵저버블을 생성
// 이러한 옵저버블은 모든 요소를 방출하고 컴플리트를 전달하고 종료된다 -> 옵저버블의 기본 동작
// 앞에서 공부한 연산자로는 옵저버블의 기본 동작을 조작 할 수 없다.
// 옵저버블이 동작하는 방식을 직접 구현하고 싶다면 create을 사용

//url에서 html을 다운 받고 문자열을 방출
Observable<String>.create { (observer) in // 옵저버블을 파라미터로 받아서 dispose을 방출
    guard let url = URL(string: "https://apple.com") else {
        observer.onError(MyError.error) //클로저로 전달된 파라미터
        return Disposables.create() // Disposables!! s 안붙으면 안댐
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    // 문자열이 정상적으로 저장된 상태 그다음 옵저버로 전달(문자열을 방출)
    observer.onNext(html)
    observer.onCompleted()
    
    observer.onNext("hi") // onComplete 이후이기 때문에 방출되지 않음

    return Disposables.create()
}
.subscribe{ print($0) }
.disposed(by: disposeBag)

// 요소를 방출할 때는 onNext를 사용하고 파라미터로 방출할 요소를 전달
// 옵저버블은 기본적으로 하나 이상의 요소를 전달하지만 그러지 않을 때도 있다.
// 그래서 반드시 onNext를 호출해야 하는 것은 아니다.
// 반면 옵저버블을 종료하기 위해선 onCompleted, onError를 반드시 호출해야 함
// onNext가 호출되기 위해선 onCompleted, onError가 호출되기 전에 선언되어야 함


