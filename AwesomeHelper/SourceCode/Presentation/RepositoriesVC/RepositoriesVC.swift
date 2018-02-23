//
//  RepositoriesVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/29/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit
import Font_Awesome_Swift
import FireRecord

class RepositoriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    
    override var presenter: RepositoriesPresenter {
        return _presenter as! RepositoriesPresenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        self.presenter.refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35)), style: .plain, target: self, action: #selector(self.addRepositoryButtonPressed(_:)))
    }
    
    
    @IBAction func addRepositoryButtonPressed(_ sender: AnyObject) {
        self.presenter.addRepository()
    }
}

extension RepositoriesVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.presenter.removeRepositoryAtIndex(indexPath.row)
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.repositories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        cell.setupWith(self.presenter.repositories[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.openRepositoryAtIndex(indexPath.row)
    }
}
