//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
    func downloadJson(_ url: String) -> Observable<String> {
        return Observable.create() { emmiter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else {
                    emmiter.onError(error!)
                    return }
                
                if let dat = data, let json = String(data: dat, encoding: .utf8) {
                    emmiter.onNext(json)
                }
                emmiter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
        
//        return Observable.create() { f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                    f.onCompleted()
//                }
//            }
//            return Disposables.create()
//        }
    }
    
    // MARK: SYNC
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // @escaping : 본체함수가 끝나고 나서 실행되는 함수부분에 써주는 것
//    func downloadJson(_ url: String, _ completion: @escaping (String?) -> Void) {
//        DispatchQueue.global().async {
//            let url = URL(string: url)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)
//            DispatchQueue.main.async {
//                completion(json)
//            }
//        }
//    }
    
    // RxSwift 비동기 처리 연습
//    func downloadJson(_ url: String) -> observable<String?> {
//        return observable() { f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//                DispatchQueue.main.async {
//                    f(json)
//                }
//            }
//        }
//    }
    
    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        // @escaping 으로 비동기 처리했을 때 코드
//        downloadJson(MEMBER_LIST_URL) { json in
//            self.editView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//        }
        // 이렇게 비동기처리를 해주면 안좋은 점
        // completion(클로저)으로 전달을 해주니까 그 자리에서 바로 사용해야 하고,
        // 에러나 예외케이스 처리나 변환 등의 처리를 해주는 것이 어렵다. (변수로 받아오는 것처럼 하면 핸들링 편한데,,)
        
        // rxswift로 비동기 처리했을 때 코드 (연습 코드)
//        downloadJson(MEMBER_LIST_URL)
//            .subscribe { json in
//            self.editView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//            }
        
//        Observable로 오는 데이터를 받아서 처리하는 방법
//        downloadJson(MEMBER_LIST_URL)
//            .debug() //어떤 데이터가 전달되는지 찍힘
//            .subscribe { event in
//                switch event {
//                case .next(let json):
//                    DispatchQueue.main.async {
//                        self.editView.text = json
//                        self.setVisibleWithAnimation(self.activityIndicator, false)
//                    }
//                case .completed:
//                    break
//                case .error:
//                    break
//            }
//        }
        
//       _ = downloadJson(MEMBER_LIST_URL) //just, from
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //어디에 있든 어디 스레드에서 실행할지를 지정
//            .compactMap { json in json?.count }
//            .filter { cnt in cnt > 0 }
//            .map { "\($0)" }
//            .observeOn(MainScheduler.instance) // 이 밑으로는 해당 스레드에서 실행하겠다.
//            .subscribe(onNext: { json in
//                self.editView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            })
        
        // Observable Combine 실습 (많이 쓰는 것 -> merge, zip, combineLastest)
        let jsonObservavle = downloadJson(MEMBER_LIST_URL)
        let helloObservavle =  Observable.just("hello, kyuchul2")
        
        _ = Observable.zip(jsonObservavle, helloObservavle) { $1 + "\n" + $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            .disposed(by: disposeBag)
    }
}
