//
//  QSiTerm2TerminalMediator.m
//  QSiTerm2
//
//  Created by Andreas Johansson on 2012-03-20.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2TerminalMediator.h"

@implementation QSiTerm2TerminalMediator
- (void) performCommandInTerminal: (NSString *)command {
    NSAppleScript *termScript=[[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]]pathForResource:@"iTerm2" ofType:@"scpt"]] error:nil] autorelease];
    [termScript executeSubroutine:@"doScript" arguments:command error:nil];
}
@end
