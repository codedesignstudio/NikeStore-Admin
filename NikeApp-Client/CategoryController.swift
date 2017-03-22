//
//  CategoryController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Material

struct Category{
    var categoryName:String?
    var categoryId:Int?
    var categoryImage:String?
    var numberOfProducts: Int?
}


class CategoryController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preparePageTabBarItem()

    }
    var categories = [Category]()
    init() {
        super.init(nibName: nil, bundle: nil)
        preparePageTabBarItem()
    }
    
    let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let col = UICollectionView(frame: .zero, collectionViewLayout: flow)
        col.backgroundColor = .white
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
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

        categories.append(Category(categoryName: "Bra", categoryId: 1, categoryImage: "bra", numberOfProducts: 20))
        categories.append(Category(categoryName: "Pants", categoryId: 1, categoryImage: "pants", numberOfProducts: 50))
        categories.append(Category(categoryName: "Shoes", categoryId: 1, categoryImage: "shoe", numberOfProducts: 10))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("GOT HERE")
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
}

class CatCell: UICollectionViewCell {
    
    var category: Category?{
        didSet{
            guard let categoryN = category?.categoryName, let catImage = category?.categoryImage, let productN = category?.numberOfProducts else{return}
            categoryName.text = categoryN
            categoryImage.image = UIImage(named: catImage)
            numberOfProducts.text = "\(productN) Products"
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
            categoryName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            categoryImage.topAnchor.constraint(equalTo: categoryName.bottomAnchor),
            categoryImage.rightAnchor.constraint(equalTo: rightAnchor),
            categoryImage.widthAnchor.constraint(equalTo: widthAnchor),
            categoryImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            numberOfProducts.topAnchor.constraint(equalTo: categoryImage.bottomAnchor),
            numberOfProducts.leftAnchor.constraint(equalTo: leftAnchor,constant: 8),
            numberOfProducts.widthAnchor.constraint(equalTo: widthAnchor),
            numberOfProducts.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
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

extension CategoryController {
    fileprivate func preparePageTabBarItem() {
        pageTabBarItem.title = "Category"
        pageTabBarItem.titleColor = Color.blueGrey.base
    }
}
