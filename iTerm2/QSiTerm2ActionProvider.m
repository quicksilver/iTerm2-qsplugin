//
//  QSiTerm2ActionProvider.m
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-24.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm2ActionProvider.h"

#define QSShellScriptTypes [NSArray arrayWithObjects: @"sh", @"pl", @"command", @"php", @"py", @"'TEXT'", @"rb", @"", nil]

#define kQSiTerm2ExecuteScriptAction @"QSiTerm2ExecuteScript"
#define kQSiTerm2OpenDirAction @"QSiTerm2OpenDir"
#define kQSiTerm2OpenParentAction @"QSiTerm2OpenParent"

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
    NSString *command = [directObj objectForType:QSShellCommandType];
    
    if (!command) {
        command = [directObj stringValue];
    }
    
    [terminalMediator performCommandInTerminal:command];
    
    return nil;
}

- (QSObject *) executeScript:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    NSString *script = [directObj singleFilePath];
    NSString *args = [indirectObj stringValue];
    NSString *executable = @"";
    
    BOOL isExecutable = [[NSFileManager defaultManager] isExecutableFileAtPath:script];
    
    if (!isExecutable){
        NSString *contents = [NSString stringWithContentsOfFile:script];
        NSScanner *scanner = [NSScanner scannerWithString:contents];
        [scanner scanString:@"#!" intoString:nil];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"] intoString:&executable];
    }
    
    NSString *command = @"";
    
    if (!isExecutable) {
        command = [command stringByAppendingString:[NSString stringWithFormat:@"%@ ", executable]];
    }
    
    command = [command stringByAppendingString:[self escapeString:script]];
    
    if ([args length]) {
        command = [command stringByAppendingString:[NSString stringWithFormat:@" %@", args]];
    }
    
    [terminalMediator performCommandInTerminal:command];
    
    return nil;
}


- (QSObject *) openDir:(QSObject *)directObj {
    NSString *path = [directObj singleFilePath];
    [self openPath:path];
    return nil;
}


- (QSObject *) openParent:(QSObject *)directObj {
    NSString *path = [directObj singleFilePath];
    NSArray *comps = [path pathComponents];

    if ([comps count] > 1) {
        path = [NSString pathWithComponents:[comps subarrayWithRange:(NSRange){0, [comps count] - 1}]];
    }

    [self openPath:path];
    return nil;
}


- (void) openPath:(NSString *)path {
    NSString *command = [NSString stringWithFormat:@"cd %@", [self escapeString:path]];
    [terminalMediator performCommandInTerminal:command];
}


- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj {
    if ([directObj objectForType:NSFilenamesPboardType])  {
        NSString *path = [directObj singleFilePath];

        if (!path) {
            return nil;
        }
        
        BOOL isDirectory = NO;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
            return nil;
        }
        if (isDirectory) {
            return [NSArray arrayWithObject:kQSiTerm2OpenDirAction];
        }
        
        if ([QSShellScriptTypes containsObject:[[NSFileManager defaultManager] typeOfFile:path]]) {
            BOOL executable = [[NSFileManager defaultManager] isExecutableFileAtPath:path];
            
            if (!executable) {
                NSString *contents = [NSString stringWithContentsOfFile:path];
                if ([contents hasPrefix:@"#!"]) {
                    executable = YES;
                }            
            } else {
                LSItemInfoRecord infoRec;
                LSCopyItemInfoForURL((CFURLRef)[NSURL fileURLWithPath:path], kLSRequestBasicFlagsOnly, &infoRec);
                
                if (infoRec.flags & kLSItemInfoIsApplication) {
                    // Ignore applications
                    executable = NO;
                }
            }
            
            if (executable){
                return [NSArray arrayWithObjects:
                        kQSiTerm2ExecuteScriptAction,
                        nil];
            }
        }
        
        return [NSArray arrayWithObject:kQSiTerm2OpenParentAction];
    }
    
    return nil;
}


- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)directObj {
    QSObject *proxy = [QSObject textProxyObjectWithDefaultValue:@""];
    return [NSArray arrayWithObject:proxy];
}


- (NSString *) escapeString:(NSString *)string {
    NSString *escapeString = @"\\!$&\"'*(){[|;<>?~` ";
    
    int i;
    for (i = 0; i < [escapeString length]; i++){
        NSString *thisString = [escapeString substringWithRange:NSMakeRange(i,1)];
        string = [[string componentsSeparatedByString:thisString] componentsJoinedByString:[@"\\" stringByAppendingString:thisString]];
        
    }
    return string;
}


@end
