//
//  extension.swift
//  MAX
//
//  Created by Sagaya Abdulhafeez on 02/01/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CategoryController {
    func getCategories(){
        categories = []
        guard let toke = token else{return}
        let headers:HTTPHeaders = ["token": toke]
        LLSpinner.spin()
        Alamofire.request(CATEGORIES, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers).responseJSON { (response) in
            if response.response?.statusCode == 200{
                LLSpinner.stop()
                let jsonObject = JSON(response.result.value)
                let categoriess = jsonObject["categories"].array
                for category in categoriess! {
                    let name = category["name"].string
                    let image_url = category["attachment_url"].string
                    let id = category["objectId"].string
                    
                    let newCategory = Category(categoryName: name!, categoryId: id!, categoryImage: image_url!, numberOfProducts: nil)
                    self.categories.append(newCategory)
                    print(name)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }else{
                LLSpinner.stop()
            }
        }
    }
}

extension AddProductController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImagePeoductCell
        cell.backgroundColor = .white
        cell.selectedImg = selectedImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect: CGRect = collectionView.bounds
        let screenWidth: Double = Double(screenRect.size.width)
        let cellWidth: Double = screenWidth / 2.0
        var size = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        return size
    }
    func addProduct(){
        LLSpinner.spin()
        var params: Parameters = ["category_id": category_id!, "name": ProductName.text!,"images": imageUrls,"price": ProductPrice.text!,"token":token!, "lorem": ProductDescription.text!]
        Alamofire.request(CREATE_PRODUCT, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseJSON { (response) in
            print(JSON(response.result.value))
            if response.response?.statusCode == 200{
                LLSpinner.stop()
                self.dismiss(animated: true, completion: nil)
            }else{
                LLSpinner.stop()
                let alert = UIAlertController(title: "Error", message: "Unable to add product", preferredStyle: .alert)
                var action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


extension ProductController{
    func getProducts(){
        products = []
        LLSpinner.spin()
        let url = "\(BASE)/categories/\(category_id!)/products"
        let header:HTTPHeaders = ["token": token!]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: header).responseJSON { (response) in
            print(JSON(response.result.value))
            if response.response?.statusCode == 200{
                LLSpinner.stop()
                let jsonObject = JSON(response.result.value)
                print(jsonObject)
                let productss = jsonObject["products"].array
                for product in productss!{
                    let images = product["images"].arrayObject
                    let image = images?[0] as! String
                    let name = product["name"].string
                    let price = product["price"].string
                    var newProduct = Product(name: name!, image: image, price: price!)
                    self.products.append(newProduct)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }else{
                LLSpinner.stop()
            }
        }
        
    }
}

