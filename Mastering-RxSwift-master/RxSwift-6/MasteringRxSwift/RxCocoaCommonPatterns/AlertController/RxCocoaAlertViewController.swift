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

class RxCocoaAlertViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var oneActionAlertButton: UIButton!
    
    @IBOutlet weak var twoActionsAlertButton: UIButton!
    
    @IBOutlet weak var actionSheetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneActionAlertButton.rx.tap
        // info 메소드가 리턴하는 옵저버블을 그대로 리턴
            .flatMap { [unowned self] in self.info(title: "Current Color", message: self.colorView.backgroundColor?.rgbHexString)}
            .subscribe(onNext: { [unowned self] actionType in
                switch actionType {
                case .ok:
                    print(self.colorView.backgroundColor?.rgbHexString ?? "")
                default:
                    break
                }
            })
            .disposed(by: bag)
        
        twoActionsAlertButton.rx.tap
            .flatMap { [unowned self] in self.alert(title: "Reset Color", message: "Reset to black color?" )}
            .subscribe(onNext: { [unowned self] actionType in
                switch actionType {
                case .ok:
                    self.colorView.backgroundColor = UIColor.black
                default:
                    break
                }
            })
            .disposed(by: bag)
        
        actionSheetButton.rx.tap
            .flatMap { [unowned self] in self.colorActionSheet(colors: MaterialBlue.allColors, title: "Change color", message: "Choose one")}
            .subscribe(onNext: { [unowned self] color in
                self.colorView.backgroundColor = color
            })
            .disposed(by: bag)
    }
}

enum ActionType {
    case ok
    case cancel
}


extension UIViewController {
    // 하나의 액션을 표시하는 경고창을 래핑
    func info(title: String, message: String? = nil) -> Observable<ActionType> {
        //액션 타입에 추가 작업이 없다면 Observable<Void>, Observable<Completable>로 선언해도 무방
        
        return Observable.create { [weak self] (observable) in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                
                observable.onNext(.ok)
                observable.onCompleted()
            }
            alert.addAction(okAction)
            
            self?.present(alert, animated: true, completion: nil)
            
            // 첫번째 차이 : Disposables을 생성해서 리턴하는 것으로 끝나는데, 생성 시점에 클로저를 전달하고 얼럿 컨트롤러를 디스미스 한다.
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        
        return Observable.create { [weak self] (observable) in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                
                observable.onNext(.ok)
                observable.onCompleted()
            }
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
                observable.onNext(.cancel)
                observable.onCompleted()
            }
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true, completion: nil)
    
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func colorActionSheet(colors: [UIColor], title: String, message: String? = nil) -> Observable<UIColor> {
        // 액션 시트에서 컬러를 선택하면 colorView의 background 변경
        // 그러면 구독자에게 필요한 것은 UIColor -> Observable<UIColor>
        
        return Observable.create { [weak self] observable in
            
            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for color in colors {
                let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { _ in
                    observable.onNext(color)
                    observable.onCompleted()
                }
                actionSheet.addAction(colorAction)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observable.onCompleted()
            }
            actionSheet.addAction(cancel)
            
            self?.present(actionSheet, animated: true, completion: nil)
            
            return Disposables.create{
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
}
