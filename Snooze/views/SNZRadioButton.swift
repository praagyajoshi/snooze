//
//  SNZRadioButton.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

class SNZRadioButton: NSButton {
    
    enum ControlType {
        case buttonTypeSleepTime
        case buttonTypeSleepStyle
    }

    public var buttonValue: Int = 0
    public var buttonType: ControlType = .buttonTypeSleepTime
    public var cornerRadius: CGFloat = 4 {
        didSet {
            updateLayer()
        }
    }
    private var borderWidth: CGFloat = 1
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layerContentsRedrawPolicy = NSView.LayerContentsRedrawPolicy.onSetNeedsDisplay
        
        self.layer?.borderColor = NSColor.white.cgColor
        
        self.layer?.shadowColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer?.shadowOffset = CGSize.init(width: 0.4, height: 0.4)
        
        self.layer?.borderWidth = borderWidth
        
        self.image = nil
        self.alternateImage = nil
        
        setStyling()
    }
    
    private func setStyling() {
        self.layer?.cornerRadius = cornerRadius
        
        if self.state == .on {
            self.alphaValue = 1
            self.layer?.backgroundColor = NSColor.init(white: 1, alpha: 0.1).cgColor
            self.layer?.shadowOpacity = 1.0
            self.layer?.shadowRadius = 0
        } else {
            self.alphaValue = 0.2
            self.layer?.backgroundColor = NSColor.init(white: 1, alpha: 0).cgColor
            self.layer?.shadowOpacity = 0
        }
    }
    
    override var wantsUpdateLayer:Bool{
        return true
    }
    
    override func updateLayer() {
        super.updateLayer()
        setStyling()
    }
    
}
