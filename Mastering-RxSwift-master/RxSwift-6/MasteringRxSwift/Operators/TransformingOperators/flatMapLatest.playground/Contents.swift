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
 # flatMapLatest
 */

let disposeBag = DisposeBag()

let redCircle = "🔴"
let greenCircle = "🟢"
let blueCircle = "🔵"

let redHeart = "❤️"
let greenHeart = "💚"
let blueHeart = "💙"

let sourceObservable = PublishSubject<String>()
let trigger = PublishSubject<Void>()

// 모든 이너 옵저버블이 방출하는 이벤트를 하나로 병합하지 않음
// 원본 옵저버블이 이벤트를 방출하고, 새로운 이너 옵저버블이 생성되면 기존에 있던 이너 옵저버블은 이벤트 방출을 중단하고 종료
// 이때부터 새로운 이너 옵저버블이 이벤트 방출을 시작하고 result 옵저버블은 이 이너 옵저버블을 전달

sourceObservable
    .flatMapLatest { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in redHeart}
                .take(until: trigger) // 트리거로 사용하는 옵저버블에서 이벤트를 방출하기 전까지만 방출
        case greenCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in greenHeart}
                .take(until: trigger)
        case blueCircle:
            return Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
                .map { _ in blueHeart}
                .take(until: trigger)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceObservable.onNext(redCircle)

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    sourceObservable.onNext(greenCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    sourceObservable.onNext(blueCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    sourceObservable.onNext(redCircle)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    trigger.onNext(())
}

// 새로운 이너 옵저버블이 생성되면 기존 옵저버블은 바로 종료
// flatMap 에서 가장 최신의 값만을 확인하고 싶을 때 사용
// flatMap과 동일하게 이벤트가 들어오면 새로운 Observable을 만듬 하지만 새 Observable을 생성하면 자동적으로 이전의 Observable 구독을 해지

struct Student {
  var score: BehaviorSubject<Int>
}

let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))

let student = PublishSubject<Student>()

student
   .flatMapLatest {
       $0.score
}
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)

student.onNext(ryan)
ryan.score.onNext(85)

student.onNext(charlotte)
ryan.score.onNext(95)
charlotte.score.onNext(100)


// first와 Latest의 차이
// first -> 가장 먼저 이벤트 방출을 시작한 옵저버블만 방츨
// Latest -> 가장 최신의 값을 방출 ( 즉, 가장 늦게 방출된 이벤트)
