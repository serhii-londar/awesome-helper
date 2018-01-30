//
//  RepositoriesVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/29/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import GithubAPI
import SwipeCellKit

class RepositoriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    var repositories: Repositories! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHUD()
        do {
            self.repositories = try Repositories.load()
        } catch {
            self.repositories = Repositories()
        }
        self.tableView.reloadData()
        self.hideHUD()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func addRepositoryButtonPressed(_ sender: AnyObject) {
        let addRepositoryVC = Storyboards.Main.instantiateAddRepositoryVC()
        self.navigationController?.pushViewController(addRepositoryVC, animated: true)
    }
}

extension RepositoriesVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let repo = self.repositories.repositories![indexPath.row]
            do {
                try self.repositories.remove(repo)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        deleteAction.image = UIImage(named: "deleteIcon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (repositories.repositories?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        let repository = self.repositories.repositories![indexPath.row]
        cell.setupWith(repository)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.repositories.repositories![indexPath.row]
        self.showHUD()
        RepositoriesContentsAPI().getReadme(owner: repo.owner!, repo: repo.name!) { (response, error) in
            DispatchQueue.main.async {
                if let response = response {
                    let queriesVC = Storyboards.Main.instantiateQueriesVC()
                    queriesVC.queries = try! Queries(repositoryName: repo.name!)
                    queriesVC.readmeString = response.content?.fromBase64()
                    queriesVC.repository = repo
                    self.navigationController?.pushViewController(queriesVC, animated: true)
                } else {
                    self.showErrorAlert((error?.localizedDescription)!)
                }
                self.hideHUD()
            }
        }
    }
}
