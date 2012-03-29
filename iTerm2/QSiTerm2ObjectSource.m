//
//  QSiTerm2ObjectSource.m
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-27.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2ObjectSource.h"

@implementation QSiTerm2ObjectSource


- (BOOL) loadChildrenForObject:(QSObject *)object {
    
    if ([[object primaryType] isEqualToString:NSFilenamesPboardType]) {
        
        NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[kQSiTerm2SettingsFile stringByStandardizingPath]];
        
        NSEnumerator *sessionEnum = [[dict objectForKey:kQSiTerm2SessionSettingsKey] objectEnumerator];
        NSDictionary *session;
        QSObject *sessionObj;
        
        id icon = [QSResourceManager imageNamed:kQSiTerm2Bundle];
        
        while (session = [sessionEnum nextObject]) {
            NSString *sessionName = [session objectForKey:@"Name"];
            
            sessionObj = [QSObject objectWithName:sessionName];
            
            [sessionObj setDetails:[NSString stringWithFormat:@"iTerm Session", sessionName]];
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
