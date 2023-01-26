//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    // 작업 결과가 필요 없는 경우를 위해
    @discardableResult
    // 리턴 타입이 옵저버블 -> 이렇게 하면 구독자가 작업 결과를 원하는 결과로 처리
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}


