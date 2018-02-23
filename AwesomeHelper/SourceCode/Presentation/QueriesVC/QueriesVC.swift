//
//  ViewController.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/11/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit
import Font_Awesome_Swift

class QueriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    
    override var presenter: QueriesPresenter {
        return _presenter as! QueriesPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.title = presenter.repository.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35)), style: .plain, target: self, action: #selector(addQueryButtonPressed(_:)))
    }    
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        self.presenter.addQuery()
    }
}

extension QueriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.presenter.deleteQueryAtIndex(indexPath.row)
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            self.presenter.editQueryAtIndex(indexPath.row)
        }
        editAction.image = UIImage.init(icon: .FAEdit, size: CGSize(width: 35, height: 35))
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.queries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.openQueryAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as! QueryCell
        cell.setupWith(self.presenter.queries[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

