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
            query?.query = queryText
            query?.repository = repository.key
            self.view.showHUD()
            query?.save(completion: { (error) in
                if let error = error {
                    self.view.hideHUD()
                    self.view.showErrorAlert(error.localizedDescription)
                } else {
                    self.repository.queries.insert((self.query?.key)!, at: 0)
                    self.repository.update (completion: { (error) in
                        self.view.hideHUD()
                        if let error = error {
                            self.view.showErrorAlert(error.localizedDescription)
                        } else {
                            self.router.pop()
                        }
                    })
                }
            })
    }
    
    func editQuery(_ queryText: String) {
        query?.query = queryText
        self.view.showHUD()
        query?.update(completion: { (error) in
            self.view.hideHUD()
            if let error = error {
                self.view.showErrorAlert(error.localizedDescription)
            } else {
                self.router.pop()
            }
        })
    }
}
