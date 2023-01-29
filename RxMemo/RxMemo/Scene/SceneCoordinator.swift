//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    // 실제로 화면에 표시되어 있는 ViewController를 리턴하는 속성을 추가
    // navigationController와 같은 컨테이너 뷰 컨트롤러라면 마지막 child를 리턴하고
    // 나머지 경우에는 self를 그대로 리턴
    // tabbar controller나 다른 컨테이너 컨트롤러를 사용한다면 거기에 맞게 코드를 수정해야됨
    var sceneViewController: UIViewController {
        return self.children.last ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    
    // 윈도우 인스턴스와 현재 화면에 표시되어있는 Scene을 가지고 있어야 함
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        // 화면 전환 결과를 방출할 서브젝트: 이 서브젝트는 화면전환의 성공, 실패만 방출(<Never>) -> next 이벤트는 방출할 필요 없음
        let subject = PublishSubject<Never>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target.sceneViewController
            window.rootViewController = target
            
            subject.onCompleted()
            
        case .push:
            // 푸시는 navigationController에 임베드 되어 있을 때에만 의미가 있음
            // 이 부분을 먼저 확인하고 navigationController에 임베드 되어 있지 않다면 Error 이벤트를 전달하고 중지
            guard let nav = currentVC.navigationController else {
                subject.onError(TrabsitionError.navigationControllerMissing)
                break
            }
            
            // 애플 공식 문서에서 navigationControllerDelegate 프로토콜을 보면 화면을 전환하기 전에 호출되는 메소드가 있음
            // 이 메소드가 호출되는 시점에 currentVC를 업데이트하는 방식을 사용
            // 직접 delegate 메소드를 구현하는 것도 가능하지만 여기서는 RxCocoa가 제공하는 extension을 활용
            nav.rx.willShow
            // 이 속성은 delegate 메소드가 호출되는 시점마다 Next 이벤트를 방출하는 control event이다
            // 여기에 구독자를 추가하고 currentVC 속성을 업데이트
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, evt) in
                    coordinator.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target.sceneViewController
        }
        
          return subject.asCompletable()
//        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        
        return Completable.create { [unowned self] completable in
            
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            
            else if let nav = self.currentVC.navigationController {
                guard nav .popViewController(animated: animated) != nil else {
                    completable(.error(TrabsitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!.sceneViewController
                completable(.completed)
            }
            else {
                completable(.error(TrabsitionError.unknown))
            }
            return Disposables.create()
        }
    }
}

