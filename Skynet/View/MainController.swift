//
//  ViewController.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 09/08/22.
//

import UIKit

class MainController: UITabBarController {
    let postViewModel = PostViewModel()
    let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setHidesBackButton(true, animated:false)

        view.backgroundColor = .white
        setUpView()
    }
    
    func setUpView() {
        let homeController = UINavigationController(rootViewController: HomeController())
//        let seachController = UINavigationController(rootViewController: SeachController())
        let publishController = UINavigationController(rootViewController: PublishController())
//        let notificationController = UINavigationController(rootViewController: NotificationController())
        let userController = UINavigationController(rootViewController: UserController())
        let logout = UINavigationController(rootViewController: Logout(backToLogin: {
            self.navigationController?.popToRootViewController(animated: false)
        }))
        self.setViewControllers([homeController, publishController, userController, logout], animated: true)
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        guard let items = self.tabBar.items else {return}
        
        items[0].title = "Home"
        items[0].image = UIImage(systemName: "house.fill")
        
        //gearshape engrenagem config

//        items[].title = "Seach"
//        items[].image = UIImage(systemName: "magnifyingglass")

        items[1].title = "Publish"
        items[1].image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")

        //items[].title = "Notification"
        //items[].image = UIImage(systemName: "star")

        items[2].title = "User"
        items[2].image = UIImage(systemName: "person")

        items[3].title = "Config"
        items[3].image = UIImage(systemName: "gearshape")
    }
    
    @objc func getToken(sender: UIButton) {
        guard let tokenData = KeychainHelper.standard.read(service: "access-token", account: "skynet") else {
            print("nenhum token encontrado")
            return
        }
        
        let token = String(data: tokenData, encoding: .utf8)!
        
        print(token)
        
        guard let userData = KeychainHelper.standard.read(service: "user-id", account: "skynet") else {
            print("nenhum valor encontrado")
            return
        }
        
        let userID = String(data: userData, encoding: .utf8)!
        
        print(userID)
        
    }
    
    @objc func getUsers(sender: UIButton) {
        Task {
            await userViewModel.fetchUsers()
        }
    }
    
    @objc func createUser(sender: UIButton) {
        Task {
            let user = User(id: nil, name: "Monica", email: "monica@gmail.com", password: "sansao")
            await userViewModel.addUser(user: user)
        }
    }
    
    @objc func login(sender: UIButton) {
        Task {
            let user = User.authentication(username: "monica@gmail.com", password: "sansao")
            await userViewModel.login(user: user)
        }
    }
    
    @objc func logout(sender: UIButton) {
        Task {
            guard let tokenData = KeychainHelper.standard.read(service: "access-token", account: "skynet") else {
                print("nenhum token encontrado")
                return
            }
            
            let token = String(data: tokenData, encoding: .utf8)!
            await userViewModel.logout(token: token)
        }
    }
    
    
    @objc func getPosts(sender: UIButton)  {
        Task {
            let posts = await postViewModel.fetchPosts()
        }
    }
    
    @objc func createTextPost(sender: UIButton) {
        Task {
            guard let tokenData = KeychainHelper.standard.read(service: "access-token", account: "skynet") else {
                print("nenhum token encontrado")
                return
            }
            
            let token = String(data: tokenData, encoding: .utf8)!
            
            let post = Post.create(content: "Numa toca no chão vivia um hobbit. Não uma toca desagradável, suja e úmida, cheia de restos de minhocas e com cheiro de lodo; tampouco uma toca seca, vazia e arenosa, sem nada em que sentar ou o que comer: era a toca de um hobbit, e isso quer dizer conforto.")
            
            
            let contentType = "text/plain"
            
            await postViewModel.addPost(post, contentType, token)
        }
    }
    
}




