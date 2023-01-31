//
//  SceneDelegate.swift
//  RxMemo
//
//  Created by 김규철 on 2023/01/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        //        window = UIWindow(windowScene: windowScene)
        //        window?.makeKeyAndVisible()
        
        let storage = CoreDataStorage(modelName: "RxMemo")//MemoryStorage()
        let coordinator = SceneCoordinator(window: window!)
        
        let listViewModel = MemoListViewModel(title: "나의 메모", sceneCoordinator: coordinator, storage: storage)
        let listScene = Scene.list(listViewModel)
        
        coordinator.transition(to: listScene, using: .root, animated: false)
        
    }
    
    // 실행 순서를 다시 알아보면
    // 1. 앱이 실행되면 storage, coordinator가 생성되고 listViewModel은 두 인스턴스를 통해 화면전환과 메모 저장을 처리
    // 2. 이들에 대한 의존성은 뷰모델을 생성할 때 init을 통해 주입
    // 3. 새로운 신을 생성하고 연관 값으로 뷰모델을 저장
    // 4. SceneCoordinator에서 transition을 호출하고 파라미터로 씬을 전달 그리고 using을 root로 설정하면 첫번째 화면으로 표시 여기서 파라미터로 전달된 씬은 실제로는 열거형일 뿐이고 transition 메서드로 가보면 "  let target = scene.instantiate()" 이 코드가 실제로 씬을 만들고 있다.
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

