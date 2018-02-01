//
//  AddQueryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/16/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import RealmSwift

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
            do {
                if mode == .create {
                    try Realm.default.write {
                        query?.query = queryText
                        query?.repository = repository
                        Realm.default.add(query!)
                        repository.queries.append(query!)
                    }
                } else if mode == .edit {
                    try Realm.default.write {
                        query?.query = queryText
                    }
                }
                self.navigationController?.popViewController(animated: true)
            } catch {
                self.showErrorAlert(error.localizedDescription)
            }
        } else {
            self.showErrorAlert("Query can't be empty")
        }
    }
}
