//
//  Memo.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import Foundation
import RxDataSources //테이블 뷰와 컬렉션 뷰에 바인딩할수 있는 데이터 소스 제공, 반드시 identifiable 프로토콜을 채용해야함
import CoreData
import RxCoreData

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

extension Memo: Persistable {
    // entity name을 타입 프로퍼티로 선언
    static var entityName: String {
        // entity 이름을 리턴해야 되니까 메모 리턴
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        // 이 속성은 id로 사용되는 필드를 리턴해야 여기에서는 identity attribute를 리턴
        return "identity"
    }
    
    // NSManagedObject로 인스턴스를 초기화하는 생성자 구현
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 현재 인스턴스에 저장된 데이터로 NSManagedObject를 업데이트하는 메소드를 구현
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        // RxCoreData는 context를 자동으로 저장해주기 때문에 save를 직접 호출할 필요가 없음
        // 지금 여기서 구현한 코드는 RxCoreData를 사용하고 있지 않기 때문에 그래서 save 메소드를 직접 호출해야됨
        // 그렇지 않으면 경우에 따라서 업데이트한 내용이 사라질 수 있음
        // core data를 rx 방식으로 구현할 때는 항상 이 부분을 조심해야됨
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
