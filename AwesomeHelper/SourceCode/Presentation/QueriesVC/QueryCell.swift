//
//  QueryCell.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/16/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import SwipeCellKit

class QueryCell: SwipeTableViewCell {
    @IBOutlet weak var queryName: UILabel! = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(_ query: Query) {
        self.queryName.text = query.query
    }
}
