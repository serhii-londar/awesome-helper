//
//  AddRepositoryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/29/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import GithubAPI

class AddRepositoryVC: BaseVC {
    @IBOutlet weak var repositoryOwnerTextField: UITextField! = nil
    @IBOutlet weak var repositoryNameTextField: UITextField! = nil
    @IBOutlet weak var addRepositoryButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addRepositoryButtonPressed(_ sender: AnyObject) {
        if let owner = repositoryOwnerTextField.text, let name = repositoryNameTextField.text {
            self.showHUD()
            RepositoriesAPI().get(owner: owner, repo: name, completion: { (response, error) in
                DispatchQueue.main.async {
                    self.hideHUD()
                    if let response = response {
                        self.addRepository(response)
                    } else {
                        print(error ?? "")
                    }
                }
            })
        } else {
            self.showErrorAlert("Please enter repository owner and name.")
        }
    }
    
    func addRepository(_ repo: RepositoryResponse) {
        do {
            var repositories = try Repositories.load()
            let repository = try Repository(name: repositoryNameTextField.text!, owner: repositoryOwnerTextField.text!, url: repo.url!)
            repositories.repositories?.append(repository)
            try repositories.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            self.showErrorAlert(error.localizedDescription)
        }
    }
}
