//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var viewModel: MemoListViewModel!
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // 데이터 소스를 구현하지 않아도 됨
        // 셀 deque 및 재사용을 알아서 해줌
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
