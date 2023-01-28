//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    // 목록 화면 상단에 + 버튼이 추가되어 있고 이 버튼을 탭하면 쓰기 화면을 modal 방식으로 표시
    // 이 버튼과 바인딩할 액션 구현
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            
            // createMemo 메소드를 호출하면 새로운 메모가 생성되고 이 메모를 방출하는 Observable이 리턴됨
            // 이어서 flatMap 연산자를 호출하고 클로저에서 화면 전환을 처리
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    
                    // ViewModel 만들기
                    // title은 바로 문자열을 전달하면 되고 sceneCoordinator와 storage에 대한 의존성은 현재 ViewModel에 있는 속성으로 바로 주입할 수 있음
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage as! MemoryStorage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    // compose scene을 생성하고 연관값으로 ViewModel을 저장
                    let composeScene = Scene.compose(composeViewModel)
                    
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            // Action<String, Void>을 보면 입력 타입이 String으로 선언되어 있음
            // 입력값으로 메모를 업데이트하도록 구현
            return self.storage.update(memo: memo, content: input).map { _ in }
            // Action<String, Void>의 출력 타입이 Void로 선언되어 있음
            // 즉 Observable이 방출하는 형식이 Void라는 뜻
            // 방출하는 형식이 다르기 때문에 에러가 발생해서 map 연산자로 해결
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return  self.storage.delete(memo: memo).map { _ in }
            
        }
    }
    
    // 목록 화면에서 보기 화면으로 이동하는 코드
    // 클로저 내부에서 self에 접근해야 하기 때문에 lazy로 선언
    lazy var detailAction: Action<Memo, Void> = {
        
        return Action { memo in
            
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage as! MemoryStorage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
        }
    }()
}

