//
//  BaseNC.swift
//  Opendota
//
//  Created by Serhii Londar on 1/23/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit

class BaseNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .blue
        self.setBottomBorderColor(self.navigationBar.barTintColor!, height: 1)
        
        let image = UIImage()
        self.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = image
        
        self.setupFonts()
    }
    
    func setupFonts() {
//        let font = UIFont.getGoodCoFont(UIFont.goodCoFontSemiBold(), andSize: 20)
//        self.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
    }
    
    func setBottomBorderColor(_ color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: self.navigationBar.frame.height, width: self.navigationBar.frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        self.navigationBar.addSubview(bottomBorderView)
    }
}
