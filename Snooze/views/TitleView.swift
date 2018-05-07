//
//  TitleView.swift
//  Snooze
//
//  Created by Praagya Joshi on 05/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class TitleView: SNZView {
    
    let box: NSBox = {
        let box = NSBox()
        box.titlePosition = .noTitle
        box.boxType = .custom
        box.borderType = .noBorder
        box.fillColor = NSColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        box.alphaValue = 0.3
        return box
    }()
    
    let titleLabel: SNZLabel = {
        let label = SNZLabel()
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .kern: 3,
            .foregroundColor: Constants.Colors.textColor,
            .font: NSFont.systemFont(ofSize: 11)
        ]
        let attributedTitle = NSAttributedString.init(string: Constants.Strings.appName.uppercased(), attributes: textAttributes)
        
        label.attributedStringValue = attributedTitle
        label.alignment = .center
        
        return label
    }()
    
    override var wantsDefaultClipping: Bool {
        return false
    }

    override internal func customInit() {
        addSubview(box)
        addSubview(titleLabel)
        
        setupConstrains()
    }
    
    private func setupConstrains() {
        box.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(box)
            make.centerY.equalTo(box).offset(7)
        }
    }
    
}
