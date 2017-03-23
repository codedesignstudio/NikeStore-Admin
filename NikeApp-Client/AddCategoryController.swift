//
//  AddCategoryController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON

class AddCategoryController: UIViewController,UIImagePickerControllerDelegate {
    
    let backButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "arrow"), for: .normal)
        btn.addTarget(self, action: #selector(unwindBack), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var token: String?
    let bottomV: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        v.alpha = 0.7
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    func unwindBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    var isSelected = false
    
    let categoryNameField = AddCategoryController.setupTextViews(placeholder: "Category Name", type: .default, secured: false)
    let addImageButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Upload Image", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(imagePcik), for: .touchUpInside)
        return btn
    }()
    let selectedImage: UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        return img
    }()
    var imagePicker:UIImagePickerController!
    func imagePcik(){
            present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = image
        } else{
            print("Something went wrong")
        }
        isSelected = true
        self.dismiss(animated: true, completion: nil)
    }
    
    let addCategory: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Category", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addCat), for: .touchUpInside)
        btn.alpha = 1
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")
        
        let imageV = UIImageView(frame: UIScreen.main.bounds)
        imageV.image = UIImage(named: "nike3")
        view.insertSubview(imageV, at: 0)
        view.addSubview(backButton)
        view.addSubview(bottomV)
        bottomV.addSubview(categoryNameField)
        selectedImage.isHidden = true
        bottomV.addSubview(addImageButton)
        bottomV.addSubview(addCategory)
        view.addSubview(selectedImage)
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  30),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            bottomV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            bottomV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomV.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            bottomV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            categoryNameField.topAnchor.constraint(equalTo: bottomV.topAnchor),
            categoryNameField.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            categoryNameField.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3),
            categoryNameField.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),
            
            addImageButton.topAnchor.constraint(equalTo: categoryNameField.bottomAnchor),
            addImageButton.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            addImageButton.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3),
            addImageButton.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),
            
            addCategory.topAnchor.constraint(equalTo: addImageButton.bottomAnchor),
            addCategory.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            addCategory.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),
            addCategory.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3),
        ])
    }

    func addCat(){
        LLSpinner.spin()
        var url = "https://api.imgur.com/3/upload"
        let imageData = UIImagePNGRepresentation(selectedImage.image!)
        let str64 = imageData?.base64EncodedString()
        var params:Parameters = ["image": str64!]
        var headers:HTTPHeaders = ["Authorization": "Client-ID aab3505f42b5d63"]
        Alamofire.upload(imageData!, to: url, method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            print(JSON(response.result.value))
            if response.response?.statusCode == 200{
                let jsonObj = JSON(response.result.value)
                guard let name = self.categoryNameField.text, let attachmentUrl = jsonObj["data"]["link"].string, let toke = self.token else {return}
                
                let params2: Parameters = ["name": name,"attachment_url": attachmentUrl,"token": toke]
                Alamofire.request(CREATE_CATEGORY, method: .post, parameters: params2, encoding: JSONEncoding(options: []), headers: nil).responseJSON(completionHandler: { (response) in
                    LLSpinner.stop()
                    print(response.result.value)
                    if response.response?.statusCode != 200{
                        let alert = UIAlertController(title: "", message: "Category Already exist", preferredStyle: .alert)
                        let cancelBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(cancelBtn)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let vcc = AppPageTabBarController(viewControllers: [CategoryController(),ProductController()], selectedIndex: 0)
                        vcc.pageTabBarAlignment = .top
                        let vc = UINavigationController(rootViewController: vcc)
                        self.present(vc, animated: false, completion: nil)
                    }
                })
            }
        })

    }
    
    static func setupTextViews(placeholder:String,type:UIKeyboardType,secured:Bool)->TextField{
        let nameField = TextField()
        nameField.placeholder = placeholder
        nameField.textAlignment = .left
        nameField.layoutEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        nameField.clearButtonMode = .whileEditing
        nameField.dividerNormalHeight = 1.0
        nameField.leftViewMode = .always
        nameField.textColor = .black
        nameField.keyboardType = type
        nameField.isSecureTextEntry = secured
        nameField.dividerNormalColor = .black
        nameField.placeholderNormalColor = UIColor.black
        nameField.dividerActiveColor = UIColor(white: 20.0, alpha: 0.7)
        nameField.placeholderActiveColor = .black
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }
    
}
