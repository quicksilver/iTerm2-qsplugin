//
//  QSiTerm2TerminalMediator.m
//  QSiTerm2
//
//  Created by Andreas Johansson on 2012-03-20.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2TerminalMediator.h"

@implementation QSiTerm2TerminalMediator


- (id) init {
	if (self = [super init]) {
        iTerm = nil;
	}
	return self;
}


- (void) dealloc {
    if (iTerm) {
        [iTerm release];
    }
    [super dealloc];
}


/*
 Lazy accessor for the top level scripting bridge object
 */
- (iTermITermApplication *) getApp {
    if (!iTerm) {
        iTerm = [[SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle] retain];
    }

    return iTerm;
}


/*
 Creates a new terminal window
 */
- (iTermTerminal *) createTerminal {
    iTermITermApplication *app = [self getApp];
    
    iTermTerminal *terminal = [[[app classForScriptingClass:@"terminal"] alloc] init];
    [[iTerm terminals] addObject:terminal];
    
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
 Open a named session in a new terminal window
 */
- (void) openSession:(NSString *)sessionName inTab:(BOOL)inTab {
    if (inTab && [[iTerm terminals] count] > 0) {
        [iTerm.currentTerminal launchSession:sessionName];
    } else {
        iTermTerminal *terminal = [self createTerminal];
        [terminal launchSession:sessionName];
    }
}


@end
