//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        // MARK: - 방법 1. 기본적인 .rx를 이용한 UI test
        idField.rx.text.orEmpty
            //.filter { $0 != nil }
            //.map { $0! }
            .map(checkEmailValid)
            .subscribe(onNext: { b in
                self.idValidView.isHidden = b
            })
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { b in
                self.pwValidView.isHidden = b
            })
            .disposed(by: disposeBag)
        
        // combineLatest 소스 1, 소스 2, resultSelector가 있는 것을 사용해봄
        // 1과 2의 두개의 스트림을 받아서 하나를 결정해줌
        // combineLatest은 두개의 스트림중 하나라도 바뀌면 두 개다 내려보내주는데 가장 최근의 값을 전달 -> 바뀐 값이나 바뀌지 않은 스트림은 가장 최근 값을 방출
        // zip은 두개를 주면 둘 다 데이터가 생성이 되면 방출해줌 -> 만약 한쪽이 데이터가 바뀌었다? 다른 한졲은 안바뀌어서 넥스트 이벤트가 전달이 안된다. 둘 다 바뀌어야 전달됨 (지금 상황에 맞지 않음)
        // 두개의 스트림을 받는데 두개의 데이터를 그냥 전달해줌. 계산된 결과를 전달 못함
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1, s2 in s1 && s2}
        )
        .subscribe(onNext: { b in
            self.loginButton.isEnabled = b
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
