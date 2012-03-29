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


- (iTermITermApplication *) getApp {
    if (!iTerm) {
        iTerm = [[SBApplication applicationWithBundleIdentifier:@"com.googlecode.iterm2"] retain];
    }

    return iTerm;
}


- (iTermTerminal *) createTerminal {
    iTermITermApplication *app = [self getApp];
    
    iTermTerminal *terminal = [[[app classForScriptingClass:@"terminal"] alloc] init];
    [[iTerm terminals] addObject:terminal];
    
    return terminal;
}


- (void) performCommandInTerminal:(NSString *)command {
    // iTerm2 does not run the command if there are trailing spaces in the command
    NSString *trimmedCommand = [command stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    iTermTerminal *terminal = [self createTerminal];
    
    iTermSession *session = [terminal launchSession:@"Default"];
    // execCommand does not work, this does, don't know why...
    [session writeContentsOfFile:nil text:trimmedCommand];
    
    [terminal release];
}


@end
