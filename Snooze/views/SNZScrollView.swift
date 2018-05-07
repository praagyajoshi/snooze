//
//  SNZScrollView.swift
//  Snooze
//
//  Created by Praagya Joshi on 07/05/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class SNZScrollView: NSScrollView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        customInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        customInit()
    }
    
    internal func customInit() {
        borderType = .noBorder
        usesPredominantAxisScrolling = true
        drawsBackground = false
        verticalScrollElasticity = .none
    }
    
}
