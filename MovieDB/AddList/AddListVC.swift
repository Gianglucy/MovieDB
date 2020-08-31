//
//  AddListVC.swift
//  MovieDB
//
//  Created by Apple on 8/28/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

protocol AddListVCDelegate {
    func passData(name: String, description: String)
}

class AddListVC: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var addListModal: AddListModalView!
    var delegate: AddListVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 0.5 * keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupUI() {
        addListModal.delegate = self
        addListModal.layer.cornerRadius = Constants.cornerRadius
        
        background.isUserInteractionEnabled = true
        let touchOutSide = UITapGestureRecognizer(target: self, action: #selector(touchOutSideModal))
        background.addGestureRecognizer(touchOutSide)
    }
    
    @objc func touchOutSideModal(){
        dismiss(animated: true)
    }
}

extension AddListVC: AddListModalViewDelegate {
    func passData() {
        delegate?.passData(name: addListModal.nameTextField.text ?? "", description: addListModal.descriptionTextField.text ?? "")
    }
}
