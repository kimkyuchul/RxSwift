//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
