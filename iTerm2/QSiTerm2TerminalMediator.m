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
 Creates a new terminal window
 */
- (iTermTerminal *) createTerminal {
    iTermITermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    
    iTermTerminal *terminal = [[[app classForScriptingClass:@"terminal"] alloc] init];
    [[app terminals] addObject:terminal];
    
    return [terminal autorelease];
}


/*
 Executes a command in a new terminal window
 
 This method is required for this object to become a global terminal mediator in QS.
 */
- (void) performCommandInTerminal:(NSString *)command {
    // iTerm2 does not run the command if there are trailing spaces in the command
    NSString *trimmedCommand = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    iTermTerminal *terminal = [self createTerminal];
    
    iTermSession *session = [terminal launchSession:kQSiTerm2StandardSession];
    // execCommand does not work, this does, don't know why...
    [session writeContentsOfFile:nil text:trimmedCommand];
}


/*
 Executes a command in a new tab in the current terminal
 */
- (void) performCommandInTerminalTab:(NSString *)command {
    // iTerm2 does not run the command if there are trailing spaces in the command
    NSString *trimmedCommand = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    iTermITermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    iTermTerminal *terminal;
    
    if ([[app terminals] count] > 0) {
        terminal = app.currentTerminal;
    } else {
        terminal = [self createTerminal];
    }
    
    iTermSession *session = [terminal launchSession:kQSiTerm2StandardSession];
    // execCommand does not work, this does, don't know why...
    [session writeContentsOfFile:nil text:trimmedCommand];
}


/*
 Open a named session in a new terminal window
 */
- (void) openSession:(NSString *)sessionName inTab:(BOOL)inTab {
    iTermITermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];

    if (inTab && [[app terminals] count] > 0) {
        [app.currentTerminal launchSession:sessionName];
    } else {
        iTermTerminal *terminal = [self createTerminal];
        [terminal launchSession:sessionName];
    }
}


@end
