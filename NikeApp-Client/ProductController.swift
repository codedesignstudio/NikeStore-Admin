//
//  ProductController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import Kingfisher

struct Product{
    var name:String?
    var image:String?
    var price:String?
}


class ProductController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var category_id:String?
    var categoryName:String?
    var token:String?
    var products = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        token = UserDefaults.standard.string(forKey: "token")
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.register(ProductCell.self, forCellWithReuseIdentifier: "product")
        collectionView?.register(ProductHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "productHeader")
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 130)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
    }
    override func viewWillAppear(_ animated: Bool) {
        getProducts()
    }
    func addProduct(){
        let vcc = AddProductController()
        vcc.category_id = category_id
        let vc = UINavigationController(rootViewController: vcc)
        
        self.present(vc, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "productHeader", for: indexPath) as! ProductHeader
        head.catName = categoryName?.lowercased()
        return head
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        cell.product = products[indexPath.row]
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
class ProductCell: UICollectionViewCell {
    
    var product: Product?{
        didSet{
            productName.text = product?.name!
            let img = URL(string: (product?.image!)!)
            productImage.kf.setImage(with: img)
        }
    }
    
    let productName: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = .black
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .center
        return lab
    }()
    let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .randomColor()
        addSubview(productName)
        addSubview(productImage)
        NSLayoutConstraint.activate([
            productName.leftAnchor.constraint(equalTo: leftAnchor,constant: 8),
            productName.topAnchor.constraint(equalTo: topAnchor),
            productName.widthAnchor.constraint(equalTo: widthAnchor),
            productName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
        
            productImage.topAnchor.constraint(equalTo: productName.bottomAnchor),
            productImage.rightAnchor.constraint(equalTo: rightAnchor),
            productImage.widthAnchor.constraint(equalTo: widthAnchor),
            productImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductHeader: UICollectionViewCell {
    
    var catName:String?{
        didSet{
            categoryText.text = "#\(catName!)"
        }
    }
    
    let categoryText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .randomColor()
        addSubview(categoryText)
        addConstraintsWithFormat("H:|[v0]|", views: categoryText)
        addConstraintsWithFormat("V:|[v0]|", views: categoryText)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
