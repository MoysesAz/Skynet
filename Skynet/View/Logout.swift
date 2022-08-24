//
//  Logout.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 18/08/22.
//

import Foundation
import UIKit

class Logout: UIViewController {
    let userViewModel = UserViewModel()
    let backToLogin : () -> Void
    
    lazy var buttonLogout: UIButton = {
        let buttonLogout = UIButton(type: .system)
        buttonLogout.backgroundColor = .systemCyan
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        buttonLogout.setTitleColor(.white, for: .normal)
        buttonLogout.addTarget(self, action: #selector(logout(sender:
                                                             )), for: .touchUpInside)
        return buttonLogout
    }()

    init(backToLogin: @escaping ()->Void) {
        self.backToLogin = backToLogin
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(buttonLogout)
        setConstraints()
    }

    func setConstraints(){
        setConstraintsButtonLogout()
    }

    func setConstraintsButtonLogout() {
        NSLayoutConstraint.activate([
            buttonLogout.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonLogout.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            buttonLogout.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                 multiplier: 0.2),
            buttonLogout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }
    
    @objc func logout(sender: UIButton) {
        Task {
            guard let tokenData = KeychainHelper.standard.read(service: "access-token", account: "skynet") else {
                print("nenhum token encontrado")
                return
            }
            
            let token = String(data: tokenData, encoding: .utf8)!
            await userViewModel.logout(token: token)
            self.backToLogin()
            
        }
    }
}
