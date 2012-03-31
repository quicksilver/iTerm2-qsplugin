//
//  QSiTerm2ActionProvider.h
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-24.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QSiTerm2Definitions.h"
#import "QSiTerm2TerminalMediator.h"

#define QSShellCommandType @"qs.shellcommand"

// Quicksilver actions
@interface QSiTerm2ActionProvider : QSActionProvider {
    // The terminal is responsible for sending the actual commands to iTerm2
    QSiTerm2TerminalMediator *terminalMediator;
}

// Execute text in a new terminal
- (QSObject *) executeText:(QSObject *)directObj;
// Execute a script in a new terminal
- (QSObject *) executeScript:(QSObject *)directObj withArguments:(QSObject *)indirectObj;
// Open directory in a new terminal
- (QSObject *) openDir:(QSObject *)directObj;
// Open an object's parent in a new terminal
- (QSObject *) openParent:(QSObject *)directObj;

// Open an iTerm session in a window
- (QSObject *) openSessionWindow:(QSObject *)directObj;
// Open an iTerm session in a new tab
- (QSObject *) openSessionTab:(QSObject *)directObj;

// Quicksilver validation methods
- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj;
- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)directObj;
@end
