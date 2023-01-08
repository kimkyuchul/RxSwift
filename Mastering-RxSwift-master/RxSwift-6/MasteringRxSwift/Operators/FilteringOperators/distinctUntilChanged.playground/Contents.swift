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
 # distinctUntilChanged
 */

struct Person {
    let name: String
    let age: Int
}

let disposeBag = DisposeBag()
let numbers = [1, 1, 3, 2, 2, 3, 1, 5, 5, 7, 7, 7]
let tuples = [(1, "하나"), (1, "일"), (1, "one")]
let persons = [
    Person(name: "Sam", age: 12),
    Person(name: "Paul", age: 12),
    Person(name: "Tim", age: 56)
]

// 동일한 항목이 연속적으로 방출되지 않도록 필터링 해줌
// 이전과 똑같은 이벤트라면 방출하지 않음

Observable.from(numbers)
    // 이벤트를 비교하는 코드를 직접 구현하고 싶다면 클로저 사용
    .distinctUntilChanged{ !$0.isMultiple(of: 2) && !$1.isMultiple(of: 2) } // 값이 홀수면 그냥 같은 값으로 판단 -> 실행결과를 보면 연속된 홀수를 방출하지 않음
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

Observable.from(tuples)
// key
    //.distinctUntilChanged { $0.0 } // 저장된 값 중 첫번째 값이 리턴
    .distinctUntilChanged { $0.1 } // 튜플에서 두번째 값은 모두 다른 값 -> 모든 이벤트를 구독자에게 전달
    .subscribe{ print($0) }
    .disposed(by: disposeBag)


// keypath를 활용해서 나이를 기준으로 이벤트를 비교
Observable.from(persons)
    .distinctUntilChanged(at: \.age) // 같은 나이(paul) 는 전달되지 않음
    .subscribe{ print($0) }
    .disposed(by: disposeBag)



    




