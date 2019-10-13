//
//  SearchRepositoriesPresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import GithubAPI

class SearchRepositoriesPresenter: BasePresenter {
    var readmeString: String! = nil
    var searchQuery: Query! = nil
    var repository: Repository! = nil
    
    var repositories: [SearchRepositoriesItem] = [SearchRepositoriesItem]()
    var repositoriesToDisplay: [SearchRepositoriesItem] = [SearchRepositoriesItem]()
    var reviewedRepositories: [ReviewedRepository] = [ReviewedRepository]()
    
    var repositoriesCount: Int = 0
    var authentication: Credentials! = nil
    
    init(view: SearchRepositoriesVC, router: BaseRouter, readmeString: String, searchQuery: Query, repository: Repository) {
        super.init(view: view, router: router)
        self.readmeString = readmeString
        self.searchQuery = searchQuery
        self.repository = repository
        self.reviewedRepositories = self.repository.reviewedRepositories.objects
    }
    
    override var view: SearchRepositoriesVC {
        return _view as! SearchRepositoriesVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAuthentication()
    }
    
    func initAuthentication() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "credentials", ofType: "json")!))
        self.authentication = try? JSONDecoder().decode(Credentials.self, from: data!)
    }
    
    func filterRepositories() {
        self.reviewedRepositories = self.repository.reviewedRepositories.objects
        self.repositoriesToDisplay = self.repositories.filter({ (item) -> Bool in
            let reviewed = self.reviewedRepositories.filter({ (repo) -> Bool in
                return repo.url == item.htmlUrl!
            })
            let existInReviewed = reviewed.count > 0
            return readmeString.contains(item.htmlUrl!.lowercased()) == false && existInReviewed == false
        })
    }
    
    func refreshData() {
        self.view.showHUD()
        SearchAPI().searchRepositories(q: self.searchQuery.query) { (response, error) in
            self.view.hideHUD()
            if let response = response {
                DispatchQueue.main.async {
                    self.repositoriesCount = response.totalCount!
                    self.repositories = response.items!
                    self.filterRepositories()
                    self.view.tableView.reloadData()
                    if self.repositoriesToDisplay.count == 0 {
                        self.view.tableView.footer?.start()
                    }
                }
            } else if let error = error {
                self.view.showErrorAlert(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view.tableView.es.stopPullToRefresh()
            }
        }
    }
    
    func loadMoreData() {
        self.view.showHUD()
        let pageNumber = Int(self.repositories.count / 100) + 1
        SearchAPI().searchRepositories(q: self.searchQuery.query, page: pageNumber, per_page: 100, completion: { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: response.items ?? [])
                    self.filterRepositories()
                    self.view.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.view.tableView.es.stopLoadingMore()
            }
            self.view.hideHUD()
            if self.repositoriesToDisplay.count == 0 {
                self.view.tableView.footer?.start()
            }
        })
    }
    
    func openRepositoryAtIndex(_ index: Int) {
        let repository = self.repositoriesToDisplay[index]
        let htmlUrl = repository.htmlUrl
        let name = repository.fullName
        if let htmlUrl = URL(string: htmlUrl!) {
            let webVC = WebVC.instantiateVC(screenTitle: name!, urlToLoad: htmlUrl)
            self.router.push(webVC, animated: true)
        }
    }
    
    func deleteRepoAtIndex(_ index: Int) {
        let repo = self.repositoriesToDisplay[index]
        let reviewedRepository = ReviewedRepository()
        reviewedRepository.name = repo.name!
        reviewedRepository.owner = repo.owner?.login ?? ""
        reviewedRepository.url = repo.htmlUrl!
        reviewedRepository.aproved = false
        
        self.view.showHUD()
        
        reviewedRepository.save({ (error, ref) in
            if let error = error {
                self.view.hideHUD()
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                self.repository.reviewedRepositories.addObject(reviewedRepository)
                self.repository.save({ (error, ref) in
                    self.view.hideHUD()
                    if let error = error {
                        self.view.showErrorAlert(error.localizedDescription)
                    } else {
                        self.filterRepositories()
                        self.view.tableView.reloadData()
                    }
                })
            }
        })
    }
    
    func addRepoAtIndex(_ index: Int) {
        let repo = self.repositoriesToDisplay[index]
        var issue = Issue(title: repo.fullName!)
        issue.body = "[\(repo.name!)](\(repo.htmlUrl!)) - \(repo.descriptionField ?? "Need to find description") \n Language - \(repo.language ?? "No Language")"
        self.view.showHUD()
        let authentication = TokenAuthentication(token: (self.authentication.token?.token)!)
        IssuesAPI(authentication: authentication).createIssue(owner: self.repository.owner, repository: self.repository.name, issue: issue, completion: { (response, error) in
            if response != nil {
                DispatchQueue.main.async {
                    let reviewedRepository = ReviewedRepository()
                    reviewedRepository.name = repo.name!
                    reviewedRepository.owner = repo.owner?.login ?? ""
                    reviewedRepository.url = repo.htmlUrl!
                    reviewedRepository.aproved = true
                    
                    reviewedRepository.save({ (error, ref) in
                        if let error = error {
                            self.view.hideHUD()
                            self.view.showErrorAlert(error.localizedDescription)
                        } else {
                            self.repository.reviewedRepositories.addObject(reviewedRepository)
                            self.repository.save({ (error, ref) in
                                self.view.hideHUD()
                                if let error = error {
                                    self.view.showErrorAlert(error.localizedDescription)
                                } else {
                                    self.filterRepositories()
                                    self.view.tableView.reloadData()
                                }
                            })
                        }
                    })
                }
            } else {
                self.view.hideHUD()
                self.view.showErrorAlert(error?.localizedDescription ?? "Unrecognized Error!")
            }
        })
    }
    
}
