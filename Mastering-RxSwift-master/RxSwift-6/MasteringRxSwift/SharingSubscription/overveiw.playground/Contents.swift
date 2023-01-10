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
 # Sharing Subscriptions
 */

let bag = DisposeBag()

let source = Observable<String>.create { observer in
    let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html)
        }
        
        observer.onCompleted()
    }
    task.resume()
    
    return Disposables.create {
        task.cancel()
    }
}
.debug()
.share() // 구독자가 공유하게 된다. 첫번째 말고는 공유할 구독이 있기 때문에 실행되지 않는다.

// 구독자가 추가되면 항상 새로운 sequence가 실행된다.
// -> 클라이언트에서 불필요한 리소스를 낭비하게 된다.
// 데이터베이스에 접근하거나 파일을 읽는경우도 마찬가지이다.
// -> 모든 구독자가 하나의 구독을 공유하도록 구현해야 한다.
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)








