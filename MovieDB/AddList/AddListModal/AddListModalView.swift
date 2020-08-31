//
//  AddListModalView.swift
//  MovieDB
//
//  Created by Apple on 8/28/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

protocol AddListModalViewDelegate {
    func passData()
}

class AddListModalView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    var delegate: AddListModalViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AddListModalView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = Constants.cornerRadius
        doneButton.layer.cornerRadius = Constants.cornerRadius
    }
    
    @IBAction func pressDone(_ sender: Any) {
        delegate?.passData()
    }
    
}
