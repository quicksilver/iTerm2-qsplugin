//
//  QSiTerm2Utils.m
//  iTerm2
//
//  Created by Andreas Johansson on 2013-05-12.
//  Copyright (c) 2013 stdin.se. All rights reserved.
//

#import "QSiTerm2Utils.h"

@implementation QSiTerm2Utils

/*
 The name of the default session in iTerm2
 */
+ (NSString *) defaultSessionName {
    NSDictionary *iTermPreferences = [[[NSUserDefaults alloc] init] persistentDomainForName:kQSiTerm2Bundle];
    
    NSString *defaultGuid = [iTermPreferences objectForKey:@"Default Bookmark Guid"];
    NSArray *sessions = [iTermPreferences objectForKey:@"New Bookmarks"];
    
    NSString *sessionName = nil;
    
    if (defaultGuid && sessions) {
        for (NSDictionary *session in sessions) {
            NSString *guid = [session objectForKey:@"Guid"];
            
            if ([guid isEqualToString:defaultGuid]) {
                sessionName = [session objectForKey:@"Name"];
                break;
            }
        }
    }
    
    if (!sessionName) {
        sessionName = kQSiTerm2FallbackSession;
    }
    
    return sessionName;
}

/*
 All sessions in iTerm2 as an array of strings
 */
+ (NSArray *) sessions {
	iTermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
	NSArray *windows = app.windows;
	NSMutableArray *sessionObjects = [NSMutableArray arrayWithCapacity:1];

	for (iTermWindow *window in windows) {
		NSArray *tabs = window.tabs;
		for (iTermTab *tab in tabs) {
			NSArray *sessions = tab.sessions;
			for (iTermSession *session in sessions) {
				[sessionObjects addObject:[session name]];
			}
		}
	}
	return sessionObjects;
}

@end
