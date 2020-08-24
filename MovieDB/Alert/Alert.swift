//
//  Alert.swift
//  MovieDB
//
//  Created by Apple on 8/22/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static let instance = Alert()
    
    func oneOption( this: AnyObject , title: String, content: String, titleButton:String, completion: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleButton, style: .default, handler: { action in
            completion()
        }))
        this.present(alert, animated: true, completion: nil)
    }
    
    func twoOption( this: AnyObject , title: String, content: String, titleButtonFirst: String, titleButtonSecond: String,  first: @escaping ()->Void, second: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleButtonFirst, style: .default, handler: { action in
            first()
        }))
        alert.addAction(UIAlertAction(title: titleButtonSecond, style: .default, handler: { action in
            second()
        }))
        this.present(alert, animated: true, completion: nil)
    }
}
