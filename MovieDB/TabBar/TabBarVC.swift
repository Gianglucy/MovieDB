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
//        let testVC = TestVC(nibName: "TestVC", bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let userProfileNav = UINavigationController(rootViewController: userProfileVC)
//        let testNav = UINavigationController(rootViewController: testVC)
        
        listViewControllers.append(homeNav)
        listViewControllers.append(userProfileNav)
//        listViewControllers.append(testNav)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        userProfileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
//        testNav.tabBarItem = UITabBarItem(title: "Test", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.setViewControllers(listViewControllers, animated: true)
        self.selectedIndex = 0
    }
}
