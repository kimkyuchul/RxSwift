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
        
        // +버튼과 액션을 바인딩
        addButton.rx.action = viewModel.makeCreateAction()
        
        // detailAction 바인딩
        // tableView에서 메모를 선택하면 ViewModel을 통해서 detailAction을 전달하고 선택한 셀은 선택해제
        // 위 주석의 첫 번째 작업을 하려면 선택한 메모가 필요하고 두 번째 작업에서는 indexPath가 필요함
        // 선택한 indexPath가 필요할 때는 itemSelected 속성을 사용하고 선택한 데이터인 메모가 필요하다면 modelSelected 메소드를 활용
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
        
        // tableView에서 swipe to delete 모드를 활성화하고 삭제 버튼과 액션을 바인딩
        //컨트롤 이벤트를 리턴. 컨트롤 이벤트는 메모를 삭제할 때마다 넥스트 이벤트 방출
        listTableView.rx.modelDeleted(Memo.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag) //스와이프 딜리트가 자동 활성
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
