//
//  AddQueryPresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation

class AddQueryPresenter: BasePresenter {
    var mode: AddQueryVCMode = .create
    var repository: Repository! = nil
    var query: Query? = nil
    
    override var view: AddQueryVC {
        return _view as! AddQueryVC
    }
    
    init(view: AddQueryVC, router: BaseRouter, repository: Repository, query: Query? = nil) {
        super.init(view: view, router: router)
        self.repository = repository
        if query != nil {
            self.query = query
            mode = .edit
        } else {
            self.query = Query()
            mode = .create
        }
    }
    
    func addQuery(_ queryText: String) {
        query = Query()
        guard let query = query else { return }
        query.query = queryText
        self.view.showHUD()
        query.save { (error, ref) in
            if let error = error {
                self.view.hideHUD()
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                self.repository.queries.addObject(query)
                self.repository.save { (error, ref) in
                    self.view.hideHUD()
                    if let error = error {
                        self.view.showErrorAlert(error.localizedDescription)
                    } else {
                        self.router.pop()
                    }
                }
            }
        }
    }
    
    func editQuery(_ queryText: String) {
        guard let query = query else { return }
        query.query = queryText
        self.view.showHUD()
        query.save { (error, ref) in
            self.view.hideHUD()
            if let error = error {
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                self.router.pop()
            }
        }
    }
}
