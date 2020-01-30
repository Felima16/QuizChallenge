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
    var onCountAnswer: Bindable = Bindable("")
    var updateTimer: Bindable = Bindable("05:00")
    var onChallengeLoad: Bindable<String?> = Bindable(nil)
    var onShowAlert: Bindable<UIAlertController?> = Bindable(nil)
    var answer: [String] = []
    var playerAnswer: [String] = []{
        didSet{
            onCountAnswer.value = "\(self.playerAnswer.count)/\(self.answer.count)"
        }
    }
    
    private lazy var countdown = Countdown(timeElapsed: 300.0, timeUpdated: { [weak self] timeInterval in
        guard let strongSelf = self else { return }
        if timeInterval == 0 {
            
        }
        strongSelf.updateTimer.value = strongSelf.timeString(from: timeInterval)
    })
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    
    func getChallenge(){
        showLoadingHud.value = true
        API.get(Challenge.self, endpoint: .challenge(1), success: { [weak self] (result) in
            if !result.answer.isEmpty{
                self!.answer = result.answer
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
    
    func verifyAnswer(_ answer: String){
        if self.answer.contains(answer){
            playerAnswer.append(answer)
        }
    }
    
    private func gameOver(){
        
    }
}
