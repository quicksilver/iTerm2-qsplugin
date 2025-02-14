//
//  QSiTerm2Utils.h
//  iTerm2
//
//  Created by Andreas Johansson on 2013-05-12.
//  Copyright (c) 2013 stdin.se. All rights reserved.
//

#import "QSiTerm2Definitions.h"
#import "iTerm.h"

@interface QSiTerm2Utils : NSObject

+ (NSString *) defaultSessionName;
+ (NSArray *) sessions;

@end
