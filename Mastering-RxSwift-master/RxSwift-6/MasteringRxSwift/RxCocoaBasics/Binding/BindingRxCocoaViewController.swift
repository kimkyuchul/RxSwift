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
import RxCocoa

//ControlProperty: 데이터를 특정 UI에 바인딩할때 사용하는 특별한 옵저버블

class BindingRxCocoaViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = ""
        valueField.becomeFirstResponder()
        
        
//        valueField.rx.text
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] str in
//                self?.valueLabel.text = str
//            })
//            .disposed(by: disposeBag)
        
        valueField.rx.text // ControlProperty
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // 텍스트를 입력하면 텍스트필드의 선언되어 있는 텍스트 속성이 업데이트
    // rxcocoa가 확장한 텍스트 속성이 입력한 값을 받아서 넥스트 이벤트를 방출
    // .bind(to) 메서드는 옵저버블이 방출한 이벤트를 옵저버에게 전달
    // 여기에서는 레이블에 합성되어 있는 텍스트 속성으로 전달 -> 이 속성의 형식은 바인더 형식, 내부적으로 넥스트 이벤트에 저장된 값을 꺼내서 레이블에 있는 기본 텍스트 속성에 저장
    // 결과적으로 텍스트필드의 텍스트 속성과 레이블의 텍스트 속성이 바인딩 되어서 항상 같은 값을 노출
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        valueField.resignFirstResponder()
    }
}
