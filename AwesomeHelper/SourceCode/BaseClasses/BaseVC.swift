//
//  BaseVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/22/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import SVProgressHUD

public protocol ViewInput {
    
}

public protocol ViewOutput {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    
    func setupUI()
    func setupFonts()
}

public extension ViewOutput {
    
}

open class BaseVC: UIViewController, ViewInput {
    
    public var _presenter: BasePresenter! = nil
    
    open var presenter: BasePresenter {
        return _presenter
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        _presenter.viewDidLoad()
    }
    
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _presenter.viewDidAppear(animated)
    }
    
    open override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        _presenter.viewWillAppear(animated)
    }
    
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _presenter.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _presenter.viewDidDisappear(animated)
    }
    
    open func setupUI() {
        
    }
    
    open func setupFonts() {
        
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    func showHUD() {
//        DispatchQueue.main.async {
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.show()
//        }
//    }
//
//    func hideHUD() {
//        DispatchQueue.main.async {
//            SVProgressHUD.dismiss()
//        }
//    }
//
//    func showErrorAlert(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}
