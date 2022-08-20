//
//  Apresentation.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 18/08/22.
//

import Foundation
import UIKit

class Apresentation: UIViewController {
    lazy var imageEyes: UIImageView = {
        let eyes = UIImage(named: "Eyes")
        let imageEyes = UIImageView(image: eyes)
        imageEyes.image = eyes
        imageEyes.frame = CGRect()
        imageEyes.contentMode = .scaleAspectFill
        imageEyes.translatesAutoresizingMaskIntoConstraints = false
        return imageEyes
    }()

    lazy var labelSalutation: UILabel = {
        let textFieldTittle = UILabel(frame: CGRect())
        textFieldTittle.text = "Find your net or die trying!!!"
        textFieldTittle.textColor = .white
        textFieldTittle.font = UIFont(name: "Arial", size: 60)
        textFieldTittle.textAlignment = .left
        textFieldTittle.numberOfLines = 3;
        textFieldTittle.translatesAutoresizingMaskIntoConstraints = false
        return textFieldTittle
    }()

    lazy var labelSubSalutation: UILabel = {
        let textFieldTittle = UILabel(frame: CGRect())
        textFieldTittle.textColor = .systemGray
        textFieldTittle.text = "01110011 01101100 01100001 01110110 01100101 01110011 "
        textFieldTittle.font = UIFont(name: "Arial", size: 20)
        textFieldTittle.numberOfLines = 2;
        textFieldTittle.translatesAutoresizingMaskIntoConstraints = false
        return textFieldTittle
    }()

    lazy var buttonGetStarted: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemPink
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageEyes)
        view.addSubview(labelSalutation)
        view.addSubview(labelSubSalutation)
        view.addSubview(buttonGetStarted)
        print(buttonGetStarted.frame.width)
        buttonGetStarted.layer.cornerRadius = view.frame.height*0.08 / 2
        // pq tenho que declarar cornerRadius no view did Load nao na construçao da viewUi
        // pq quando seto uma constraint em um uielementobutton ele nao tem .frame.width
        setConstraints()
        print(buttonGetStarted.frame.width)

    }

    @objc func getStarted(){
        self.dismiss(animated: true)
    }

    func setConstraints(){
        setConstraintsImageEyes()
        setConstraintsLabelSalutation()
        setConstraintsLabelSubSalutation()
        setConstraintsButtonGetStarted()
    }

    func setConstraintsImageEyes() {
        NSLayoutConstraint.activate([
            imageEyes.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageEyes.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height / 5),
            imageEyes.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            imageEyes.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
        ])
        // pq mesmo view.widthAnchor = 100 porcento nao consigo colocar o tamanho de 100 porcento largura?

    }

    func setConstraintsLabelSalutation() {
        NSLayoutConstraint.activate([
            labelSalutation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width*0.1),
            labelSalutation.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height/10),
            labelSalutation.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                    multiplier: 0.35),
            labelSalutation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }

    func setConstraintsLabelSubSalutation() {
        NSLayoutConstraint.activate([
            labelSubSalutation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width*0.1),            labelSubSalutation.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height/4),
            labelSubSalutation.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                       multiplier: 0.2),
            labelSubSalutation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }

    func setConstraintsButtonGetStarted() {
        NSLayoutConstraint.activate([
            buttonGetStarted.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonGetStarted.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height/2.8),
            buttonGetStarted.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                     multiplier: 0.08),
            buttonGetStarted.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
}
