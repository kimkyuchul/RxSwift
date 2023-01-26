//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

/*
 공통으로 가지고 있는 멤버들도 미리 만들어주면 편함

 - 네비게이션의 경우 title
 - sceneCoordinator - SceneCoordinatorType
 - storage - MemoStorageType
 - 생성자 (init())
 */

class CommonViewModel: NSObject {
    let title: Driver<String> // 드라이버 형식
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
