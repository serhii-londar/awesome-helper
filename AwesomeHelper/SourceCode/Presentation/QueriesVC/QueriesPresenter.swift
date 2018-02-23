//
//  QueriesPresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation

class QueriesPresenter: BasePresenter {
    var readmeString: String! = nil
    var repository: Repository! = nil
    var queries: [Query] = []
    
    init(view: QueriesVC, router: BaseRouter, readmeString: String, repository: Repository) {
        super.init(view: view, router: router)
        self.readmeString = readmeString
        self.repository = repository
    }
    
    override var view: QueriesVC {
        return _view as! QueriesVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    func refreshData() {
        Query.order(byProperty: "repository").where(value: repository.key!).observeFind { (queries) in
            self.queries = queries
            self.view.tableView.reloadData()
        }
    }
    
    func addQuery() {
        let addQueryVC = Storyboards.Main.instantiateAddQueryVC()
        let addQueryRouter = BaseRouter(view: addQueryVC)
        let addQueryPresenter = AddQueryPresenter(view: addQueryVC, router: addQueryRouter, repository: self.repository)
        self.router.push(addQueryPresenter.view, animated: true)
    }
    
    func deleteQueryAtIndex(_ index: Int) {
        let query = self.queries[index]
        self.view.showHUD()
        self.repository.queries.remove(at: index)
        self.repository.update(completion: { (error) in
            if let error = error {
                self.view.hideHUD()
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                query.destroy(completion: { (error) in
                    self.view.hideHUD()
                    if let error = error {
                        self.view.showErrorAlert(error.localizedDescription)
                    } else {
                        self.view.tableView.reloadData()
                    }
                })
            }
        })
    }
    
    func editQueryAtIndex(_ index: Int) {
        let query = self.queries[index]
        let addQueryVC = Storyboards.Main.instantiateAddQueryVC()
        let addQueryRouter = BaseRouter(view: addQueryVC)
        let addQueryPresenter = AddQueryPresenter(view: addQueryVC, router: addQueryRouter, repository: self.repository, query: query)
        self.router.push(addQueryPresenter.view, animated: true)
    }
    
    func openQueryAtIndex(_ index: Int) {
        let repositoryVC = Storyboards.Main.instantiateSearchRepositoriesVC()
        let repositoryRouter = BaseRouter(view: repositoryVC)
        let repositoryPresenter = SearchRepositoriesPresenter(view: repositoryVC, router: repositoryRouter, readmeString: readmeString, searchQuery: self.queries[index], repository: repository)
        self.router.push(repositoryPresenter.view, animated: true)
    }
    
}
