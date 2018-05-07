//
//  SeparatorView.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class SeparatorView: SNZView {
    
    override internal func customInit() {
        let separator = NSView.init()
        separator.wantsLayer = true
        separator.layer?.backgroundColor = Constants.Colors.separatorColor.cgColor
        separator.alphaValue = 0.2
        
        addSubview(separator)
        
        separator.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(1.0)
            make.centerY.equalTo(self)
        }
    }
    
}
