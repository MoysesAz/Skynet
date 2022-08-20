//
//  Login.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 16/08/22.
//

import Foundation
import UIKit


class LoginController: UIViewController {
    let userViewModel = UserViewModel()
    var loginError = false
    
    lazy var textFieldEmail: UITextField = {
        let textFieldEmail = UITextField(frame: CGRect())
        textFieldEmail.borderStyle = .line
        textFieldEmail.backgroundColor = .white
        textFieldEmail.text = "m.mirazev@gmail.com"
        textFieldEmail.placeholder = "Email"
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        return textFieldEmail
    }()
    
    lazy var textFieldPassword: UITextField = {
        let textFieldEmail = UITextField(frame: CGRect())
        textFieldEmail.borderStyle = .line
        textFieldEmail.backgroundColor = .white
        textFieldEmail.text = "senha123"
        textFieldEmail.placeholder = "Password"
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        return textFieldEmail
    }()
    
    lazy var buttonLogin: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonRegistration: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.registration), for: .touchUpInside)
        return button
    }()
    
    lazy var loginErrorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Email ou senha incorretos"
        label.textColor = .red
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apresentationController = Apresentation()
        if let sheet = apresentationController.sheetPresentationController{
            sheet.detents = [.large()]
        }
        self.present(apresentationController, animated: true)

        view.backgroundColor = .white
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonLogin)
        view.addSubview(buttonRegistration)
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonLogin)
        view.addSubview(buttonRegistration)
        setConstraints()
    }
    
    func setConstraints(){
        setConstraintsTextFieldEmail()
        setConstraintsTextFieldPassword()
        setConstraintsButtonLogin()
        setConstraintsButtonRegistration()
    }

    func setConstraintsTextFieldEmail() {
        NSLayoutConstraint.activate([
            textFieldEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            textFieldEmail.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160),
            textFieldEmail.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: 0.05),
            textFieldEmail.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }

    func setConstraintsTextFieldPassword() {
        NSLayoutConstraint.activate([
            textFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            textFieldPassword.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            textFieldPassword.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                      multiplier: 0.05),
            textFieldPassword.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }

    func setConstraintsButtonLogin() {
        NSLayoutConstraint.activate([
            buttonLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonLogin.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            buttonLogin.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                multiplier: 0.05),
            buttonLogin.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }

    func setConstraintsButtonRegistration() {
        NSLayoutConstraint.activate([
            buttonRegistration.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonRegistration.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            buttonRegistration.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                       multiplier: 0.05),
            buttonRegistration.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
        
//        if loginError {
//            view.addSubview(loginErrorLabel)
//
//            constraints.append(contentsOf: [
//                loginErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
//                loginErrorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)])
//        }
//
//        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func login() {
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        let user = User.authentication(username: email, password: password)
        
        Task {
            let loginStatus = await userViewModel.login(user: user)
            
            if (loginStatus == 200) {
                let mainController = MainController()
                self.navigationController?.pushViewController(mainController, animated: false)
            } else {
                loginError = true
                print("usuario ou senha incorretos")
            }
        }
        
        
        
        
    }
    
    @objc func registration() {
        let registrationController = RegistrationController()
        
        if let sheet = registrationController.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        self.present(registrationController, animated: true)
    }
}


