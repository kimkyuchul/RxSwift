//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation

// 전환과 관련된 열거형(Enum) 추가
enum TransitionStyle {
    case root // 첫번째 화면을 표시 할 때
    case push
    case modal
}

enum TrabsitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
