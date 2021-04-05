//
//  HomeMenuViewController.swift
//  MovieDB
//
//  Created by Apple on 10/19/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class HomeMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configNavigationBar()
    }

    @objc func handleMenu() {
        print("aaaa")
    }
    
    func configNavigationBar(){
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenu))
    }
    
}
