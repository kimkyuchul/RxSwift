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

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redComponentLabel: UILabel!
    @IBOutlet weak var greenComponentLabel: UILabel!
    @IBOutlet weak var blueComponentLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewDidLoad에서 실행 했기 때문에 메인 스레드에서 실행됨, 하지만 다른 스레드에서 실행되더라도 바인딩은 메인 스레드에서 실행됨 -> ControlProperty, ControlEvent는 항상 메인 스레드에서 이벤트를 전달, 그리고 바인더는 바인딩이 항상 메인 스케줄러에서 실행되는 것을 보장함. (항상 올바른 스레드에서 실행됨)
        redSlider.rx.value
            .map { "\(Int($0))"}
            .bind(to: redComponentLabel.rx.text)
            .disposed(by: bag)
        
        greenSlider.rx.value
            .map { "\(Int($0))"}
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: bag)
        
        blueSlider.rx.value
            .map { "\(Int($0))"}
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: bag)
        
//        Observable.combineLatest([redSlider.rx.value, greenSlider.rx.value, blueSlider.rx.value])
//                  .map { UIColor(red: CGFloat($0[0]) / 255, green: CGFloat($0[1]) / 255, blue: CGFloat($0[2]) / 255, alpha: 1.0) }
//                  .bind(to: colorView.rx.backgroundColor)
//                  .disposed(by: bag)
        
        resetButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.colorView.backgroundColor = UIColor.black
                
                self?.redSlider.value = 0
                self?.greenSlider.value = 0
                self?.blueSlider.value = 0
                
                self?.updateComponentLabel()
            })
            .disposed(by: bag)
    }
}
