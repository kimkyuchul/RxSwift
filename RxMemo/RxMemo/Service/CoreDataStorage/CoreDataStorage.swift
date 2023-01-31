//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/30.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

class CoreDataStorage: MemoStorageType {
    // 모델 이름을 작성할 속성 추가
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
   
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        // 여기서는 container가 생성한 view context를 그대로 리턴
        return persistentContainer.viewContext
        
    }
    
    // 기본적인 CRUD 구현
    // CoreData 역시 Observable을 활용하는 패턴으로 구현하는데
    // 직접 구현할 수 있지만 이미 검증되어 있는 RxCoreData를 활용
    
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        let memo = Memo(content: content)
        
        do {
            _ = try mainContext.rx.update(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        // 메모 목록을 리턴해야됨
        // 그냥 core data로 구현하면 patch request를 생성해야 됨
        // RxCoreData에서는 하나의 메소드로 끝남
        // 첫 번째 파라미터에는 메모의 타입 전달하면 코어 데이터에 저장된 데이터가 메모 인스턴스로 리턴됨
        // 두 번째 파라미터인 predicate은 여기에선 생략
        // 세 번째 파라미터에는 날짜를 내림차순으로 정렬하는 sort parameter 전달
        // 여기서 사용하고 있는 entities 메소드는 Observable을 리턴하고 Observable이 방출하는 요소의 형식은 첫 번째 파라미터로 전달한 형식의 배열임
        // 근데 memoList() 함수가 리턴하는 Observable은 MemoSectionModel 배열을 방출해야됨
        // map 연산자를 활용해서 MemoSectionModel 배열로 변환
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { results in [MemoSectionModel(model: 0, items: results)] }
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        // 이 함수에는 메모 인스턴스와 변경된 내용이 파라미터로 전달됨
        // 메모가 구조체로 선언되어 있고 파라미터는 기본적으로 상수이기 때문에 바로 메모에 변경된 내용을 넣을 수 없음
        // 그래서 변경된 내용을 기반으로 새로운 인스턴스를 생성
        let updated = Memo(original: memo, updatedContent: content)
        
        do {
            _ = try mainContext.rx.update(updated)
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        
        do {
            _ = try mainContext.rx.delete(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
    
    
}
