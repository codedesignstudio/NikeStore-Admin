//
//  CategoryController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Material
import Kingfisher

struct Category{
    var categoryName:String?
    var categoryId:String?
    var categoryImage:String?
    var numberOfProducts: String?
}


class CategoryController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var token:String?
    var categories = [Category]()

    let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let col = UICollectionView(frame: .zero, collectionViewLayout: flow)
        col.backgroundColor = .white
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")
        title = "Nike"
        if UserDefaults.standard.bool(forKey: "isLoggedIn") != true {
            self.present(LoginViewController(), animated: false, completion: nil)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white

        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        collectionView.register(CatCell.self, forCellWithReuseIdentifier: "cat")
        collectionView.register(CatHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        categories = []
        getCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CatHeader
        header.parentViewController = self
        
        return header
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath) as! CatCell
        cell.category = categories[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: Double = Double(screenRect.size.width)
        let cellWidth: Double = screenWidth / 2.0
        var size = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.category_id = categories[indexPath.row].categoryId!
        vc.categoryName = categories[indexPath.row].categoryName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class CatCell: UICollectionViewCell {
    
    var category: Category?{
        didSet{
//            guard let categoryN = category?.categoryName, let catImage = URL(string: (category?.categoryImage)!), let productN = category?.numberOfProducts else{return}
            categoryName.text = category?.categoryName?.uppercased()
            let urll = URL(string: (category?.categoryImage)!)
            categoryImage.kf.setImage(with: urll)
            numberOfProducts.text = "9 Products"
        }
    }
    
    let categoryName: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 20)
        lab.textColor = .white
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .left
        return lab
    }()
    let numberOfProducts: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 12)
        lab.textColor = .white
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .left
        return lab
    }()
    let categoryImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
//        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .randomColor()
        addSubview(categoryName)
        addSubview(numberOfProducts)
        addSubview(categoryImage)
        
        NSLayoutConstraint.activate([
            categoryName.leftAnchor.constraint(equalTo: leftAnchor,constant: 8),
            categoryName.topAnchor.constraint(equalTo: topAnchor),
            categoryName.widthAnchor.constraint(equalTo: widthAnchor),
            categoryName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            
            numberOfProducts.leftAnchor.constraint(equalTo: leftAnchor,constant: 5),
            numberOfProducts.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: -15),
            numberOfProducts.widthAnchor.constraint(equalTo: widthAnchor),
            
            categoryImage.topAnchor.constraint(equalTo: categoryName.bottomAnchor),
            categoryImage.rightAnchor.constraint(equalTo: rightAnchor),
            categoryImage.widthAnchor.constraint(equalTo: widthAnchor),
            categoryImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),

        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CatHeader: UICollectionViewCell {
    var parentViewController: UIViewController? = nil

    let bestSellerButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add Category", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bestSellerButton)
        bestSellerButton.addTarget(self, action: #selector(CatHeader.bestSeller), for: .touchUpInside)
        addConstraintsWithFormat("H:|[v0]|", views: bestSellerButton)
        addConstraintsWithFormat("V:|[v0]|", views: bestSellerButton)

    }
    func bestSeller(){
        let vc = AddCategoryController()
        parentViewController?.present(vc, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
