//
//  RepositoryCell.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/29/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit

class RepositoryCell: SwipeTableViewCell {
    @IBOutlet weak var nameLabel: UILabel! = nil
    @IBOutlet weak var urlLabel: UILabel! = nil
    
    func setupWith(_ repository: Repository) {
        self.nameLabel.text = repository.name
        self.urlLabel.text = repository.url
    }
}
