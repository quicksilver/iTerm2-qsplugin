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
    
	iTermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
	iTermWindow *terminal;
	iTermTab *tab;
    
    // Get terminal window
    if (target == QSTerminalTargetWindow || app.windows.count <= 0) {
        terminal = [self createTerminalIn:app];
    } else {
		terminal = app.currentWindow;
    }
    
    // Get terminal session
    if (target == QSTerminalTargetCurrent) {
		tab = app.currentWindow.currentTab;
		[tab writeContentsOfFile:nil text:trimmedCommand newline:YES];
    } else {
        [terminal createTabWithDefaultProfileCommand:trimmedCommand];
    }
    
    [app activate];
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
- (iTermWindow *)createTerminalIn:(iTermApplication *)app {
	return [app createWindowWithDefaultProfileCommand:@""];
}

/*
 Open a named session in a new terminal window
 */
- (void) openSession:(NSString *)sessionName target:(QSTerminalTarget)target {
	iTermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    
    if (target == QSTerminalTargetTab && [app.windows count] > 0) {
		[app.currentWindow createTabWithProfile:sessionName command:nil];
    } else {
		[app createWindowWithProfile:sessionName command:nil];
    }
}


@end
