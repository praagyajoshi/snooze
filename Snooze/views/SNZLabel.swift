//
//  SNZLabel.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class SNZLabel: NSTextField {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        customInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        customInit()
    }
    
    private func customInit() {
        self.isEditable = false
        self.textColor = Constants.Colors.textColor
        self.font = NSFont.systemFont(ofSize: Constants.FontSizes.regular, weight: .light)
        self.isBordered = false
        self.backgroundColor = NSColor.clear
    }
    
}
