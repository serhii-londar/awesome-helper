//
//  AddQueryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/16/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit

enum AddQueryVCMode {
    case create
    case edit
}

class AddQueryVC: BaseVC {
    @IBOutlet weak var queryTextField: UITextField! = nil
    @IBOutlet weak var addQueryButton: UIButton! = nil
    
    override var presenter: AddQueryPresenter {
        return _presenter as! AddQueryPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryTextField.placeholder = "Please enter search query here"
        if self.presenter.mode == .edit {
            queryTextField.text = self.presenter.query?.query
            addQueryButton.setTitle("Update Query", for: .normal)
        } else {
            addQueryButton.setTitle("Add Query", for: .normal)
        }
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        if let queryText = self.queryTextField.text {
            if self.presenter.mode == .create {
                self.presenter.addQuery(queryText)
            } else {
                self.presenter.editQuery(queryText)
            }
        } else {
            self.showErrorAlert("Query can't be empty")
        }
    }
}
