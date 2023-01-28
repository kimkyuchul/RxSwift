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

class MemoDetailViewModel: CommonViewModel {
    
    // 이전 씬에서 전달된 메모가 저장
    let memo: Memo
    
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
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoryStorage) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
