//
//  DrawVC.swift
//  MovieDB
//
//  Created by Apple on 9/10/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import RealmSwift

class DrawVC: UIViewController {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=Google+Inc&daddr=John+F.+Kennedy+International+Airport&directionsmode=transit")!)
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
//        drawRectangle()
//        drawTriangle()
        drawOval()
        let realm = try! Realm()

        // Query Realm for all dogs less than 2 years old
        let user = realm.objects(Users.self)
        print(user)
    }
    
    func drawRectangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 400, y: 200))
        path.addLine(to: CGPoint(x: 400, y: 400))
        path.addLine(to: CGPoint(x: 200, y: 400))
        path.addLine(to: CGPoint(x: 200, y: 200))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.orange.cgColor
        containerView.layer.addSublayer(shapeLayer)
    }
    
    func drawTriangle() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 300, y: 300))
        path.addLine(to: CGPoint(x: 100, y: 300))
        path.addLine(to: CGPoint(x: 200, y: 200))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.green.cgColor
        
        containerView.layer.addSublayer(shapeLayer)
    }
    
    func drawOval() {
        
        let path = UIBezierPath(ovalIn: containerView.bounds)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        containerView.layer.addSublayer(shapeLayer)
    }
}
