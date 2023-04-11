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
    func downloadJson(_ url: String) -> Observable<String?> {
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
    
    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
//         Observable로 오는 데이터를 받아서 처리하는 방법
        downloadJson(MEMBER_LIST_URL)
            .debug() //어떤 데이터가 전달되는지 찍힘
            .subscribe { event in
                switch event {
                case .next(let json):
                    DispatchQueue.main.async {
                        self.editView.text = json
                        self.setVisibleWithAnimation(self.activityIndicator, false)
                    }
                case .completed:
                    break
                case .error:
                    break
            }
        }
        
//        let observable = downloadJson(MEMBER_LIST_URL)
//
//        observable.subscribe { event in
//            switch event {
//            case .next:
//                break
//            case .error:
//                break
//            case .completed:
//                break
//            }
//        }
    }
}
