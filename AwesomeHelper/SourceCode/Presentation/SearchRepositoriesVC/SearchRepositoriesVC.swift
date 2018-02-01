//
//  RepositoryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/13/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import UIKit
import GithubAPI
import ESPullToRefresh
import SwipeCellKit
import RealmSwift
import Font_Awesome_Swift

class SearchRepositoriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    @IBOutlet weak var queryLabel: UILabel! = nil
    var readmeString: String! = nil
    var searchQuery: Query! = nil
    var repository: Repository! = nil
    var repositories: [SearchRepositoriesItem] = [SearchRepositoriesItem]()
    var repositoriesToDisplay: [SearchRepositoriesItem] = [SearchRepositoriesItem]()
    var repositoriesCount: Int = 0
    var authentication: Credentials! = nil
    
    func filterRepositories() {
        self.repositoriesToDisplay = self.repositories.filter({ (item) -> Bool in
            let ignored = self.repository.ignoredRepos.filter("url == \"\(item.htmlUrl!)\"")
            let existInIgnored = ignored.count > 0
            let reviewed = self.repository.aprovedRepos.filter("url == \"\(item.htmlUrl!)\"")
            let existInReviewed = reviewed.count > 0
            return readmeString.contains(item.htmlUrl!) == false && existInIgnored == false && existInReviewed == false
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = searchQuery.query
        queryLabel.text = searchQuery.query
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QueryCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
        self.tableView.es.addPullToRefresh {
            self.showHUD()
            SearchAPI().searchRepositories(q: self.searchQuery.query) { (response, error) in
                if let response = response {
                    DispatchQueue.main.async {
                        self.repositoriesCount = response.totalCount!
                        self.repositories = response.items!
                        self.filterRepositories()
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.es.stopPullToRefresh()
                }
                self.hideHUD()
            }
        }
        
        self.tableView.es.addInfiniteScrolling {
            if self.repositories.count >= self.repositoriesCount {
                self.tableView.es.stopLoadingMore()
                return
            }
            self.showHUD()
            let pageNumber = Int(self.repositories.count / 100) + 1
            SearchAPI().searchRepositories(q: self.searchQuery.query, page: pageNumber, per_page: 100, completion: { (response, error) in
                if self.repositories.count >= self.repositoriesCount {
                    DispatchQueue.main.async {
                        self.tableView.es.stopLoadingMore()
                        return
                    }
                }
                if let response = response {
                    DispatchQueue.main.async {
                        self.repositories.append(contentsOf: response.items ?? [])
                        self.filterRepositories()
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.es.stopLoadingMore()
                }
                self.hideHUD()
            })
        }
        
        self.tableView.es.startPullToRefresh()
        
        self.initAuthentication()
    }
    
    func initAuthentication() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "credentials", ofType: "json")!))
        self.authentication = try? JSONDecoder().decode(Credentials.self, from: data!)
    }
}

extension SearchRepositoriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoriesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = self.repositoriesToDisplay[indexPath.row]
        let htmlUrl = repository.htmlUrl
        let name = repository.fullName
        if let htmlUrl = URL(string: htmlUrl!) {
            let webVC = WebVC.instantiateVC(screenTitle: name!, urlToLoad: htmlUrl)
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SearchRepositoryCell", for: indexPath) as! SearchRepositoryCell
        let repository = self.repositoriesToDisplay[indexPath.row]
        cell.setupWih(repository)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let repo = self.repositoriesToDisplay[indexPath.row]
            let reviewedRepo = ReviewedRepository()
            reviewedRepo.name = repo.name!
            reviewedRepo.owner = repo.owner?.login ?? ""
            reviewedRepo.url = repo.htmlUrl!
            DispatchQueue.main.async {
                do {
                    try Realm.default.write {
                        Realm.default.add(reviewedRepo)
                        self.repository.ignoredRepos.append(reviewedRepo)
                    }
                    self.filterRepositories()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        
        let addAction = SwipeAction(style: .default, title: "Add") { action, indexPath in
            let repo = self.repositoriesToDisplay[indexPath.row]
            var issue = Issue(title: repo.fullName!)
            issue.body = "[\(repo.name!)](\(repo.htmlUrl!)) - \(repo.descriptionField ?? "Need to find description"). \n Language - \(repo.language ?? "No Language")."
            self.showHUD()
            let authentication = TokenAuthentication(token: (self.authentication.token?.token)!)
            IssuesAPI(authentication: authentication).createIssue(owner: self.repository.owner, repository: self.repository.name, issue: issue, completion: { (response, error) in
                if let response = response {
                    DispatchQueue.main.async {
                        let reviewedRepository = ReviewedRepository()
                        reviewedRepository.name = repo.name!
                        reviewedRepository.owner = repo.owner?.login ?? ""
                        reviewedRepository.url = repo.htmlUrl!
                        do {
                            try Realm.default.write {
                                Realm.default.add(reviewedRepository)
                                self.repository.aprovedRepos.append(reviewedRepository)
                            }
                        } catch {
                            self.showErrorAlert(error.localizedDescription)
                        }
                        self.filterRepositories()
                        self.tableView.reloadData()
                    }
                } else {
                    self.showErrorAlert(error?.localizedDescription ?? "Unrecognized Error!")
                }
                self.hideHUD()
            })
        }
        addAction.image = UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35))
        
        
        return [addAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        //        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
}
