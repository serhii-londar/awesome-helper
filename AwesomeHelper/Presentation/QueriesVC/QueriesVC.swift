//
//  ViewController.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/11/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit

class QueriesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView! = nil
    
    var repositoryHelper: RepositoryHelper! = nil
    var queries: Queries! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            self.repositoryHelper = try RepositoryHelper(repositoryName: "open-source-mac-os-apps", remoteRepositoryStringURL: "https://github.com/serhii-londar/open-source-mac-os-apps.git")
            self.queries = try Queries(repositoryName: "open-source-mac-os-apps")
        } catch {
            print(error)
        }
        self.push()
        tableView.reloadData()
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addQueryVC = storyboard.instantiateViewController(withIdentifier: "AddQueryVC") as! AddQueryVC
        addQueryVC.queries = self.queries
        self.navigationController?.pushViewController(addQueryVC, animated: true)
    }
    
    func push() {
//        self.repositoryHelper.commit()
    }
}

extension QueriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let query = self.queries.queries[indexPath.row]
            do {
                try self.queries.removeQuery(query.query)
            } catch {
                print(error)
                self.showErrorAlert(error.localizedDescription)
            }
        }
        deleteAction.image = UIImage(named: "deleteIcon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queries.queries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repositoryVC = storyboard.instantiateViewController(withIdentifier: "RepositoriesVC") as! RepositoriesVC
        repositoryVC.repositoryHelper = repositoryHelper
        repositoryVC.query = self.queries.queries[indexPath.row]
        self.navigationController?.pushViewController(repositoryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as! QueryCell
        cell.setupWith(self.queries.queries[indexPath.row])
        cell.delegate = self
        return cell
    }
}

