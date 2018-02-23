//
//  BaseRouter.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 4/26/17.
//  Copyright © 2017 SLON. All rights reserved.
//

import Foundation
import UIKit

public protocol BaseRouterRouterProtocol {
    var _view: BaseVC! { get }
}

public protocol RouterInput {
}

open class BaseRouter: NSObject, RouterInput {
    open weak var module: Module!
    public weak var _view: BaseVC!
    
    open var view: BaseVC {
        return _view
    }
    
    public init(view: BaseVC) {
        self._view = view
    }
    
    open func present(_ module: Module, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        self.module.present(module: module, animated: animated, completion: completion)
    }
    
    open func dismis(_ animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        if let m = self.module {
            m.dismiss(animated: animated, completion: completion)
        } else {
            self._view.dismiss(animated: animated, completion: completion)
        }
    }
    
    open func push(_ module: Module, animated: Bool) {
        self.module.push(module: module, animated: animated)
    }
    
    open func pop(_ animated: Bool = true) {
        if let m = self.module {
            m.pop(animated: animated)
        } else {
            self._view.navigationController?.popViewController(animated: animated)
        }
    }
    
    open func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        self._view.present(vc, animated: animated, completion: completion)
    }

    open func push(_ vc: UIViewController, animated: Bool) {
        self._view.navigationController?.pushViewController(vc, animated: animated)
    }
    
}
