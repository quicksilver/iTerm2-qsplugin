//
//  QSiTerm2TerminalMediator.m
//  QSiTerm2
//
//  Created by Andreas Johansson on 2012-03-20.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2TerminalMediator.h"

@implementation QSiTerm2TerminalMediator


/*
 Executes a command in a terminal. Where the command is run is defined by the target argument.
 */
- (void) performCommandInTerminal:(NSString *)command target:(QSTerminalTarget)target {
    // iTerm2 does not run the command if there are trailing spaces in the command
    NSString *trimmedCommand = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    iTermITermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    iTermTerminal *terminal;
    iTermSession *session;
    
    // Get terminal window
    if (target == QSTerminalTargetWindow || app.terminals.count <= 0) {
        terminal = [self createTerminalIn:app];
    } else {
        terminal = app.currentTerminal;
    }
    
    // Get terminal session
    if (target == QSTerminalTargetCurrent) {
        session = app.currentTerminal.currentSession;
    } else {
        session = [terminal launchSession:kQSiTerm2StandardSession];
    }
    
    [app activate];

    // execCommand does not work, this does, don't know why...
    [session writeContentsOfFile:nil text:trimmedCommand];
}


/*
 Executes a command in a new terminal window
 
 This method is required for this object to become a global terminal mediator in QS.
 */
- (void) performCommandInTerminal:(NSString *)command {
    [self performCommandInTerminalWindow:command];
}

/*
 Executes a command in a new terminal window
 */
- (void) performCommandInTerminalWindow:(NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetWindow];
}


/*
 Executes a command in a new tab in the current terminal
 */
- (void) performCommandInTerminalTab:(NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetTab];
}


/*
 Executes a command in the current terminal
 */
- (void) performCommandInCurrentTerminal: (NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetCurrent];
}


/*
 Creates a new terminal window
 */
- (iTermTerminal *) createTerminalIn:(iTermITermApplication *)app {
    iTermTerminal *terminal = [[[app classForScriptingClass:@"terminal"] alloc] init];
    [[app terminals] addObject:terminal];
    
    return [terminal autorelease];
}

/*
 Open a named session in a new terminal window
 */
- (void) openSession:(NSString *)sessionName target:(QSTerminalTarget)target {
    iTermITermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    
    if (target == QSTerminalTargetTab && [[app terminals] count] > 0) {
        [app.currentTerminal launchSession:sessionName];
    } else {
        iTermTerminal *terminal = [self createTerminalIn:app];
        [terminal launchSession:sessionName];
    }
}


@end
