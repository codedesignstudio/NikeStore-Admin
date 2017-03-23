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
        LLSpinner.spin()
        guard let toke = token else{return}
        let headers:HTTPHeaders = ["token": toke]
        Alamofire.request(CATEGORIES, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers).responseJSON { (response) in
            if response.response?.statusCode == 200{
                LLSpinner.stop()
                let jsonObject = JSON(response.result.value)
                let categoriess = jsonObject["categories"].array
                for category in categoriess! {
                    let name = category["name"].string
                    let image_url = category["attachment_url"].string
                    let newCategory = Category(categoryName: name!, categoryId: nil, categoryImage: image_url!, numberOfProducts: nil)
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
