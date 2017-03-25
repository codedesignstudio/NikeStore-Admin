//
//  AddProductController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 25/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class AddProductController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate {
    var category_id:String?
    var selectedImages = [UIImage]()
    var imageUrls = [String]()
    var token:String?
    let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
       let col = UICollectionView(frame: .zero, collectionViewLayout: flow)
        flow.scrollDirection = .horizontal
        col.backgroundColor = .white
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    var imagePicker:UIImagePickerController!

    
    let ProductName: KaedeTextField = {
        let t = KaedeTextField()
        t.placeholderColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
        t.textColor = .white
        t.backgroundColor = .lightGray
        t.foregroundColor = .gray
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Product Name"
        return t
    }()
    
    let ProductPrice: KaedeTextField = {
        let t = KaedeTextField()
        t.placeholderColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
        t.textColor = .white
        t.backgroundColor = .lightGray
        t.foregroundColor = .gray
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Price"
        return t
    }()
    
    let ProductDescription: KaedeTextField = {
        let t = KaedeTextField()
        t.placeholderColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
        t.textColor = .white
        t.backgroundColor = .lightGray
        t.foregroundColor = .gray
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Product Description"
        return t
    }()
    
    let addImageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Upload Images", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .darkGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 1
        btn.addTarget(self, action: #selector(uploadImg), for: .touchUpInside)
        return btn
    }()
    
    let addProductButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Product  →", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 1
        btn.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        return btn
    }()

    func uploadImg(){
        present(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Product"
        token = UserDefaults.standard.string(forKey: "token")
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(unwindBack))
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        collectionView.register(ImagePeoductCell.self, forCellWithReuseIdentifier: "image")
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(ProductName)
        view.addSubview(ProductPrice)
        view.addSubview(ProductDescription)
        view.addSubview(addImageButton)
        view.addSubview(addProductButton)
        view.addSubview(collectionView)
        

        NSLayoutConstraint.activate([
//            x,y,width,height
            ProductName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ProductName.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            ProductName.heightAnchor.constraint(equalToConstant: 40),
            ProductName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            ProductPrice.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ProductPrice.topAnchor.constraint(equalTo: ProductName.bottomAnchor, constant: 20),
            ProductPrice.heightAnchor.constraint(equalToConstant: 40),
            ProductPrice.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            ProductDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ProductDescription.topAnchor.constraint(equalTo: ProductPrice.bottomAnchor, constant: 20),
            ProductDescription.heightAnchor.constraint(equalToConstant: 40),
            ProductDescription.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            addImageButton.topAnchor.constraint(equalTo: ProductDescription.bottomAnchor, constant: 20),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.heightAnchor.constraint(equalToConstant: 40),
            addImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            collectionView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 25),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 90),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            addProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addProductButton.heightAnchor.constraint(equalToConstant: 60),
            addProductButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            addProductButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImages.append(image)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            var url = "https://api.imgur.com/3/upload"
            let imageData = UIImagePNGRepresentation(selectedImages.last!)
            let str64 = imageData?.base64EncodedString()
            var params:Parameters = ["image": str64!]
            var headers:HTTPHeaders = ["Authorization": "Client-ID aab3505f42b5d63"]
            Alamofire.upload(imageData!, to: url, method: .post, headers: headers).responseJSON(completionHandler: { (response) in
                print(JSON(response.result.value))
                if response.response?.statusCode == 200{
                    let jsonObj = JSON(response.result.value)
                    let attachmentUrl = jsonObj["data"]["link"].string
                    self.imageUrls.append(attachmentUrl!)
                    let alert = UIAlertController(title: "", message: "Image uploaded Successfully", preferredStyle: .alert)
                    var action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)

                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func unwindBack(){
        self.dismiss(animated: true, completion: nil)
    }
}

class ImagePeoductCell: UICollectionViewCell {
    
    var selectedImg: UIImage?{
        didSet{
            imageView.image = selectedImg
        }
    }
    
    let imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "shoe")
        img.contentMode = .scaleAspectFit
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addConstraintsWithFormat("H:|[v0]|", views: imageView)
        addConstraintsWithFormat("V:|[v0]|", views: imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
