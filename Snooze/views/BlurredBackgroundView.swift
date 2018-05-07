//
//  BlurredBackgroundView.swift
//  Snooze
//
//  Created by Praagya Joshi on 05/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa
import RxSwift

class BlurredBackgroundView: SNZView {
    
    // View instance properties
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = Constants.Colors.wakingGradientColors
        layer.startPoint = CGPoint.init(x: 0, y: 1)
        layer.endPoint = CGPoint.init(x: 1, y: 0)
        return layer
    }()
    
    // Other instance properties
    let disposeBag = DisposeBag()
    
    // Constants
    let animationName = "animateGradient"

    override internal func customInit() {
        self.wantsLayer = true
        layer?.addSublayer(gradientLayer)
        setupObservers()
    }
    
    private func transitionToSleepingMode() {
        let animation = getAnimationObject()
        animation.fromValue = gradientLayer.colors
        animation.toValue = Constants.Colors.sleepingGradientColors
        
        gradientLayer.colors = Constants.Colors.sleepingGradientColors
        gradientLayer.add(animation, forKey: animationName)
    }
    
    private func transitionToWakingMode() {
        let animation = getAnimationObject()
        animation.fromValue = gradientLayer.colors
        animation.toValue = Constants.Colors.wakingGradientColors
        
        gradientLayer.colors = Constants.Colors.wakingGradientColors
        gradientLayer.add(animation, forKey: animationName)
    }
    
    private func getAnimationObject() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 0.6
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        
        return animation
    }
    
    override func layout() {
        super.layout()
        gradientLayer.frame = (self.layer?.bounds)!
    }
    
}

// MARK: RxSwift setup
extension BlurredBackgroundView {
    private func setupObservers() {
        setupIsTimerRunningObserver()
    }
    
    private func setupIsTimerRunningObserver() {
        SleepModel.sharedModel.isTimerRunning.asObservable()
            .subscribe(onNext: { newIsTimerRunning in
                if (!newIsTimerRunning) {
                    self.transitionToWakingMode()
                } else {
                    self.transitionToSleepingMode()
                }
            })
            .disposed(by: disposeBag)
    }
}
