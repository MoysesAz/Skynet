//
//  PublishController.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 16/08/22.
//

import Foundation
import UIKit


class PublishController: UIViewController {
    let postViewModel = PostViewModel()
    
    lazy var textFieldPost: UITextView = {
        let textFieldPost = UITextView(frame: CGRect())
        textFieldPost.backgroundColor = .black
//        textFieldPost.placeholder = "Comente aqui!"
        textFieldPost.layer.borderWidth = 1
        textFieldPost.layer.cornerRadius = view.frame.height*0.05 / 2
        textFieldPost.layer.borderColor = UIColor.white.cgColor
        textFieldPost.textColor = .white
        textFieldPost.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPost
    }()

    lazy var buttonSend: UIButton = {
        let buttonSend = UIButton(type: .system)
        buttonSend.backgroundColor = .systemPink
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        buttonSend.setTitle("Send", for: .normal)
        buttonSend.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        buttonSend.setTitleColor(.white, for: .normal)
        buttonSend.addTarget(self, action: #selector(publish), for: .touchUpInside)
        return buttonSend
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        self.title = "Publish"
        self.view.backgroundColor = .black
        view.addSubview(textFieldPost)
        view.addSubview(buttonSend)
        buttonSend.layer.cornerRadius = view.frame.height*0.06 / 2


        NSLayoutConstraint.activate([
            textFieldPost.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldPost.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            textFieldPost.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                  multiplier: 0.7),
            textFieldPost.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),


            buttonSend.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonSend.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 340),

            buttonSend.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: 0.06),
            buttonSend.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),


        ])
    }

    @objc func publish() {
        let content = textFieldPost.text!
        
        Task {
            guard let tokenData = KeychainHelper.standard.read(service: "access-token", account: "skynet") else {
                print("nenhum token encontrado")
                return
            }
            
            let token = String(data: tokenData, encoding: .utf8)!
            
            let post = Post.create(content: content)
            
            let contentType = "text/plain"
            
            await postViewModel.addPost(post, contentType, token)
            self.tabBarController?.selectedIndex = 0

        }
    }

}
