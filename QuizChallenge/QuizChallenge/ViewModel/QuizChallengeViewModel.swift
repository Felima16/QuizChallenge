//
//  QuizChallengeViewModel.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import Foundation
import UIKit

class QuizChallengeViewModel{
    var showLoadingHud: Bindable = Bindable(false)
    var enableStart: Bindable = Bindable(false)
    var onCountAnswer: Bindable = Bindable("00/50")
    var updateTimer: Bindable = Bindable("05:00")
    var onChallengeLoad: Bindable<String?> = Bindable(nil)
    var onShowAlert: Bindable<UIAlertController?> = Bindable(nil)
    var onUpdateConstraint: Bindable<CGFloat> = Bindable(0)
    var answer: [String] = []
    var playerAnswer: [String] = []{
        didSet{
            onCountAnswer.value = "\(self.playerAnswer.count)/\(self.answer.count)"
        }
    }
    
    private lazy var countdown = Countdown(timeElapsed: 300.0, timeUpdated: { [weak self] timeInterval in
        guard let strongSelf = self else { return }
        strongSelf.updateTimer.value = strongSelf.timeString(from: timeInterval)
    })
    
    init() {
        self.registerForKeyboardNotifications()
    }
    deinit {
        unregisterForKeyboardNotifications()
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    fileprivate func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = notification.keyboardSize
        let keyboardHeight = keyboardSize?.height ?? 250
        onUpdateConstraint.value = keyboardHeight + 40
    }

    @objc func keyboardWillHide(notification: Notification){
        onUpdateConstraint.value = 0
    }
    
    func getChallenge(){
        showLoadingHud.value = true
        API.get(Challenge.self, endpoint: .challenge(1), success: { [weak self] (result) in
            if !result.answer.isEmpty{
                self!.answer = result.answer
                self!.enableStart.value = true
                self!.onChallengeLoad.value = result.question
            }
        }) { [weak self]  (error) in
            let okAlert = SingleButtonAlert(
                title: error.localizedDescription,
                message: "Could not simulate.",
                action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
            )
            self!.onShowAlert.value = okAlert.createAlert()
        }
    }
    
    func startChallenge(){
        countdown.toggle()
    }
    
    func stopChallenge(){
        countdown.stop()
    }
    
    func verifyAnswer(_ answer: String){
        if self.answer.contains(answer){
            if !playerAnswer.contains(answer){
                playerAnswer.append(answer)
                if playerAnswer.count == 50 {
                    self.gameWin()
                }
            }
        }
    }
    
    private func gameOver(){
        self.countdown.stop()
        let okAlert = SingleButtonAlert(
            title: "Time finished",
            message: "Sorry, time is up! you got \(playerAnswer.count) out of 50 answers",
            action: AlertAction(buttonTitle: "TRY AGAIN", handler: { print("Ok pressed!") })
        )
        self.onShowAlert.value = okAlert.createAlert()
    }
    
    private func gameWin(){
        self.countdown.stop()
        let okAlert = SingleButtonAlert(
            title: "Congratulations",
            message: "Good job! you found all the answers on time. Keep up with the great work!",
            action: AlertAction(buttonTitle: "PLAY AGAIN", handler: { print("Ok pressed!") })
        )
        self.onShowAlert.value = okAlert.createAlert()
    }
}
