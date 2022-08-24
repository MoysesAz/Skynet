//
//  HomeController.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 16/08/22.
//

import Foundation
import UIKit

class CellPost: UICollectionViewCell {
    lazy var labelName: UILabel = {
        let labelName = UILabel()
        labelName.textColor = .white
        labelName.textAlignment = NSTextAlignment.center;
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()
    
    lazy var labelHours: UILabel = {
        let labelHours = UILabel(frame: CGRect())
        labelHours.textColor = .white
        labelHours.textAlignment = NSTextAlignment.center;
        labelHours.translatesAutoresizingMaskIntoConstraints = false
        return labelHours
    }()
    
    lazy var labelPost: UILabel = {
        let labelPost = UILabel(frame: CGRect())
        labelPost.textColor = .white
        labelPost.textAlignment = NSTextAlignment.center;
        labelPost.translatesAutoresizingMaskIntoConstraints = false
        return labelPost
    }()
    
    lazy var buttonLike: UIButton = {
        let labelPost = UIButton(frame: CGRect())
        labelPost.backgroundColor = .systemPink
        labelPost.setTitle("Login", for: .normal)
        labelPost.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        labelPost.setTitleColor(.white, for: .normal)
        //labelPost.addTarget(self, action: #selector(login), for: .touchUpInside)
        labelPost.translatesAutoresizingMaskIntoConstraints = false
        return labelPost
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        textFieldEmail.borderStyle = .line
//        textFieldEmail.layer.borderWidth = 1
//        textFieldEmail.layer.cornerRadius = view.frame.height*0.05 / 2
        self.layer.borderWidth = 1
        self.layer.cornerRadius =  self.frame.height * 0.1
        self.layer.borderColor = UIColor(red:255, green:255, blue:255, alpha: 1).cgColor
        addSubview(labelName)
        addSubview(labelHours)
        addSubview(labelPost)
        setConstraints()
    }
    
    func setConstraints(){
        setConstraintsLabelName()
        setConstraintsLabelHours()
        setConstraintsLabelPost()
    }

    func setConstraintsLabelName(){
        NSLayoutConstraint.activate(
            [
                labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                labelName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.frame.height/2.5),
                labelName.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                  multiplier: 0.8),
                labelName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            ]
        )
    }
    
    func setConstraintsLabelHours(){
        NSLayoutConstraint.activate(
            [
                labelHours.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                labelHours.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.frame.height/2.5),
                labelHours.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                   multiplier: 0.1),
                labelHours.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            ]
        )
    }
    
    func setConstraintsLabelPost(){
        NSLayoutConstraint.activate(
            [
                labelPost.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                labelPost.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelPost.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                  multiplier: 0.8),
                labelPost.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var posts: [Post] = []
    var namesUsers: [String?] = []

    var userViewModel = UserViewModel()
    var postViewModel = PostViewModel()
    
    lazy var collectionViewPosts: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // margens cell
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2)
        // tamanho da celula
        
        let collectionViewPosts: UICollectionView  = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionViewPosts.backgroundColor = .black
        collectionViewPosts.dataSource = self
        collectionViewPosts.delegate = self
        collectionViewPosts.register(CellPost.self, forCellWithReuseIdentifier: "collectionViewPosts")
        collectionViewPosts.translatesAutoresizingMaskIntoConstraints = false
        return collectionViewPosts
        
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewPosts", for: indexPath) as! CellPost
        cell.labelPost.text = posts[indexPath.item].content
        cell.labelName.text = namesUsers[indexPath.item]
        cell.labelHours.text = posts[indexPath.item].created_at
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.addSubview(collectionViewPosts)
        self.setUpConstraints()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            await getPosts()
            await getNamesUsers()
            collectionViewPosts.reloadData()
        }

    }

    func getPosts() async {
        posts = await postViewModel.fetchPosts()
    }

    func getNamesUsers() async {
        for i in posts {
            if let user = await userViewModel.fetchUserByID(id: i.user_id) {
                namesUsers.append("@" + user.name)
            } else {
                namesUsers.append(nil)
            }
        }
    }

    func setUpConstraints(){
        setUpConstraintsCollectionViewPosts()
    }

    func setUpConstraintsCollectionViewPosts(){
        NSLayoutConstraint.activate([
            collectionViewPosts.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            collectionViewPosts.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            collectionViewPosts.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionViewPosts.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}


