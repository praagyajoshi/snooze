//
//  NoClippingView.swift
//  Snooze
//
//  Created by Praagya Joshi on 06/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class NoClippingView: NSView {

    override var wantsDefaultClipping: Bool {
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        layer = NoClippingLayer()
    }
    
}

class NoClippingLayer: CALayer {
    override var masksToBounds: Bool {
        set {
            
        }
        get {
            return false
        }
    }
}
