//
//  RepositoriesPresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import GithubAPI
import FirebaseAuth
import Firebase
import FirebaseSDK

class RepositoriesPresenter: BasePresenter {
    var handlerId = -1
    var repositories: Repositories = {
        let id = FirebaseAuth().id
        let r = Repositories(id: id!)
        return r
    }()
    
    override var view: RepositoriesVC {
        return _view as! RepositoriesVC
    }
    
    func refreshData() {
//        self.view.showHUD()
        handlerId = repositories.addHendler({ (change) in
//            self.view.hideHUD()
            self.view.tableView.reloadData()
        })
    }
    
    func addRepository() {
        //TODO: Add DI
        let addRepositoryVC = Storyboards.Main.instantiateAddRepositoryVC()
        let addRepositoryRouter = BaseRouter(view: addRepositoryVC)
        let addRepositoryPresenter = AddRepositoryPresenter(view: addRepositoryVC, router: addRepositoryRouter)
        addRepositoryPresenter.repositories = repositories
        
        self.router.push(addRepositoryPresenter.view, animated: true)
    }
    
    
    func openRepositoryAtIndex(_ index: Int) {
        self.view.showHUD()
        let repo = self.repositories[index]
        RepositoriesContentsAPI().getReadme(owner: repo.owner, repo: repo.name) { (response, error) in
            DispatchQueue.main.async {
                self.view.hideHUD()
                if let response = response, let readmeString = response.content?.fromBase64()?.lowercased() {
                    //TODO: Add DI
                    let queriesVC = Storyboards.Main.instantiateQueriesVC()
                    let queriesRouter = BaseRouter(view: queriesVC)
                    let queriesPresenter = QueriesPresenter(view: queriesVC, router: queriesRouter, readmeString: readmeString, repository: repo)
                    self.router.push(queriesPresenter.view, animated: true)
                } else {
                    self.view.showErrorAlert((error?.localizedDescription)!)
                }
            }
        }
    }
    
    func removeRepositoryAtIndex(_ index: Int) {
        DispatchQueue.main.async {
            let repository = self.repositories[index]
            repository.queries.objects.forEach({ $0.delete() })
            repository.reviewedRepositories.objects.forEach({ $0.delete() })
            self.repositories.remove(at: index)
        }
    }
}
