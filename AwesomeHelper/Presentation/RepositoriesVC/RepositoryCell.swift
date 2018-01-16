//
//  RepositoryCell.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/15/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit
import GithubAPI
import Kingfisher
import NSDate_TimeAgo

class RepositoryCell: SwipeTableViewCell {
    @IBOutlet weak var ownerAvatar: UIImageView! = nil
    @IBOutlet weak var repoName: UILabel! = nil
    @IBOutlet weak var repoDescription: UILabel! = nil
    @IBOutlet weak var repoLanguage: UILabel! = nil
    @IBOutlet weak var repoStartCount: UILabel! = nil
    @IBOutlet weak var repoStarsImageView: UIImageView! = nil
    @IBOutlet weak var repoForksCount: UILabel! = nil
    @IBOutlet weak var repoForksImageView: UIImageView! = nil
    @IBOutlet weak var repoLastModifiedDate: UILabel! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupWih(_ repository: SearchRepositoriesItem) {
        if let avatarUrl = repository.owner?.avatarUrl {
            self.ownerAvatar.kf.setImage(with: URL(string: avatarUrl)!, placeholder: UIImage(named: "mark-github"))
        } else {
            self.ownerAvatar.image = UIImage(named: "mark-github")
        }
        self.repoName.text = repository.fullName
        self.repoDescription.text = repository.descriptionField
        self.repoLanguage.text = repository.language
        if let starsCount = repository.stargazersCount {
            self.repoStartCount.text = String(starsCount)
            self.repoStartCount.isHidden = false
            self.repoStarsImageView.isHidden = false
        } else {
            self.repoStartCount.text = nil
            self.repoStartCount.isHidden = false
            self.repoStarsImageView.isHidden = false
        }
        
        if let forksCount = repository.forksCount {
            self.repoForksCount.text = String(forksCount)
            self.repoForksCount.isHidden = false
            self.repoForksImageView.isHidden = false
        } else {
            self.repoForksCount.text = nil
            self.repoForksCount.isHidden = false
            self.repoForksImageView.isHidden = false
        }
        
        if let updatedAt = repository.updatedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: updatedAt) {
                self.repoLastModifiedDate.text = (date as NSDate).dateTimeAgo()
            }
        }
    }
}
