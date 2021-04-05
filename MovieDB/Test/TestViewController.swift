//
//  TestViewController.swift
//  MovieDB
//
//  Created by Apple on 10/16/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let imageTableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var data:[String] = [
        "https://khoahocphattrien.vn/Images/Uploaded/Share/2019/03/13/dGhpZW5uaGllbg.jpg",
        "https://post.greatist.com/wp-content/uploads/sites/3/2020/02/325466_1100-1100x628.jpg",
        "https://images5.alphacoders.com/689/689398.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRCcdS8f6L5Aonc9oUP3UfD2PAPUmqF-_IBcw&usqp=CAU",
        "https://www.sukantotanoto.com.sg/wp-content/uploads/2015/02/natuer.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSF-gjb2zxSHvKXqtJNWOfLh6M7s5mI1-MC3Q&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR8xP3udrPbaSPklwCClnSP9U7ofUi9jJsv5A&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQpnJt-7crtwtjw44tkV_X-GbpcvOP7G7gDGA&usqp=CAU",
        "https://m.economictimes.com/thumb/height-450,width-600,imgsize-1016106,msid-68721417/nature1_gettyimages.jpg",
        "https://media.gettyimages.com/photos/one-man-crossing-a-pond-in-torres-del-paine-national-park-chile-picture-id1185864506?s=612x612",
        "https://www.thinkright.me/wp-content/uploads/2019/09/Untitled-design-34.jpg",
        "https://d19lgisewk9l6l.cloudfront.net/wexas/www/images/web/experience/natural-world/north-america/north-america-natural-world.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQalnOg7X39KfF3XtALuquVniJanxZoPK8F-Q&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ1BL4hb4Mjx1kraUyYhouwrlqFVftPLzsJxQ&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTadXrlwyUuwUS12bjzOuNy4xzqLlOqVoIbjw&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQD34zuaZQSztVnitWx96Ixp7_IDZZ04anx6A&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTxW1J3itUca5KYhNigJXu_Yb31o9EYEgq13A&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTxW1J3itUca5KYhNigJXu_Yb31o9EYEgq13A&usqp=CAU",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRf1-Gc0UYbfJ-WzygxhstqAVVZLfag4gdyew&usqp=CAU",
        "https://media-cdn.tripadvisor.com/media/photo-s/0d/ee/2f/5e/peyto-lake-at-about-11am.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        imageTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        imageTableView.separatorStyle = .none
        
        view.addSubview(imageTableView)
        imageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageTableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.configUI(path: data[indexPath.row],index: indexPath.row)
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
