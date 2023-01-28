//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import UIKit

// MVVM으로 작업시에는 ViewModel을 ViewController의 속성으로 추가
// ViewModel과 View를 바인딩

protocol ViewModelBindableType {
    // ViewModel의 타입은 뷰 컨트롤러마다 달라진다.
    // 그렇기 때문에 제네릭 프로토콜로 만들어주어야 함 → associated type
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
    
}

extension ViewModelBindableType where Self: UIViewController {
    // 값 타입 프로퍼티를 변경하기 위해서는 mutating을 붙여야 한다.
    // 프로토콜 타입 역시 구조체(Struct)와 마찬가지로 Value 타입이다. 그래서 인스턴스 프로퍼티를 수정하는 것이 실제로 인스턴스 자체를 수정하는 것이라서 mutating이라는 키워드를 붙여야 한다. https://velog.io/@wonhee010/mutating
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        
        bindViewModel()
    }
}
