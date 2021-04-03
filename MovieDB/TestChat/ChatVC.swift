//
//  ChatVC.swift
//  MovieDB
//
//  Created by Apple on 9/8/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

struct Chat {
    var avartar: String?
    var content: String?
    var isUser: Bool = true
    var name: String?
    var time: String?
}

class ChatVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    let textViewMaxHeight: CGFloat = 70
    var dataChat: [Chat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        customView.backgroundColor = UIColor.red
        textView.inputAccessoryView = customView
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        dataChat = [
            Chat(avartar: "", content: "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abcabc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abcabc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc", isUser: true, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "a", isUser: false, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: true, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: false, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abcabc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abcabc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc", isUser: true, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "aGFFG abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc ab", isUser: false, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: true, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: false, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "a", isUser: false, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: true, name: "ABC", time: "9:39"),
            Chat(avartar: "", content: "abc", isUser: false, name: "ABC", time: "9:39")
        ]
        
        chatTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        textView.delegate = self
        textView.layer.cornerRadius = textView.frame.height / 2
        textView.backgroundColor = Colors.inputChat
        //        textView.pla
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let count = dataChat?.count else { return }
        let index = count - 1
        let indexPath = IndexPath(row: index, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func send(_ sender: UIButton) {

        guard let message = textView.text else { return }
        if message.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Alert.instance.oneOption(this: self, title: "Warnning", content: "Please Fill", titleButton: "OK", completion: {()in})
            constraintHeight.constant = 33
        } else {
            dataChat?.append(Chat(avartar: "", content: message.trimmingCharacters(in: .whitespacesAndNewlines), isUser: true, name: "ABC", time: "9:39"))
            textView.text = nil
            constraintHeight.constant = 33
            chatTableView.reloadData()
            guard let count = dataChat?.count else { return }
            let index = count - 1
            let indexPath = IndexPath(row: index, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= self.textViewMaxHeight {
            constraintHeight.constant = self.textViewMaxHeight
        } else {
            constraintHeight.constant = textView.contentSize.height
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataChat?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        guard let chat = self.dataChat else { return cell }
        cell.configCell(chat: chat[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
