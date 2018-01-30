//
//  ViewController.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/11/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit

class QueriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    var readmeString: String! = nil
    var queries: Queries! = nil
    var repository: Repository! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            self.queries = try Queries(repositoryName: queries.repositoryName)
        } catch {
            self.showErrorAlert(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addQueryVC = storyboard.instantiateViewController(withIdentifier: "AddQueryVC") as! AddQueryVC
        addQueryVC.queries = self.queries
        self.navigationController?.pushViewController(addQueryVC, animated: true)
    }
}

extension QueriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let query = self.queries.queries[indexPath.row]
            do {
                try self.queries.removeQuery(query)
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
        let repositoryVC = Storyboards.Main.instantiateSearchRepositoriesVC()
        repositoryVC.readmeString = readmeString
        repositoryVC.searchQuery = self.queries.queries[indexPath.row]
        repositoryVC.repository = self.repository
        repositoryVC.queries = self.queries
        self.navigationController?.pushViewController(repositoryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as! QueryCell
        cell.setupWith(self.queries.queries[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
}

