//
//  Memo.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxDataSources //테이블 뷰와 컬렉션 뷰에 바인딩할수 있는 데이터 소스 제공, 반드시 identifiable 프로토콜을 채용해야함

// IdentifiableType 프로토콜에는 identity 속성이 선언되어 있음
// identity 속성의 형식은 Hashable 프로토콜을 채용한 형식으로 제한되어 있는데
// 메모 구조체에 있는 identity 속성은 형식이 String으로 선언되어 있는데 String은 Hashable 프로토콜을 채용한 형식이므로
// 프로토콜이 요구하는 모든 사항을 충족시킴
struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 업데이트된 내용으로 메모 인스턴스를 만들 때 사용
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}
