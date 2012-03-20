//
//  QSiTerm2TerminalMediator.h
//  QSiTerm2
//
//  Created by Andreas Johansson on 2012-03-20.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol QSTerminalMediator
- (void) performCommandInTerminal: (NSString *)command;
@end

@interface QSiTerm2TerminalMediator : NSObject <QSTerminalMediator>
@end
