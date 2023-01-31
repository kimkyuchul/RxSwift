//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import UIKit

class MemoDetailViewModel: CommonViewModel {
    
    // 이전 씬에서 전달된 메모가 저장
    var memo: Memo
    
    //날짜를 문자열로 바꿀 때 사용된다
    private var formatter:  DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    // 메모 내용을 테이블 뷰에 표시 첫번째 셀에는 내용 두번째 셀에는 날짜
    // 테이블뷰에 표시할 데이터는 문자열 2개 -> 문자열 배열을 방출
    // BehaviorSubject 사용? => 메모 보기 화면에서 편집버튼을 누른 다음 편집 하고 다시 보기 화면으로 돌아오면 편집 내용이 반영 되어야함 -> 새로운 문자열 배열을 방출해야함, 일반 옵저버블로 하면 이게 불가능
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: CoreDataStorage) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map { _ in }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .do(onNext: { self.memo = $0 })
                .map { [$0.content, self.formatter.string(from: $0.insertDate)] }
                .bind(onNext: { self.contents.onNext($0) })
                .disposed(by: self.rx.disposeBag)
            return Observable.empty()
        }
    }

    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage as! CoreDataStorage, saveAction: self.performUpdate(memo: self.memo))

            let composeScene = Scene.compose(composeViewModel)
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }

        }
    }
    
    // 삭제 버튼과 바인딩할 액션
    func makeDeleteAction() -> CocoaAction {
        return Action { input in
            self.storage.delete(memo: self.memo)
            
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map { _ in }
        }
    }
}
