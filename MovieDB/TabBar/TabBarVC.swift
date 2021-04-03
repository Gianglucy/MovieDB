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
//        let chatVC = ChatVC(nibName: "ChatVC", bundle: nil)
//        let drawVC = DrawVC(nibName: "DrawVC", bundle: nil)
//        let crashTestVC = CrashTestVC(nibName: "CrashTestVC", bundle: nil)
        let testViewController = TestViewController(nibName: "TestViewController", bundle: nil)
        let containerViewController = ContainerViewController(nibName: "ContainerViewController", bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let userProfileNav = UINavigationController(rootViewController: userProfileVC)
        let chatNav = UINavigationController(rootViewController: testViewController)
        
        listViewControllers.append(homeNav)
        listViewControllers.append(userProfileNav)
        listViewControllers.append(chatNav)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        userProfileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        chatNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.setViewControllers(listViewControllers, animated: true)
        self.selectedIndex = 0
    }
}
