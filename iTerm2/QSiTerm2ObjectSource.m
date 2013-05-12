//
//  QSiTerm2ObjectSource.m
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-27.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2ObjectSource.h"

@implementation QSiTerm2ObjectSource


/*
 QS method that loads the children when right arrowing into an object
 
 Parses the sessions from iTerm2's settings and sets them as children to the iTerm app.
 */
- (BOOL) loadChildrenForObject:(QSObject *)object {
    
    if ([[object primaryType] isEqualToString:NSFilenamesPboardType]) {
        
        NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[kQSiTerm2SettingsFile stringByStandardizingPath]];
        
        NSEnumerator *sessionEnum = [[dict objectForKey:kQSiTerm2SessionSettingsKey] objectEnumerator];
        NSDictionary *session;
        QSObject *sessionObj;
        
        id icon = [QSResourceManager imageNamed:kQSiTerm2Bundle];
        
        // Generate a child object for each of the sessions
        while (session = [sessionEnum nextObject]) {
            NSString *sessionName = [session objectForKey:@"Name"];
            
            sessionObj = [QSObject objectWithName:sessionName];
            
            [sessionObj setDetails:@"iTerm Session"];
            [sessionObj setPrimaryType:kQSiTerm2SessionType];
            [sessionObj setObject:sessionName forType:kQSiTerm2SessionType];
            [sessionObj setIcon:icon];
            
            [children addObject:sessionObj];
        }

        [object setChildren:children];
        return YES;
    }
    
    return NO;
}


@end
