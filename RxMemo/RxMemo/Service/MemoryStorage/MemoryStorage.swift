//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift

// 메모리에 메모를 저장
class MemoryStorage: MemoStorageType {
    
    // 메모를 저장할 배열
    private var list = [
        Memo(content: "hello,  kyuchul", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "PADDED DEVICE PROTECTION", insertDate: Date().addingTimeInterval(-20)),
        Memo(content: "PADDED DEVICE PROTECTION1", insertDate: Date().addingTimeInterval(-30))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    // 배열은 옵저버블을 통해서 외부로 공개
    // 옵저버블은 배열의 상태가 업데이트되면 새로운 넥스트 이벤트를 방출 -> 그냥 옵저버블 형식으로 만들면 불가능하기 때문에 서브젝트로 만듬
    // 그리고 더미 데이터를 보여줘야하니 BehaviorSubject로 만듬
    
    // MARK: 이부분을 생성해서 계속 방출하는 이유는 무엇일까?
    // 나중에 테이블뷰를 사용할 텐데, 이부분이 계속 방출되어야 테이블뷰가 바로바로 업데이트 된다
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    // 기본값을 list 배열로 선언하기 위해서 lazy로 선언
    // subject 역시 외부에서 직접 접근할 필요가 없기 때문에 private
    
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel])
        
        // 새로운 메모를 방출하는 Observable
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        // 배열에 저장된 원본 인스턴스를 새로운 인스턴스로 교체
        if let  index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
        
        // 업데이트된 메모를 방출하는 옵저버블
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    
}
