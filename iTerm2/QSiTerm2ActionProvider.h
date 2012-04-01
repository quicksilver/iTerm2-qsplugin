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

// Execute text
- (QSObject *) executeText:(QSObject *)directObj;
- (QSObject *) executeTextInTab:(QSObject *)directObj;
- (QSObject *) executeText:(QSObject *)directObj inTab:(BOOL)inTab;
// Execute a script
- (QSObject *) executeScript:(QSObject *)directObj withArguments:(QSObject *)indirectObj;
- (QSObject *) executeScriptInTab:(QSObject *)directObj withArguments:(QSObject *)indirectObj;
- (QSObject *) executeScript:(QSObject *)directObj withArguments:(QSObject *)indirectObj inTab:(BOOL)inTab;
// Open directory
- (QSObject *) openDir:(QSObject *)directObj;
- (QSObject *) openDirInTab:(QSObject *)directObj;
- (QSObject *) openDir:(QSObject *)directObj inTab:(BOOL)inTab;
// Open an object's parent
- (QSObject *) openParent:(QSObject *)directObj;
- (QSObject *) openParentInTab:(QSObject *)directObj;
- (QSObject *) openParent:(QSObject *)directObj inTab:(BOOL)inTab;

// Open an iTerm session in a window
- (QSObject *) openSessionWindow:(QSObject *)directObj;
// Open an iTerm session in a new tab
- (QSObject *) openSessionTab:(QSObject *)directObj;

// Quicksilver validation methods
- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj;
- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)directObj;
@end
