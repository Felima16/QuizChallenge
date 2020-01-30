//
//  Bindable.swift
//  QuizChallenge
//
//  Created by Fernanda de Lima on 30/01/20.
//  Copyright © 2020 Felima. All rights reserved.
//

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ val: T) {
        self.value = val
    }
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
