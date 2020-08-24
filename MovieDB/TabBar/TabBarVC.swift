//
//  TabBarVC.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    var listViewControllers: [UINavigationController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let userProfileVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let userProfileNav = UINavigationController(rootViewController: userProfileVC)
        
        listViewControllers.append(homeNav)
        listViewControllers.append(userProfileNav)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        userProfileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.setViewControllers(listViewControllers, animated: true)
        self.selectedIndex = 0
    }
}
