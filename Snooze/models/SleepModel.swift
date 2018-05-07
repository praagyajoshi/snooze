//
//  SleepModel.swift
//  Snooze
//
//  Created by Praagya Joshi on 05/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Foundation
import RxSwift

class SleepModel {
    
    static let sharedModel = SleepModel()
    
    // Observable instance variables
    let isTimerRunning: Variable<Bool> = Variable(false)
    let secondsRemaining: Variable<Int> = Variable(0)
    let secondsTotal: Variable<Int> = Variable(0)
    let selectedSleepStyle: Variable<SleepStyle> = Variable(.sleep)
    
    // Other instance variables
    var sleepTimer = Timer()
    var sleepTimeDataArray = [1800, 3600, 7200]
    var sleepStyleDataArray = [SleepStyle.sleep.rawValue, SleepStyle.shutdown.rawValue]
    
    // Enums
    enum SleepStyle: Int {
        case sleep = 1
        case shutdown = 2
    }
    
    func setTotalTime(newTime: Int) {
        secondsRemaining.value = newTime
        secondsTotal.value = newTime
    }
    
    func setSleepStyle(newSleepStyle: SleepStyle) {
        selectedSleepStyle.value = newSleepStyle
    }
    
}
