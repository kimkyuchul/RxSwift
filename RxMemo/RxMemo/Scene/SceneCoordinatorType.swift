//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxSwift

// 화면전환은 transition과 close로 이뤄져있기 때문에 2가지만 정의
protocol SceneCoordinatorType {
    @discardableResult // 리턴형을 사용하지 않아도 된다는 의미?
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
