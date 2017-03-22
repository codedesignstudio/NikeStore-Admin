//
//  mainViewController.swift
//  NikeApp-Client
//
//  Created by Sagaya Abdulhafeez on 19/03/2017.
//  Copyright © 2017 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit

import Material

class AppPageTabBarController: PageTabBarController {
    open override func prepare() {
        super.prepare()
        delegate = self
        preparePageTabBar()
        self.edgesForExtendedLayout = []
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isLoggedIn") != true {
            self.present(LoginViewController(), animated: false, completion: nil)
        }

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        title = "NIKE"
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") != true {
            self.present(LoginViewController(), animated: false, completion: nil)
        }

        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}

extension AppPageTabBarController {
    fileprivate func preparePageTabBar() {
        pageTabBar.lineColor = Color.blueGrey.base
        pageTabBar.dividerColor = Color.blueGrey.lighten5
    }
}

extension AppPageTabBarController: PageTabBarControllerDelegate {
    func pageTabBarController(pageTabBarController: PageTabBarController, didTransitionTo viewController: UIViewController) {
        print("pageTabBarController", pageTabBarController, "didTransitionTo viewController:", viewController)
    }
}
