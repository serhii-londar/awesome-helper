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
import Font_Awesome_Swift
import FireRecord

class RepositoriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    var repositories: [Repository] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        self.refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35)), style: .plain, target: self, action: #selector(self.addRepositoryButtonPressed(_:)))
    }
    
    func refreshData() {
        self.showHUD()
        Repository.all { (repositories) in
            self.hideHUD()
            self.repositories = repositories
            self.tableView.reloadData()
        }
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
            DispatchQueue.main.async {
                let repo = self.repositories[indexPath.row]
                repo.destroy(completion: { (error) in
                    self.refreshData()
                })
            }
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        let repository = self.repositories[indexPath.row]
        cell.setupWith(repository)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.repositories[indexPath.row]
        self.showHUD()
        RepositoriesContentsAPI().getReadme(owner: repo.owner!, repo: repo.name!) { (response, error) in
            DispatchQueue.main.async {
                if let response = response {
                    let queriesVC = Storyboards.Main.instantiateQueriesVC()
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
