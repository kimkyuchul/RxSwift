//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import UIKit

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
        
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        
//        backButton.rx.action = viewModel.popAction
//        //navigationItem.backBarButtonItem = backButton
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
