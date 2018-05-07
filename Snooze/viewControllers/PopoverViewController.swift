//
//  PopoverViewController.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    
    // View instance properties
    let controlView = SleepControlView()
    let separator1 = SeparatorView()
    let backgroundView: BlurredBackgroundView = {
        let view = BlurredBackgroundView()
        return view
    }()
    let titleView = TitleView()
    let separator2 = SeparatorView()
    let powerButton: SNZButton = {
        let button = SNZButton()
        let textAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: Constants.Colors.textColor,
            .font: NSFont.systemFont(ofSize: Constants.FontSizes.small)
        ]
        let attributedTitle = NSMutableAttributedString.init(
            string: Constants.Strings.quit.uppercased(),
            attributes: textAttributes
        )
        attributedTitle.setAlignment(NSTextAlignment.center, range: NSRange.init(location: 0, length: attributedTitle.length))
        button.attributedTitle = attributedTitle
        return button
    }()
    
    // Other instance properties
    let sleepTimeView = RadioButtonsContainerView.init(withContainerType: .typeSleepTime)
    let sleepStyleView = RadioButtonsContainerView.init(withContainerType: .typeSleepStyle)
    var sleepTimer = Timer()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstrains()
        setupCallbacks()
        
        selectPreviousTime()
        selectPreviousStyle()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        sleepTimeView.scrollToSelectedButton()
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(titleView)
        view.addSubview(controlView)
        view.addSubview(separator1)
        view.addSubview(sleepTimeView)
        view.addSubview(sleepStyleView)
        view.addSubview(separator2)
        view.addSubview(powerButton)
    }
    
    private func setupConstrains() {
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-1 * Constants.Padding.vertical)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        controlView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.Padding.horizontal)
            make.right.equalToSuperview().offset(-1 * Constants.Padding.horizontal)
            make.top.equalTo(titleView.snp.bottom).offset(Constants.Padding.vertical)
        }
        
        separator1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.Padding.horizontal)
            make.right.equalToSuperview().offset(-1 * Constants.Padding.horizontal)
            make.top.equalTo(controlView.snp.bottom).offset(Constants.Padding.vertical)
        }
        
        sleepTimeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.Padding.horizontal)
            make.right.equalToSuperview().offset(-1 * Constants.Padding.horizontal)
            make.top.equalTo(separator1.snp.bottom).offset(Constants.Padding.vertical)
        }
        
        sleepStyleView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(Constants.Padding.horizontal)
            make.right.equalTo(view.snp.right).offset(-1 * Constants.Padding.horizontal)
            make.top.equalTo(sleepTimeView.snp.bottom).offset(Constants.Padding.vertical)
        }
        
        separator2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.Padding.horizontal)
            make.right.equalToSuperview().offset(-1 * Constants.Padding.horizontal)
            make.top.equalTo(sleepStyleView.snp.bottom).offset(Constants.Padding.vertical)
        }
        
        powerButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.Padding.horizontal)
            make.top.equalTo(separator2.snp.bottom).offset(Constants.Padding.vertical)
            make.bottom.equalToSuperview().offset(-1 * Constants.Padding.vertical)
        }
        
        self.view.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(340)
        }
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.top).priority(200)
            make.bottom.equalToSuperview().priority(200)
            make.left.equalToSuperview().priority(200)
            make.right.equalToSuperview().priority(200)
        }
    }
    
    private func setupCallbacks() {
        
        controlView.onSwitchChange = { (mainSwitch) in
            if (mainSwitch.checked) {
                self.startSleepTimer()
            } else {
                self.stopSleepTimer()
            }
        }
        
        sleepTimeView.onSleepTimeSelected = { (newTime) in
            self.defaults.setValue(newTime, forKey: Constants.Values.lastSelectedTimeKey)
            SleepModel.sharedModel.setTotalTime(newTime: newTime)
        }
        
        sleepStyleView.onSleepStyleSelected = { (newSleepStyle) in
            self.defaults.setValue(newSleepStyle.rawValue, forKey: Constants.Values.lastSelectedStyleKey)
            SleepModel.sharedModel.setSleepStyle(newSleepStyle: newSleepStyle)
        }
        
        powerButton.action = #selector(self.powerButtonTapped(_:))
        powerButton.target = self
    }
    
}

// MARK: Controller methods
extension PopoverViewController {
    private func selectPreviousTime() {
        let lastSelectedTime = defaults.integer(forKey: Constants.Values.lastSelectedTimeKey)
        let newSelection = (lastSelectedTime > 0 && SleepModel.sharedModel.sleepTimeDataArray.contains(lastSelectedTime)) ?
            lastSelectedTime : SleepModel.sharedModel.sleepTimeDataArray[0]
        
        SleepModel.sharedModel.setTotalTime(newTime: newSelection)
    }
    
    private func selectPreviousStyle() {
        let lastSelectedStyle = defaults.integer(forKey: Constants.Values.lastSelectedStyleKey)
        let rawValue = (lastSelectedStyle > 0 && SleepModel.sharedModel.sleepStyleDataArray.contains(lastSelectedStyle)) ?
            lastSelectedStyle : SleepModel.sharedModel.sleepStyleDataArray[0]
        let style = SleepModel.SleepStyle(rawValue: rawValue)!
        
        SleepModel.sharedModel.setSleepStyle(newSleepStyle: style)
    }
    
    private func startSleepTimer() {
        SleepModel.sharedModel.isTimerRunning.value = true
        
        sleepTimer.invalidate()
        sleepTimer = Timer.scheduledTimer(withTimeInterval: 1,
                                          repeats: true,
                                          block: { timer in
                                            self.oneSecondElapsed()
        })
    }
    
    private func stopSleepTimer() {
        sleepTimer.invalidate()
        SleepModel.sharedModel.isTimerRunning.value = false
    }
    
    private func oneSecondElapsed() {
        SleepModel.sharedModel.secondsRemaining.value -= 1
        
        if (SleepModel.sharedModel.secondsRemaining.value == 0) {
            stopSleepTimer()
            selectPreviousTime()
            processCountdownFinish()
        }
    }
    
    private func processCountdownFinish() {
        if (SleepModel.sharedModel.selectedSleepStyle.value == .sleep) {
            executeSleepCommand()
        } else if (SleepModel.sharedModel.selectedSleepStyle.value == .shutdown) {
            executeShutdownCommand()
        }
    }
    
    private func executeSleepCommand() {
        let task = Process()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["sleepnow"]
        
        if #available(OSX 10.13, *) {
            do {
                try task.run()
            } catch _ {
                print("Sleep command failed!")
            }
        } else {
            task.launch()
        }
    }
    
    private func executeShutdownCommand() {
        MDSendAppleEventToSystemProcess(kAEShutDown)
    }
    
    @objc private func powerButtonTapped(_ sender: SNZButton) {
        NSApplication.shared.terminate(self)
    }
}
