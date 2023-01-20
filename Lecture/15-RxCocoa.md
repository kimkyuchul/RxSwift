## **Cocoa Touch 방식**

```swift
@IBAction func onTap(_ sender: Any) {
        valueLabel.text = "Hello, Cocoa Touch"
    }
```

- Cocoa Touch에서의 버튼 탭 방식.

## RxCocoa

```swift
tapButton.rx.tap
            .map { "hello, RxCocoa"}
//            .subscribe(onNext: { [weak self] str in
//                self?.valueLabel.text = str // CocoaTouch가 제공하는 옵셔널 스트링 형식
//            })
            .bind(to: valueLabel.rx.text) 
            .disposed(by: bag)
        
    }
}
```

- **RxCocoa에서의 버튼 탭 방식.**
- bind는 RxCocoa가 자동으로 합성한 바인더 (일반 속성과 타입이 다름)
- **rx.text 는 바인더 속성 UILabel.text의 속성과는 다르다.**

## Binding

- `Observable` 타입을 채용한 모든 형식이 생산자(Producer)
- `Label` 이나 `ImageView` 같은 UI 컴포넌트는 소비자(Consumer)
- 생산자가 생산한 데이터는 소비자한테 전달되고 소비자는 적절한 방법으로 데이터를 사용
    - ex) 레이블(소비자)은 전달받은 텍스트를 화면에 표시
    - 반대로 소비자(UI 컴포넌트)가 생성자에게 데이터나 이벤트를 전달하는 경우는 없음
- Binder는 UI Binding에 사용되는 특별한 `Observer`로 데이터 소비자의 역할을 수행
- `Observer` 이기 때문에 Binder로 새로운 값을 전달할 수는 있지만, `Observable`이 아니기 때문에 구독자를 추가하는 것은 불가
- Binder는 `Error` 이벤트를 받지 않고 `Next`, `Completed` 이벤트만 전달
- `Main Thread` 에서 실행되는것을 보장

```swift
        valueField.rx.text
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] str in
                self?.valueLabel.text = str
            })
            .disposed(by: disposeBag)
        
// bind 사용
        valueField.rx.text // ControlProperty
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
```

## RxCocoa Traits

- UI에 특화된 옵저버블
- 옵저버블이기 때문에 ui 바인딩에서 데이터 생산자 역할을 한다. (바인더와 반대)
- **Traits는 UI에 특화된 옵저버블이고, 모든 작업은 메인 스케줄러** = 메인 스레드에서 실행됨
    - UI 업데이트 코드를 작성할 때 스케줄러를 지정할 필요가 없음
- 옵저버블 시퀀스가 에러로 인해 종료되면 UI는 더이상 업데이트 되지 않음 하지만, **Traits는 에러 이벤트를 전달하지 않음 → 그래서 UI가 항상 올바른 스레드에서 업데이트 되는 것을 보장**

## Traits 특징

- 옵저버블을 구독하면 기본적으로 새로운 시퀀스가 생김
- **Traits** 역시 옵저버블이지만, 새로운 시퀀스가 생기지 않음
- **Traits**를 구독하는 모든 구독자는 동일한 시퀀스를 공유(share)
- **코드가 지저분해지고 UI가 잘못된 스레드에서 실행되는 것을 방지하기 위해 사용!**

### Traits 잠깐 정리

- UI에 특화된 옵저버블
- 메인 스레드에서 실행
- 에러 이벤트 전달 ❌
- 새로운 시퀀스 시작 ❌
- 모든 구독자는 동일한 시퀀스 공유

## Driver

- 데이터를 UI에 바인딩하는 직관적인 방법을 제공
- Driver는 에러 메시지를 전달하지 않음 → 오류로 인해 UI 처리가 중단되는 상황 발생 X
- 스케줄러를 강제로 변경하는 것을 제외하고 항상 메인 스케줄러에서 작업을 수행
- 이벤트는 항상 메인 스케줄러에서 전달되고, 이어지는 작업 역시 메인 스케줄러에서 실행
- Driver는 사이드 이펙트를 공유 → 일반 옵저버블에서 Share 연산자를 호출하고 화면에 있는 파라미터를 전달하는 것과 동일하게 동작
    - 모든 구독자가 시퀀스를 공유하고 새로운 구독을 시작하면 가장 최근에 전달한 이벤트가 즉시 전달
- Driver를 사용하기 위해선 기존 옵저버블에 asDriver() 연산자를 추가

```swift
let result = inputField.rx.text
            .flatMapLatest { // flatMapLatest 마지막으로 추가된 시퀀스의 옵저버블을 넘겨줌
                validateText($0) // 문자열 체크결과 Bool
                    .observe(on: MainScheduler.instance) // flatMapLastest의 inner 옵저버블이 백그라운드에서 동작할때를 대비해서 메인스케쥴러에서 동작 하도록 강제
                    .catchAndReturn(false) // catchAndReturn을 통해 에러가 발생하면 false 리턴
            }
            .share()
        
        result
            .map { $0 ? "Ok" : "Error" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: bag)
        
        result
            .map { $0 ? UIColor.blue : UIColor.red }
            .bind(to: resultLabel.rx.backgroundColor)
            .disposed(by: bag)
        
        result
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: bag)
```

```swift
let result = inputField.rx.text.asDriver() // driver는 시퀀스를 공유하기 때문에 share() 필요 없음
            .flatMapLatest { // flatMapLatest 마지막으로 추가된 시퀀스의 옵저버블을 넘겨줌
                validateText($0) // 문자열 체크결과 Bool
                    .asDriver(onErrorJustReturn: false)
            }
        
        result
            .map { $0 ? "Ok" : "Error" }
            .drive(resultLabel.rx.text)
            .disposed(by: bag)
        
        result
            .map { $0 ? UIColor.blue : UIColor.red }
            .drive(resultLabel.rx.backgroundColor)
            .disposed(by: bag)
        
        result
            .drive(sendButton.rx.isEnabled)
            .disposed(by: bag)
```