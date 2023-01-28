//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
    // Compose 씬에서 메모를 저장할 속성 -> 새로운 메모를 추가할 때는 nil이 저장되고, 메모를 편집할 때는 편집할 메모가 저장
    private let content: String?
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoryStorage, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        
        // saveAction을 받는 파라미터는 옵셔널로 선언되어 있고 기본값이 nil
        // saveAction 파라미터로 전달된 액션을 그대로 저장하지 않고 Action<String, Void>로 한 번 더 래핑
        // 액션이 전달되었다면 실제로 액션을 실행하고 화면을 닫음
        // 반대로 액션이 전달되지 않았다면 화면만 닫고 끝남
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        // 취소 액션과 저장액션을 파라미터로 받고 있음.
        // 직접 구현해도 되지만, 처리방식이 고정됨.
        // 파라미터로 받음으로써 이전화면에서 처리 방식을 동적으로 결정할 수 있다.
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
}
