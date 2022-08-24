//
//  UserController.swift
//  Skynet
//
//  Created by Moyses Miranda do Vale Azevedo on 16/08/22.
//

import Foundation
import UIKit



class UserController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var posts: [Post] = []
    var myPosts: [Post] = []
    var namesUsers: [String?] = []

    var userViewModel = UserViewModel()
    var postViewModel = PostViewModel()

    lazy var imageUser: UIView = {
        let image = UIImage(systemName: "person")
        let imageUser = UIImageView(image: image)
        imageUser.image = image
        imageUser.contentMode = .scaleAspectFill
        imageUser.translatesAutoresizingMaskIntoConstraints = false
        return imageUser
    }()

    
    lazy var labelName: UILabel = {
        let labelName = UILabel(frame: CGRect())
        labelName.text = "@Mirazev"
        labelName.textAlignment = NSTextAlignment.center;
        labelName.textColor = .white
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()

    lazy var labelEmail: UILabel = {
        let labelEmail = UILabel(frame: CGRect())
        labelEmail.text = "m.mirazev@gmail"
        labelEmail.textColor = .white
        labelEmail.textAlignment = NSTextAlignment.center;
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        return labelEmail
    }()

    lazy var collectionViewPosts: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        // margens cell
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2)
        // tamanho da celula

        let collectionViewPosts: UICollectionView  = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionViewPosts.backgroundColor = .black
        collectionViewPosts.dataSource = self
        collectionViewPosts.delegate = self
        collectionViewPosts.register(CellPost.self, forCellWithReuseIdentifier: "collectionViewPosts")
//        collectionViewPosts.backgroundColor = .red
        collectionViewPosts.translatesAutoresizingMaskIntoConstraints = false
        return collectionViewPosts

    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.title = "User"
        view.addSubview(imageUser)
        view.addSubview(labelName)
        view.addSubview(labelEmail)
        view.addSubview(collectionViewPosts)
        self.setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            posts = await postViewModel.fetchPosts()

            for i in posts {
                if let user = await userViewModel.fetchUserByID(id: i.user_id) {
                    namesUsers.append("@" + user.name)
                } else {
                    namesUsers.append(nil)
                }
            }
            collectionViewPosts.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewPosts", for: indexPath) as! CellPost
        cell.labelPost.text = posts[indexPath.item].content
        cell.labelName.text = namesUsers[indexPath.item]
        cell.labelHours.text = posts[indexPath.item].created_at        //        let text = UITextView(frame: CGRect())
        //        text.text = album[indexPath.item]
        //        text.frame.size = cell.contentView.bounds.size
        //
        //
        return cell
    }

    func setUpConstraints(){
        setUpConstraintsLabelName()
        setUpConstraintsLabelEmail()
        setUpConstraintsCollectionViewPosts()

    }
    func setUpConstraintsCollectionViewPosts(){
        NSLayoutConstraint.activate([
            collectionViewPosts.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            collectionViewPosts.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            collectionViewPosts.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionViewPosts.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height / 3)
        ])
    }

    func setUpConstraintsLabelName(){
        NSLayoutConstraint.activate([
            labelName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            labelName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180),
            labelName.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: 0.05),
            labelName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }

    func setUpConstraintsLabelEmail(){
        NSLayoutConstraint.activate([
            labelEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            labelEmail.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160),
            labelEmail.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: 0.05),
            labelEmail.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
    }
}


