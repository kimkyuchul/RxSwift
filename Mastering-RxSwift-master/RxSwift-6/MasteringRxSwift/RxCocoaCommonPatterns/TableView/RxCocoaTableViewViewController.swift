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


class RxCocoaTableViewViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.currency
        f.locale = Locale(identifier: "Ko_kr")
        
        return f
    }()
    
    let bag = DisposeBag()
    
    //테이블 뷰에 바인딩 할 옵저버블 -> 이 옵저버블은 테이블뷰에 표시할 데이터를 방출
    let nameObservable = Observable.of(appleProducts.map { $0.name })
    let productObservable = Observable.of(appleProducts)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #1
//        nameObservable.bind(to: listTableView.rx.items) { tableView, row, element in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
//            cell.textLabel?.text = element
//
//            return cell
//        }
//        .disposed(by: bag)
        
        // #2
//        nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) { row, element, cell in
//
//            cell.textLabel?.text = element
//        }
//        .disposed(by: bag)
        
        // #3
        //
        productObservable.bind(to: listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { [weak self] row, element, cell in // 마지막으로 전달된 cell은 celltype 형식으로 타입 캐스팅 되어 전달 -> 연결된 아울렛 접근할 때 타입 캐스팅이 필요 없음
            
            cell.categoryLabel.text = element.category
            cell.productNameLabel.text = element.name
            cell.summaryLabel.text = element.name
            cell.priceLabel.text = self?.priceFormatter.string(from: element.price as NSNumber)
        }
        .disposed(by: bag)
        
        // didSelectRowAt
//        listTableView.rx.modelSelected(Product.self)
//            .subscribe(onNext: { product in
//                print(product.name)
//            })
//            .disposed(by: bag)
//
//        listTableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                self?.listTableView.deselectRow(at: indexPath, animated: true)
//            })
//            .disposed(by: bag)
        
        // itemSelected와 modelSelected는 모두 컨트롤이벤트를 리턴 각각 인덱스 패스와 모델 데이터를 방출하는데 항상 매칭되는 데이터를 방출
        // ex) 첫 번째 셀을 선택하면 첫 번째 인덱스패스와 데이터를 방출 그래서 두 개의 컨트롤 이벤트를 zip 연산자로 병합할 수 있음
        Observable.zip(listTableView.rx.modelSelected(Product.self),
                       listTableView.rx.itemSelected)
        .bind { [weak self] (product, indexPath) in
            self?.listTableView.deselectRow(at: indexPath, animated: true)
            print(product.name)
        }
        .disposed(by: bag)
        // 선택 이벤트를 처리하면서 데이터가 필요하다면 modelSelected룰 활용
        // 그냥 인덱스패스로 충분하다면 itemSelected를 활용
        // 만약 모두 필요하다면, zip으로 합쳐도 대고 따로 구현해도 댄다
        
        // listTableView.delegate = self
        listTableView.rx.setDelegate(self) // rx 방식으로 델리게이트를 직접 지정하면 rxCocoa와 함께 활용이 가능
            .disposed(by: bag)
    }
}

extension RxCocoaTableViewViewController: UITableViewDelegate { // cocoatouch 방식으로 델리게이트를 구현하면 rx 코드 동작하지 않음
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}


