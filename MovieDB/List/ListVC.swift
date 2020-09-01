//
//  ListVC.swift
//  MovieDB
//
//  Created by Apple on 8/29/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

protocol ListVCDelegate {
    func passData(listID: Int, movieID: Int)
}

class ListVC: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    let defaults = UserDefaults.standard
    var textNilLabel = UILabel()
    var list: [List]?
    var isAdd: Bool = false
    var delegate: ListVCDelegate?
    var movieID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getList()
        setupUI()
    }
    
    func setupUI() {
        self.title = "List"
        self.tabBarController?.tabBar.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        
        if !isAdd {
            let rightBarButton = UIBarButtonItem(title: "Add List", style: .done, target: self, action: #selector(addList))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        listTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
    }
    
    @objc func addList() {
        let addListVC = AddListVC(nibName: "AddListVC", bundle: nil)
        addListVC.delegate = self
        let navController = UINavigationController(rootViewController: addListVC)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true, completion: nil)
    }
    
    func getList() {
        if let accountID = self.defaults.string(forKey: defaultsKey.accountID) {
            guard let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) else { return }
            AuthService.shared.getCreatedList(page: 1, accountID: accountID, sessionID: sessionID){(result) in
                switch result {
                case .success(let data):
                    if data?.results?.count == 0 {
                        self.view.addSubview(self.textNilLabel)
                        self.textNilLabel.text = "You haven't created any lists."
                        self.textNilLabel.translatesAutoresizingMaskIntoConstraints = false
                        self.textNilLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                        self.textNilLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    } else {
                        self.list = data?.results
                        DispatchQueue.main.async {
                            self.textNilLabel.text = ""
                            self.listTableView.reloadData()
                        }
                    }
                case .failure(let error):
                    guard let status = error.statusCode else { return }
                    guard let message = error.statusMessage else { return }
                    Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                }
            }
        }
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        guard let list = self.list else { return cell }
        if indexPath.row == list.count - 1 {
            cell.configCell(list: list[indexPath.row], isLast: true)
        } else {
            cell.configCell(list: list[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let listID = self.list![indexPath.row].id else { return }
            guard let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) else { return }
            print("Deleted: \(listID)")
            AuthService.shared.deleteList(listID: listID, sessionID: sessionID){(result) in
                switch result {
                case .success:
                    self.list?.remove(at: indexPath.row)
                    self.listTableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.list?.count == 0 {
                        self.getList()
                    }
                case .failure(let error):
                    guard let status = error.statusCode else { return }
                    guard let message = error.statusMessage else { return }
                    if status == 11 {
                        self.list?.remove(at: indexPath.row)
                        self.listTableView.deleteRows(at: [indexPath], with: .automatic)
                        if self.list?.count == 0 {
                            self.getList()
                        }
                    } else {
                        Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAdd {
            delegate?.passData(listID: list?[indexPath.row].id ?? 0, movieID: movieID ?? 0)
        } else {
            let detailListVC = DetailListVC(nibName: "DetailListVC", bundle: nil)
            detailListVC.titleScreen = list?[indexPath.row].name
            detailListVC.listID = list?[indexPath.row].id
            detailListVC.delegate = self
            navigationController?.pushViewController(detailListVC, animated: true)
        }
    }
}

extension ListVC: AddListVCDelegate {
    func passData(name: String, description: String) {
        if name.isEmpty {
            Alert.instance.oneOption(this: self, title: "WARNING", content: "Fill name of List, Please!", titleButton: "OK", completion: {()in})
        } else {
            if let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) {
                AuthService.shared.createList(name: name, description: description, sessionID: sessionID){(result) in
                    switch result {
                    case .success(let data):
                        guard let message = data?.statusMessage else { return }
                        self.getList()
                        Alert.instance.oneOption(this: self, title: "SUCCESS", content: message , titleButton: "OK") {() in
                        }
                    case .failure(let error):
                        guard let status = error.statusCode else { return }
                        guard let message = error.statusMessage else { return }
                        Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                    }
                }
            }
            
            dismiss(animated: true)
        }
    }
}

extension ListVC: DetailListVCDelegate {
    func callBack() {
        getList()
    }
}
