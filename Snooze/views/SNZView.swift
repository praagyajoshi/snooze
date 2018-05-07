//
//  SNZView.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class SNZView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        customInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        customInit()
    }
    
    internal func customInit() {
        fatalError("customInit() has not been implemented")
    }
    
}
