//
//  AddRepositoryPresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import GithubAPI

class AddRepositoryPresenter: BasePresenter {
    var repositories: Repositories!
    
    override var view: AddRepositoryVC {
        return _view as! AddRepositoryVC
    }
    
    func addRepository(name: String, owner: String) {
        self.view.showHUD()
        RepositoriesAPI().get(owner: owner, repo: name, completion: { (response, error) in
            DispatchQueue.main.async {
                self.view.hideHUD()
                if let response = response {
                    self.addRepositoryToFirebase(response, name: name, owner: owner)
                } else if let error = error {
                    self.view.showErrorAlert(error.localizedDescription)
                }
            }
        })
    }
    
    func addRepositoryToFirebase(_ repo: RepositoryResponse, name: String, owner: String) {
        let repository = repositories.createNewObject()
        repository.name = name
        repository.owner = owner
        repository.url = repo.htmlUrl ?? "empty"
        repository.save { (error, ref) in
            if let error = error {
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                self.router.pop()
            }
        }
    }
}
