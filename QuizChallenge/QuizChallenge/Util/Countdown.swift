//
//  Countdown.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

import Foundation

class Countdown{
    // MARK: Private Properties
    private let step: Double
    private var timer: Timer?
    private var timeElapsed: Double
    
    typealias TimeUpdated = (_ time: Double)->Void
    let timeUpdated: TimeUpdated
    
    //MARK: Initialization
    
    init(step: Double = 1.0, timeElapsed: Double, timeUpdated: @escaping TimeUpdated) {
        self.step = step
        self.timeUpdated = timeUpdated
        self.timeElapsed = timeElapsed
    }
    
    deinit {
        deinitTimer()
    }
    
    //MARK: Timer actions
    func toggle() {
        guard timer != nil else {
            initTimer()
            return
        }
        deinitTimer()
    }
    
    func stop() {
        deinitTimer()
        timeUpdated(0)
    }
    
    private func initTimer() {
        let action: (Timer)->Void = { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            strongSelf.timeElapsed -= strongSelf.timeElapsed - strongSelf.step
            strongSelf.timeUpdated(round(strongSelf.timeElapsed))
        }
        timer = Timer.scheduledTimer(withTimeInterval: step,
                                     repeats: true, block: action)
    }
    
    private func deinitTimer() {
        //Invalidating
        timer?.invalidate()
        timer = nil
    }
}
