//
//  Alert.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import Foundation
import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
    
    func createAlert() -> UIAlertController{
        let alertController = UIAlertController(title: self.title,
                                                message: self.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: self.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in self.action.handler?() }))
        return alertController
    }
}
