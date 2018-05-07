//
//  MDRestartShutdownLogout.m
//  Snooze
//
//  Created by Praagya Joshi on 09/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRestartShutdownLogout.h"

OSStatus MDSendAppleEventToSystemProcess(AEEventID eventToSendID) {
    AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = {0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent eventToSend = {typeNull, NULL};
    
    OSStatus status = AECreateDesc(typeProcessSerialNumber,
                                   &kPSNOfSystemProcess, sizeof(kPSNOfSystemProcess), &targetDesc);
    
    if (status != noErr) return status;
    
    status = AECreateAppleEvent(kCoreEventClass, eventToSendID,
                                &targetDesc, kAutoGenerateReturnID, kAnyTransactionID, &eventToSend);
    
    AEDisposeDesc(&targetDesc);
    
    if (status != noErr) return status;
    
    status = AESendMessage(&eventToSend, &eventReply,
                           kAENormalPriority, kAEDefaultTimeout);
    
    AEDisposeDesc(&eventToSend);
    if (status != noErr) return status;
    AEDisposeDesc(&eventReply);
    return status;
}
