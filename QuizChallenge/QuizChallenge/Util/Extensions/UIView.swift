//
//  UIView.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import UIKit

extension UIView{
    var indicator: UIActivityIndicatorView {
        let screenHeight = UIScreen.main.bounds.height
        var centerViewY = screenHeight / 2
        
        if self.center.y < centerViewY && self.center.y < screenHeight {
            centerViewY = self.center.y
        }
        
        let centerView = CGPoint(x: self.center.x, y: centerViewY)
        let loadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        loadIndicator.style = .medium
        loadIndicator.color = .orange
        loadIndicator.hidesWhenStopped = true
        loadIndicator.center = centerView
        addSubview(loadIndicator)
        
        return loadIndicator
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
//            UIApplication.shared.beginIgnoringInteractionEvents()
            self.indicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.isUserInteractionEnabled = true
//            UIApplication.shared.endIgnoringInteractionEvents()
            for view in self.subviews where view.isKind(of: UIActivityIndicatorView.self) {
                view.removeFromSuperview()
            }
        }
    }
}
