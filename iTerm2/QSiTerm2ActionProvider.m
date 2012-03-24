//
//  QSiTerm2ActionProvider.m
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-24.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2ActionProvider.h"

@implementation QSiTerm2ActionProvider


- (id) init {
	if (self = [super init]) {
        terminalMediator = [[QSiTerm2TerminalMediator alloc] init];
	}
	return self;
}


- (void) dealloc {
    [terminalMediator release];
    [super dealloc];
}


- (QSObject *) executeText:(QSObject *)directObj {
    NSString *str = [directObj objectForType:QSShellCommandType];

    if (!str) {
        str = [directObj stringValue];
    }

    [terminalMediator performCommandInTerminal:str];

    return nil;
}


@end
