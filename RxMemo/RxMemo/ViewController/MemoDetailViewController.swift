//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    
    func bindViewModel() {
        
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: contentTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                    
                }
            }
            .disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        
//        backButton.rx.action = viewModel.popAction
//        //navigationItem.backBarButtonItem = backButton
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton
        
        
        shareButton.rx.tap //액션 활용하는 방식으로 구현해보기
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) //더블탭 막기
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
