//
//  ListCell.swift
//  MovieDB
//
//  Created by Apple on 8/29/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell { 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numOfItemLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupUI() {
    }
    
    func configCell(list: List, isLast: Bool = false) {
        self.nameLabel.text = list.name
        self.numOfItemLabel.text = "\(list.itemCount ?? 0) items"
        lineView.isHidden = isLast
    }
}
