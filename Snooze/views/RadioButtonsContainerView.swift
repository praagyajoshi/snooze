//
//  RadioButtonsContainerView.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa
import RxSwift

class RadioButtonsContainerView: NoClippingView {
    
    enum ContainerViewType {
        case typeSleepTime
        case typeSleepStyle
    }
    
    // View instance properties
    let titleLabel = SNZLabel()
    
    let stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .gravityAreas
        stackView.spacing = Constants.Padding.horizontal
        return stackView
    }()
    
    let scrollView = SNZScrollView()
    
    var radioButtons = [SNZRadioButton]()
    
    // Other instance properties
    var type: ContainerViewType = .typeSleepTime
    let disposeBag = DisposeBag()
    
    // Callbacks
    var onSleepTimeSelected: ((_ newTime: Int) -> ())?
    var onSleepStyleSelected: ((_ newSleepStyle: SleepModel.SleepStyle) -> ())?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        customInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        customInit()
    }
    
    init(withContainerType selectedType: ContainerViewType) {
        type = selectedType
        super.init(frame: CGRect.init())
        customInit()
    }
    
    private func customInit() {
        let title = type == .typeSleepTime ?
            Constants.Strings.sleepTime : Constants.Strings.sleepStyle
        titleLabel.stringValue = title
        
        addSubview(titleLabel)
        createRadioButtons()
        scrollView.documentView = stackView
        addSubview(scrollView)
        
        setupConstrains()
        setupObservers()
    }
    
    private func createRadioButtons() {
        let dataArray = type == .typeSleepTime ?
            SleepModel.sharedModel.sleepTimeDataArray : SleepModel.sharedModel.sleepStyleDataArray
        
        for value in dataArray {
            
            let button = getRadioButton(forContainerType: type, andValue: value)
            radioButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.vertical)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1 * Constants.Spacing.vertical)
        }
    }
    
}

// MARK: View generation methods
extension RadioButtonsContainerView {
    private func getRadioButton(forContainerType containerType: ContainerViewType, andValue value: Int) -> SNZRadioButton {
        let button = SNZRadioButton()
        button.buttonValue = value
        
        if (containerType == .typeSleepTime) {
            button.buttonType = .buttonTypeSleepTime
        } else if (containerType == .typeSleepStyle) {
            button.buttonType = .buttonTypeSleepStyle
        }
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: Constants.Colors.textColor,
            .font: NSFont.systemFont(ofSize: 11)
        ]
        let attributedTitle = NSMutableAttributedString.init(
            string: getRadioButtonTitle(forButtonType: button.buttonType, andValue: value),
            attributes: textAttributes
        )
        attributedTitle.setAlignment(NSTextAlignment.center, range: NSRange.init(location: 0, length: attributedTitle.length))
        button.attributedTitle = attributedTitle
        button.action = #selector(self.buttonTapped(_:))
        button.target = self
        
        button.sizeToFit()
        let newHeight = button.frame.size.height + 2 * Constants.Spacing.vertical
        let newWidth = button.frame.size.width + 5 * Constants.Spacing.horizontal
        
        button.cornerRadius = newHeight / 2.0
        
        button.snp.makeConstraints({ (make) in
            make.height.equalTo(newHeight)
            make.width.equalTo(newWidth)
        })
        
        return button
    }
    
    private func getRadioButtonTitle(forButtonType buttonType: SNZRadioButton.ControlType, andValue value: Int) -> String {
        if (buttonType == .buttonTypeSleepTime) {
            if (value >= 3600) {
                return (value/3600 > 1) ? "\(value/3600) hours".uppercased() : "\(value/3600) hour".uppercased()
            } else if (value >= 60) {
                return (value/60 > 1) ? "\(value/60) minutes".uppercased() : "\(value/60) minute".uppercased()
            } else {
                return (value > 1) ? "\(value) seconds".uppercased() : "\(value) second".uppercased()
            }
        } else if (buttonType == .buttonTypeSleepStyle) {
            switch value {
                case SleepModel.SleepStyle.sleep.rawValue:
                    return Constants.Strings.sleep.uppercased()
                case SleepModel.SleepStyle.shutdown.rawValue:
                    return Constants.Strings.shutdown.uppercased()
                default:
                    return ""
            }
        }
        
        return ""
    }
}

// MARK: RxSwift setup
extension RadioButtonsContainerView {
    private func setupObservers() {
        setupSleepStyleObserver()
        setupSecondsTotalObserver()
    }
    
    private func setupSleepStyleObserver() {
        SleepModel.sharedModel.selectedSleepStyle.asObservable()
            .subscribe(onNext: { newStyle in
                if (self.type == .typeSleepStyle) {
                    self.refreshSleepStyleButtons(forNewStyle: newStyle)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSecondsTotalObserver() {
        SleepModel.sharedModel.secondsTotal.asObservable()
            .subscribe(onNext: { newTotalTime in
                if (self.type == .typeSleepTime) {
                    self.refreshSleepTimeButtons(forNewTime: newTotalTime)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: View updation methods
extension RadioButtonsContainerView {
    private func refreshSleepStyleButtons(forNewStyle newStyle: SleepModel.SleepStyle) {
        if (type == .typeSleepStyle) {
            for button in radioButtons {
                if (button.buttonType == .buttonTypeSleepStyle) {
                    if (button.buttonValue == newStyle.rawValue) {
                        button.state = .on
                        scroll(toButton: button)
                    } else {
                        button.state = .off
                    }
                }
            }
        }
    }
    
    private func refreshSleepTimeButtons(forNewTime newTime: Int) {
        if (type == .typeSleepTime) {
            for button in radioButtons {
                if (button.buttonType == .buttonTypeSleepTime) {
                    if (button.buttonValue == newTime) {
                        button.state = .on
                        scroll(toButton: button)
                    } else {
                        button.state = .off
                    }
                }
            }
        }
    }
    
    public func scrollToSelectedButton() {
        var selectedButton :SNZRadioButton?
        selectedButton = nil
        
        for button in radioButtons {
            if (button.state == .on) {
                selectedButton = button
            }
        }
        
        if (selectedButton != nil) {
            scroll(toButton: selectedButton!)
        }
    }
    
    private func scroll(toButton button: SNZRadioButton) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.3
        let clipView = scrollView.contentView
        clipView.animator().setBoundsOrigin(NSPoint.init(x: button.frame.origin.x, y: button.frame.origin.y))
        scrollView.reflectScrolledClipView(scrollView.contentView)
        NSAnimationContext.endGrouping()
    }
}

// MARK: Action handlers
extension RadioButtonsContainerView {
    @objc func buttonTapped(_ sender: SNZRadioButton) {
        if (type == .typeSleepStyle && sender.buttonType == .buttonTypeSleepStyle) {
            onSleepStyleSelected?(SleepModel.SleepStyle(rawValue: sender.buttonValue)!)
        } else if (type == .typeSleepTime && sender.buttonType == .buttonTypeSleepTime) {
            onSleepTimeSelected?(sender.buttonValue)
        }
    }
}
