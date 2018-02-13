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
    var mode: AddQueryVCMode = .create
    var repository: Repository! = nil
    var query: Query? = nil
    @IBOutlet weak var queryTextField: UITextField! = nil
    @IBOutlet weak var addQueryButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryTextField.placeholder = "Please enter search query here"
        if query != nil {
            queryTextField.text = query?.query
            addQueryButton.setTitle("Update Query", for: .normal)
            mode = .edit
        } else {
            query = Query()
            addQueryButton.setTitle("Add Query", for: .normal)
            mode = .create
        }
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        if let queryText = self.queryTextField.text {
            if mode == .create {
                query?.query = queryText
                query?.repository = repository.key
                query?.save(completion: { (error) in
                    if let error = error {
                        self.showErrorAlert(error.localizedDescription)
                    } else {
                        self.repository.queries.insert((self.query?.key)!, at: 0)
                        self.repository.update (completion: { (error) in
                            if let error = error {
                                self.showErrorAlert(error.localizedDescription)
                            } else {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                })
            } else if mode == .edit {
                query?.query = queryText
                query?.save(completion: { (error) in
                    if let error = error {
                        self.showErrorAlert(error.localizedDescription)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        } else {
            self.showErrorAlert("Query can't be empty")
        }
    }
}
