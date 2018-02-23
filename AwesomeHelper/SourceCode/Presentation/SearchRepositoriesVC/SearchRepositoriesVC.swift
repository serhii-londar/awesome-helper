//
//  RepositoryVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/13/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import UIKit
import ESPullToRefresh
import SwipeCellKit
import Font_Awesome_Swift

class SearchRepositoriesVC: BaseVC {
    @IBOutlet weak var tableView: UITableView! = nil
    @IBOutlet weak var queryLabel: UILabel! = nil
    
    override var presenter: SearchRepositoriesPresenter {
        return _presenter as! SearchRepositoriesPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.presenter.searchQuery.query
        queryLabel.text = self.presenter.searchQuery.query
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QueryCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
        
        self.tableView.es.addPullToRefresh {
            self.presenter.refreshData()
        }
        
        self.tableView.es.addInfiniteScrolling {
            if self.presenter.repositories.count >= self.presenter.repositoriesCount {
                self.tableView.es.noticeNoMoreData()
                return
            }
            self.presenter.loadMoreData()
        }
        
        self.tableView.es.startPullToRefresh()
        
    }
}

extension SearchRepositoriesVC : UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.repositoriesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.openRepositoryAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SearchRepositoryCell", for: indexPath) as! SearchRepositoryCell
        let repository = self.presenter.repositoriesToDisplay[indexPath.row]
        cell.setupWih(repository)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.presenter.deleteRepoAtIndex(indexPath.row)
        }
        deleteAction.image = UIImage.init(icon: FAType.FATrash, size: CGSize(width: 35, height: 35))
        
        let addAction = SwipeAction(style: .default, title: "Add") { action, indexPath in
            self.presenter.addRepoAtIndex(indexPath.row)
        }
        addAction.image = UIImage.init(icon: FAType.FAPlusCircle, size: CGSize(width: 35, height: 35))
        
        return [addAction, deleteAction]
    }
}
