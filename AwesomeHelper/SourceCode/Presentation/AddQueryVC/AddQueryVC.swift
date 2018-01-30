//
//  AddQueryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/16/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit

class AddQueryVC: BaseVC {
    var queries: Queries!
    @IBOutlet weak var queryTextField: UITextField! = nil
    @IBOutlet weak var addQueryButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryTextField.placeholder = "Please enter search query here"
    }
    
    @IBAction func addQueryButtonPressed(_ sender: Any) {
        if let queryText = self.queryTextField.text {
            do {
                _ = try self.queries.addQuery(queryText)
                self.navigationController?.popViewController(animated: true)
            } catch {
                self.showErrorAlert(error.localizedDescription)
            }
        } else {
            self.showErrorAlert("Query can't be empty")
        }
    }
}
