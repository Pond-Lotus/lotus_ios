//
//  SceneDelegate.swift
//  TODORI
//
//  Created by Dasol on 2023/04/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.overrideUserInterfaceStyle = .light // light-mode
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let mainViewController = LaunchScreenViewController()
        self.window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
//        UserDefaults.standard.set(false, forKey: "autoLogin")
//        UserDefaults.standard.removeObject(forKey: "autoLogin")
        
        if UserDefaults.standard.bool(forKey: "autoLogin") {
            print("isAutoLogin: true")
            UserService.shared.checkToken() { result in
                switch result {
                case .success(let response):
                    if response.resultCode == 200 {
                        print("이백")
                        if let token = TokenManager.shared.getToken() {
                            print("토큰: \(token)")
                        }
                        let navigationController = UINavigationController(rootViewController: ToDoMainViewController())
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                    } else if response.resultCode == 500 {
                        print("오백 : 토큰 유효성 검증 실패")
                    }
                case .failure(_):
                    print("failure")
                }
            }
        } else {
            print("isAutoLogin: false")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navigationController = UINavigationController(rootViewController: LogInViewController())
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
        print("여기는 SceneDelegate 입니다.")
    }
    
    static func reset() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        TokenManager.shared.deleteToken()

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
        else { return }
        
        let loginViewController = UINavigationController(rootViewController: LogInViewController())
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = loginViewController
        sceneDelegate.window = window
        window.makeKeyAndVisible()
    }
    
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
    }
    
    
}

