//
//  ProductController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Material
import GSKStretchyHeaderView


class ProductController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var category_id:String?
    var categoryName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(category_id)
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.register(ProductCell.self, forCellWithReuseIdentifier: "product")
        collectionView?.register(ProductHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "productHeader")
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 130)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
    }
    func addProduct(){
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "productHeader", for: indexPath) as! ProductHeader
        head.catName = categoryName?.lowercased()
        return head
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCell
        
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
   override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .randomColor()
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
