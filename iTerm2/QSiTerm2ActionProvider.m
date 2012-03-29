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


/**
 Execute text in a new terminal
 
 This method takes objects classified as shell commands and executes
 the commands in a new iTerm terminal window.
 */
- (QSObject *) executeText:(QSObject *)directObj {
    NSString *command = [directObj objectForType:QSShellCommandType];

    if (!command) {
        command = [directObj stringValue];
    }

    [terminalMediator performCommandInTerminal:command];

    return nil;
}


/*
 Execute a script in a new terminal
 
 This method runs executable scripts in a new iTerm terminal window. An executable
 script either has +x set or is a shell script beginning with #!.
 
 In the case of a shell script, this method parses the hash bang command to find
 out what binary should be used to execute the script, and calls that binary with
 the script as the argument, just like the hash bang would do.
 */
- (QSObject *) executeScript:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    NSString *script = [directObj singleFilePath];
    NSString *args = [indirectObj stringValue];
    NSString *executable = @"";
    
    BOOL isExecutable = [[NSFileManager defaultManager] isExecutableFileAtPath:script];
    
    if (!isExecutable) {
        // Parse the hash bang
        NSString *contents = [NSString stringWithContentsOfFile:script];
        NSScanner *scanner = [NSScanner scannerWithString:contents];
        [scanner scanString:@"#!" intoString:nil];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"] intoString:&executable];
    }
    
    NSString *command = @"";
    
    if (!isExecutable) {
        // Use the parsed hash bang executable
        command = [command stringByAppendingString:[NSString stringWithFormat:@"%@ ", executable]];
    }
    
    command = [command stringByAppendingString:[self escapeString:script]];
    
    if ([args length]) {
        command = [command stringByAppendingString:[NSString stringWithFormat:@" %@", args]];
    }
    
    [terminalMediator performCommandInTerminal:command];
    
    return nil;
}


/*
 Open directory in a new terminal
 */
- (QSObject *) openDir:(QSObject *)directObj {
    NSString *path = [directObj singleFilePath];
    [self openPath:path];
    return nil;
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParent:(QSObject *)directObj {
    NSString *path = [directObj singleFilePath];
    NSArray *comps = [path pathComponents];

    if ([comps count] > 1) {
        // Remove the file's name from the path
        path = [NSString pathWithComponents:[comps subarrayWithRange:(NSRange){0, [comps count] - 1}]];
    }

    [self openPath:path];
    return nil;
}


/*
 Utility method for cd:ing to a given path in a new terminal window
 */
- (void) openPath:(NSString *)path {
    NSString *command = [NSString stringWithFormat:@"cd %@", [self escapeString:path]];
    [terminalMediator performCommandInTerminal:command];
}


/*
 Open an iTerm session in a window
 */
- (QSObject *) openSessionWindow:(QSObject *)directObj {
    if ([directObj containsType:kQSiTerm2SessionType]) {
        NSString *sessionName = [directObj objectForType:kQSiTerm2SessionType];
        [terminalMediator openSession:sessionName];
    }
    return nil;
}


/*
 Checks if the object is a valid target for our commands.
 */
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


/*
 Required for enabling the executeScript action.
 */
- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)directObj {
    QSObject *proxy = [QSObject textProxyObjectWithDefaultValue:@""];
    return [NSArray arrayWithObject:proxy];
}


/*
 Escapes all special characters in a string before usage in a shell
 */
- (NSString *) escapeString:(NSString *)string {
    NSString *escapeString = QSShellEscape;
    
    int i;
    for (i = 0; i < [escapeString length]; i++){
        NSString *thisString = [escapeString substringWithRange:NSMakeRange(i,1)];
        string = [[string componentsSeparatedByString:thisString] componentsJoinedByString:[@"\\" stringByAppendingString:thisString]];
        
    }
    return string;
}


@end
