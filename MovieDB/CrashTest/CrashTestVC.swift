//
//  CrashTestVC.swift
//  MovieDB
//
//  Created by Apple on 9/14/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class CrashTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 100, y: 150, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: UIButton) {
        fatalError()
    }
}
