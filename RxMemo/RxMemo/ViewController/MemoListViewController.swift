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
        // 테이블뷰가 넘 이른 시점에 바인딩되어 네비게이션 라지 타이틀이 바로 적용이 안댐 -> 바인딩이 실행되는 시점을 늦춰야 한다.
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
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected) //이렇게 하면 선택된 메모와 인덱스패스가 튜플 형태로 방출
            .withUnretained(self) // self에 대한 비소유 참조와 zip 연산자가 방출하는 요소가 하나의 튜플로 방출
        // 첫번째 요소가 self => 뷰컨, 두번째 요소는 zip 연산자가 방출한 요소 -> data
            .do(onNext: { (vc, data) in
                vc.listTableView.deselectRow(at: data.1, animated: true)
            })
        // 선택 상태를 처리했기 때문에 이후에는 indexPath가 필요없음
        // 그래서 map 연산자로 데이터만 방출하도록 바꿈
                .map { $1.0 }
        // 마지막으로 전달된 메모를 detailAction과 바인딩
                .bind(to: viewModel.detailAction.inputs)
                .disposed(by: rx.disposeBag)
        
     
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
