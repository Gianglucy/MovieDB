//
//  ChatCell.swift
//  MovieDB
//
//  Created by Apple on 9/9/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userContentView: UIView!
    @IBOutlet weak var userContentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeUserLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        guestImageView.layer.cornerRadius = guestImageView.bounds.width / 2
        userContentView.layer.cornerRadius = 15
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        userContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        userContentView.backgroundColor = Colors.userChat
        view.backgroundColor = Colors.ortherChat
        timeLabel.textColor = .lightGray
        timeLabel.font = timeLabel.font.withSize(13)
        timeUserLabel.textColor = .lightGray
        timeUserLabel.font = timeUserLabel.font.withSize(13)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.guestImageView.image = nil
        self.contentLabel.text = nil
        self.userContentLabel.text = nil
        self.timeUserLabel.text = nil
        self.timeLabel.text = nil
        view.isHidden = false
        timeLabel.isHidden = false
        timeUserLabel.isHidden = false
        userContentView.isHidden = false
    }
    
    func configCell(chat: Chat) {
        guard let name = chat.name else { return }
        guard let time = chat.time else { return }
        if chat.isUser {
            view.isHidden = true
            timeLabel.isHidden = true
            userContentLabel.text = chat.content
            timeUserLabel.text = time
        } else {
            timeUserLabel.isHidden = true
            userContentView.isHidden = true
            timeLabel.text = "\(name), \(time)"
            contentLabel.text = chat.content
            guestImageView.image = UIImage(named: "ic_avatar_red")
        }
    }
}
