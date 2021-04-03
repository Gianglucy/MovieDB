//
//  ContainerViewController.swift
//  MovieDB
//
//  Created by Apple on 10/19/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeMenu()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    func setupHomeMenu() {
        let homeMenu = HomeMenuViewController(nibName: "HomeMenuViewController", bundle: nil)
        let controller = UINavigationController(rootViewController: homeMenu)
        
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    
}
