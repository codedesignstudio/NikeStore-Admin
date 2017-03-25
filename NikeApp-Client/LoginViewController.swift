//
//  ViewController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    let bottomV: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        v.alpha = 0.7
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let username: AkiraTextField = {
        let t = AkiraTextField()
        t.placeholderColor = .black
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Username"
        return t
    }()
    let password: AkiraTextField = {
        let t = AkiraTextField()
        t.placeholderColor = .black
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Password"
        t.isSecureTextEntry = true
        return t
    }()
    
    let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 1
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    func handleLogin(){
        
        LLSpinner.spin()
        guard let usernam = username.text?.lowercased(), let passwor = password.text else {return}
        let params:Parameters = ["username": usernam, "password": passwor]
        Alamofire.request(AUTH, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseJSON { (response) in
            if response.response?.statusCode == 200{
                LLSpinner.stop()
                
                print(JSON(response.result.value))
                let jsonObject = JSON(response.result.value)
                let token = jsonObject["token"].string
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let vc = UINavigationController(rootViewController: CategoryController())
                self.present(vc, animated: false, completion: nil)
            }else{
                print(JSON(response.result.value))
                LLSpinner.stop()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageV = UIImageView(frame: UIScreen.main.bounds)
        imageV.image = UIImage(named: "nike")
        view.insertSubview(imageV, at: 0)
        view.addSubview(bottomV)
        bottomV.addSubview(username)
        bottomV.addSubview(password)
        bottomV.addSubview(signInButton)
        NSLayoutConstraint.activate([
            bottomV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            bottomV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomV.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            bottomV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            username.topAnchor.constraint(equalTo: bottomV.topAnchor),
            username.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            username.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3),
            username.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),

            password.topAnchor.constraint(equalTo: username.bottomAnchor),
            password.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            password.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3),
            password.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),
            
            signInButton.topAnchor.constraint(equalTo: password.bottomAnchor),
            signInButton.centerXAnchor.constraint(equalTo: bottomV.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: bottomV.widthAnchor, multiplier: 0.9),
            signInButton.heightAnchor.constraint(equalTo: bottomV.heightAnchor, multiplier: 1/3)

        ])
    }
}

