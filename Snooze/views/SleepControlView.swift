//
//  SleepControlView.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa
import SnapKit
import RxSwift

class SleepControlView: SNZView {
    
    // View instance properties
    let titleLabel: SNZLabel = {
        let label = SNZLabel()
        label.font = NSFont.systemFont(ofSize: Constants.FontSizes.title, weight: .light)
        label.stringValue = Constants.Strings.mainTitleWakeMode
        return label
    }()
    
    let subtitleLabel: SNZLabel = {
        let label = SNZLabel()
        label.stringValue = Constants.Strings.trySleeping
        return label
    }()
    
    let mainSwitch: ITSwitch = {
        let mainSwitch = ITSwitch()
        mainSwitch.focusRingType = .none
        mainSwitch.action = #selector(mainSwitchToggled(_:))
        return mainSwitch
    }()
    
    // Other instance properties
    let disposeBag = DisposeBag()
    
    // Callbacks
    var onSwitchChange: ((_ mainSwitch: ITSwitch) -> ())?
    
    override internal func customInit() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(mainSwitch)
        setupConstrains()
        setupObservers()
    }
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(mainSwitch.snp.left).offset(-1 * Constants.Spacing.horizontal)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
            make.width.equalTo(titleLabel.snp.width)
            make.bottom.equalToSuperview()
        }
        
        mainSwitch.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(49)
            make.height.equalTo(30)
        }
    }
}

// MARK: RxSwift setup
extension SleepControlView {
    private func setupObservers() {
        setupSecondsRemainingObserver()
        setupIsTimerRunningObserver()
        setupSelectSleepStyleObserver()
    }
    
    private func setupSecondsRemainingObserver() {
        SleepModel.sharedModel.secondsRemaining.asObservable()
            .subscribe(onNext: { newSecondsRemaining in
                if (SleepModel.sharedModel.isTimerRunning.value) {
                    self.updateSubtitleLabel(
                        secondsRemaining: newSecondsRemaining,
                        sleepStyle: SleepModel.sharedModel.selectedSleepStyle.value
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupIsTimerRunningObserver() {
        SleepModel.sharedModel.isTimerRunning.asObservable()
            .subscribe(onNext: { newIsTimerRunning in
                if (!newIsTimerRunning) {
                    self.resetSubtitleLabel()
                } else {
                    self.updateSubtitleLabel(
                        secondsRemaining: SleepModel.sharedModel.secondsRemaining.value,
                        sleepStyle: SleepModel.sharedModel.selectedSleepStyle.value
                    )
                }
                self.updateSwitchStatus(isChecked: newIsTimerRunning)
                self.updateTitleLabel(isTimerRunning: newIsTimerRunning)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSelectSleepStyleObserver() {
        SleepModel.sharedModel.selectedSleepStyle.asObservable()
            .subscribe(onNext: { newSleepStyle in
                if (SleepModel.sharedModel.isTimerRunning.value) {
                    self.updateSubtitleLabel(
                        secondsRemaining: SleepModel.sharedModel.secondsRemaining.value,
                        sleepStyle: newSleepStyle
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: View updation methods
extension SleepControlView {
    private func updateSubtitleLabel(secondsRemaining: Int, sleepStyle: SleepModel.SleepStyle) {
        var secs = secondsRemaining
        
        let hours = secs / 3600
        secs -= (hours * 3600)
        let minutes = (secs / 60) % 60
        secs -= (minutes * 60)
        let seconds = secs % 60
        
        let timeRemainingString = hours > 0 ?
            String(format:"%02i:%02i:%02i", hours, minutes, seconds) :
            String(format:"%02i:%02i", minutes, seconds)
        
        let format = sleepStyle == .sleep ?
            Constants.Strings.goingToSleepIn : Constants.Strings.goingToShutdownIn
        
        subtitleLabel.stringValue = String(format:format, timeRemainingString)
    }
    
    private func resetSubtitleLabel() {
        subtitleLabel.stringValue = Constants.Strings.trySleeping
    }
    
    private func updateTitleLabel(isTimerRunning isRunning: Bool) {
        titleLabel.stringValue = isRunning ?
            Constants.Strings.mainTitleSleepMode : Constants.Strings.mainTitleWakeMode
    }
    
    private func updateSwitchStatus(isChecked checked: Bool) {
        mainSwitch.checked = checked
    }
}

// MARK: Action handlers
extension SleepControlView {
    @objc func mainSwitchToggled(_ sender: ITSwitch) {
        onSwitchChange?(sender)
    }
}
