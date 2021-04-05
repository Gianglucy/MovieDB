//
//  ImageCell.swift
//  MovieDB
//
//  Created by Apple on 10/16/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    var hinh: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    var downloadImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(hinh)
        hinh.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        hinh.heightAnchor.constraint(equalToConstant: 100).isActive = true
        hinh.widthAnchor.constraint(equalToConstant: 300).isActive = true
        hinh.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        //        hinh.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        if let image = downloadImage{
//            self.hinh.image = image
//        } else {
//            self.hinh.image = nil
//        }
        self.hinh.image = nil
    }
    
    func configUI(path: String?,index: Int) {
//        if let image = downloadImage {
//            self.hinh.image = image
//        } else {
            let queue = DispatchQueue(label: "loadImage",qos: .background)
            queue.async {
                if let pathURL: String = path {
                    let url = URL(string: pathURL )
                    do {
                        let data = try Data(contentsOf: url!)

//                        self.downloadImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            if self.tag == index {
                                self.hinh.image = UIImage(data: data)
                            }
                        }
                    } catch {
                        print("error")
                    }
                } else {
                    return
                }
            }
//        }
        
        
    }
    
    
    //    func setUpUI(url: String) {
    //        if let image = downloadImage {
    //            self.loadImageView.image = image
    //        } else {
    //            let queue = DispatchQueue(label: "loadImage", qos: .background)
    //            queue.async {
    //                let url = URL(string: url)
    //                do {
    //                    let data = try Data(contentsOf: url!)
    //                    DispatchQueue.main.async {
    //                        self.loadImageView.image = UIImage(data: data)
    //                        self.downloadImage = UIImage(data: data)!
    //                    }
    //                } catch {
    //                    print("error")
    //                }
    //            }
    //        }
    //
    //    }
    
    
}
