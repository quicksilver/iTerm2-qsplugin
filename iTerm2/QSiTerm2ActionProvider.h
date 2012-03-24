//
//  QSiTerm2ActionProvider.h
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-24.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QSiTerm2TerminalMediator.h"

#define QSShellCommandType @"qs.shellcommand"

@interface QSiTerm2ActionProvider : QSActionProvider {
    QSiTerm2TerminalMediator *terminalMediator;
}
- (QSObject *) executeText:(QSObject *)directObj;
@end
