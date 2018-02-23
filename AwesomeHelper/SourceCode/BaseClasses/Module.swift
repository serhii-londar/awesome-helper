//
//  Module.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/12/18.
//  Copyright © 2018 SLON. All rights reserved.
//

import Foundation

open class Module {
    open var view: BaseVC!
    open var presenter: BasePresenter!
    open var router: BaseRouter!
    
    public init(view: BaseVC, presenter: BasePresenter, router: BaseRouter) {
        self.view = view
        self.presenter = presenter
        self.router = router
        self.router.module = self
    }
    
    open func destroy() {
        self.view = nil
        self.router.module = nil
        self.router = nil
        self.presenter = nil
    }
    
    open func present(module: Module, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        self.view.present(module.view, animated: animated, completion: completion)
    }
    
    open func dismiss(animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        self.view.dismiss(animated: animated, completion: completion)
        self.destroy()
    }
    
    open func push(module: Module, animated: Bool = true) {
        self.view.navigationController?.pushViewController(module.view, animated: animated)
    }
    
    open func pop(animated: Bool = true) {
        self.view.navigationController?.popViewController(animated: animated)
        self.destroy()
    }
}
