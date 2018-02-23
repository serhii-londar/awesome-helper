//
//  BasePresenter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 4/12/17.
//  Copyright © 2017 SLON. All rights reserved.
//

import Foundation

open class BasePresenter: ViewOutput {
    public weak var _view: BaseVC!
    public var _router: BaseRouter!
    
    open var view: BaseVC {
        return _view
    }
    
    open var router: BaseRouter {
        return _router
    }
    
    public init(view: BaseVC, router: BaseRouter) {
        self._view = view
        self._router = router
        self._view._presenter = self
    }
    
    open func viewDidLoad() {
        
    }
    
    open func viewWillAppear(_ animated: Bool){
        
    }
    
    open func viewDidAppear(_ animated: Bool) {
        
    }
    
    open func viewWillDisappear(_ animated: Bool) {
        
    }
    
    open func viewDidDisappear(_ animated: Bool) {
        
    }
    
    public func setupUI() {
        
    }
    
    public func setupFonts() {
        
    }
}
