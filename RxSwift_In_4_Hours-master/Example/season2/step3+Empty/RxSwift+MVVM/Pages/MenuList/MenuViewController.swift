//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let cellId = "MenuItemTableViewCell"
    
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        updateUI()
        
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { (index, item, cell) in
                
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] inc in
                    self?.viewModel.changeCount(item: item, increase: inc)
                }
                
            }
            .disposed(by: disposeBag)
        
        //rxcocoa -> 순환참조 해결
        viewModel.itemsCount
            .map { "\($0)" }
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
//        viewModel.itemsCount
//            .map { "\($0)" }
//            .subscribe(onNext: { [weak self] in
//                self.itemCountLabel.text = $0 // updateUI를 부를 필요가 없이 값이 업데이트 될 때마다 바뀜
//            })
//            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .scan(0, accumulator: +)
            .map { $0.currencyKR() }
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
//        // TODO: no selection
//        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
        
        // 100원씩 올라가긴하지만 가격 레이블 텍스트가 변하진 않음
//        viewModel.totalPrice += 100
        updateUI()
        //서브젝트란 옵저버블 밖에서 데이터를 컨트롤해서 새로운 값을 집어넣을 수 있는 것이다.
//        viewModel.totalPrice.onNext(100)
        
        viewModel.menuObservable.onNext([
            Menu(id: 2, name: "aa", price: 100, count: 2)
        ])
    }
    
    func updateUI() {
        itemCountLabel.text = "\(viewModel.itemsCount)"
//        totalPrice.text = "\(viewModel.totalPrice.currencyKR())"
    }
}

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menus.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//        cell.title.text = menu.name
//        cell.price.text = "\(menu.price)"
//        cell.count.text = "\(menu.count)"
//
//        return cell
//    }
//}
