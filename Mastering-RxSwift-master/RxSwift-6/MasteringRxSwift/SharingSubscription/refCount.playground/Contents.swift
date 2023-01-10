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
 # refCount
 */
//connectableObservable에서만 사용할 수 있음.
// 내부에 ConnectableObservable을 유지하면서 새로운 구독자가 생성되는 시점에 자동으로 connect() 시켜줌

let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().publish().refCount()

let observer1 = source
    .subscribe { print("🔵", $0) }
// 첫번째 구독자가 추가되면 refCount옵저버블이 connect메소드를 호출한다.
// connectableObservable은 subject를 통해서 모든 구독자에게 이벤트를 전달한다.
// 더이상 구독자가 없다면 disconnect됨

// source.connect()

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    observer1.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer2 = source.subscribe { print("🔴", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer2.dispose()
    }
}

// 출력 로그를 보면 🔵 옵저버블이 isDisposed 된후에 🔴 옵저버블이 다시 구독을 시작해서 새로운 시퀀스로 이벤트를 방출합니다












