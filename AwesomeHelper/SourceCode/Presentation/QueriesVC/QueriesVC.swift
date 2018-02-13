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
    var readmeString: String! = nil
    var repository: Repository! = nil
    var queries: [Query] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.title = repository.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35)), style: .plain, target: self, action: #selector(addQueryButtonPressed(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    func refreshData() {
        Query.order(byProperty: "repository").where(value: repository.key!).observeFind { (queries) in
            self.queries = queries
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addQueryVC = storyboard.instantiateViewController(withIdentifier: "AddQueryVC") as! AddQueryVC
        addQueryVC.repository = self.repository
        self.navigationController?.pushViewController(addQueryVC, animated: true)
    }
}

extension QueriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let query = self.repository.queries[indexPath.row]
//            query.remove()
//            self.repository.queries.remove(query)
            self.tableView.reloadData()
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            let query = self.repository.queries[indexPath.row]
            let addQueryVC = Storyboards.Main.instantiateAddQueryVC()
            addQueryVC.repository = self.repository
//            addQueryVC.query = query
            self.navigationController?.pushViewController(addQueryVC, animated: true)
        }
        editAction.image = UIImage.init(icon: .FAEdit, size: CGSize(width: 35, height: 35))
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryVC = Storyboards.Main.instantiateSearchRepositoriesVC()
        repositoryVC.readmeString = readmeString
        repositoryVC.searchQuery = self.queries[indexPath.row]
        repositoryVC.repository = self.repository
        self.navigationController?.pushViewController(repositoryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as! QueryCell
        cell.setupWith(self.queries[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

