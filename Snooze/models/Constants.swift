//
//  Constants.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

struct Constants {
    struct Spacing {
        static let vertical = CGFloat(5.0)
        static let horizontal = CGFloat(5.0)
    }
    struct Padding {
        static let vertical = CGFloat(15.0)
        static let horizontal = CGFloat(15.0)
    }
    struct FontSizes {
        static let title = CGFloat(20)
        static let regular = CGFloat(13)
        static let small = CGFloat(11)
    }
    struct Colors {
        static let separatorColor = NSColor.init(rgb: 0xFFFFFF)
        static let textColor = NSColor.init(rgb: 0xFFFFFF)
        static let wakingGradientColors_2 = [NSColor.init(rgb: 0x642B73).cgColor, NSColor.init(rgb: 0xC6426E).cgColor]
        static let wakingGradientColors = [NSColor.init(rgb: 0xDA4453).cgColor, NSColor.init(rgb: 0x89216B).cgColor]
        static let wakingGradientColors_3 = [NSColor.init(rgb: 0xCC2B5E).cgColor, NSColor.init(rgb: 0x753A88).cgColor]
        static let wakingGradientColors_1 = [NSColor.init(rgb: 0x667EEA).cgColor, NSColor.init(rgb: 0x764BA2).cgColor]
        static let sleepingGradientColors = [NSColor.init(rgb: 0x302B63).cgColor, NSColor.init(rgb: 0x0F0C29).cgColor]
    }
    struct Strings {
        static let mainTitleWakeMode = "Time to 😴?"
        static let mainTitleSleepMode = "Countdown to 😴!"
        static let trySleeping = "Succumb to the dark side..."
        static let sleepTime = "Sleep time"
        static let sleepStyle = "Sleep style"
        static let goingToSleepIn = "Going to sleep in %@"
        static let goingToShutdownIn = "Going to shutdown in %@"
        static let sleep = "Sleep"
        static let shutdown = "Shutdown"
        static let appName = "Snooze"
        static let quit = "Quit"
    }
    struct Values {
        static let lastSelectedTimeKey = "lastSelectedTime"
        static let lastSelectedStyleKey = "lastSelectedStyle"
    }
}
