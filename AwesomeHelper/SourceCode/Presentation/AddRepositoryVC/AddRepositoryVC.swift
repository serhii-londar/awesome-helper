//
//  AddRepositoryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/29/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import GithubAPI
import FirebaseSDK

class AddRepositoryVC: BaseVC {
    @IBOutlet weak var repositoryOwnerTextField: UITextField! = nil
    @IBOutlet weak var repositoryNameTextField: UITextField! = nil
    @IBOutlet weak var addRepositoryButton: UIButton! = nil
    
    override var presenter: AddRepositoryPresenter {
        return _presenter as! AddRepositoryPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addRepositoryButtonPressed(_ sender: AnyObject) {
        if let owner = repositoryOwnerTextField.text, let name = repositoryNameTextField.text {
            self.presenter.addRepository(name: name, owner: owner)
        } else {
            self.showErrorAlert("Please enter repository owner and name.")
        }
    }
}
