//
//  MDRestartShutdownLogout.h
//  Snooze
//
//  Created by Praagya Joshi on 09/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//
//  Source: https://stackoverflow.com/questions/6103962/perform-certain-system-events-mac-os-x/6105338#6105338
//

#ifndef MDRestartShutdownLogout_h
#define MDRestartShutdownLogout_h

#import <CoreServices/CoreServices.h>
/*
 *    kAERestart        will cause system to restart
 *    kAEShutDown       will cause system to shutdown
 *    kAEReallyLogout   will cause system to logout
 *    kAESleep          will cause system to sleep
 */
extern OSStatus MDSendAppleEventToSystemProcess(AEEventID eventToSend);

#endif /* MDRestartShutdownLogout_h */
