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


/*
 Execute text in a new terminal
 */
- (QSObject *) executeText:(QSObject *)directObj {
    return [self executeText:directObj inTab:NO inCurrent:NO];
}


/*
 Execute text in a new tab in the current terminal
 */
- (QSObject *) executeTextInTab:(QSObject *)directObj {
    return [self executeText:directObj inTab:YES inCurrent:NO];
}

/*
 Execute text in the current terminal
 */
- (QSObject *) executeTextInCurrent:(QSObject *)directObj {
    return [self executeText:directObj inTab:NO inCurrent:YES];
}


/*
 Execute text
 
 This method takes objects classified as shell commands and executes
 the commands in a new iTerm terminal window or a new tab in the
 current terminal.
 */
- (QSObject *) executeText:(QSObject *)directObj inTab:(BOOL)inTab inCurrent:(BOOL)inCurrent {
    NSString *command = [directObj objectForType:QSShellCommandType];
    
    if (!command) {
        command = [directObj stringValue];
    }
    
    if (inTab) {
        [terminalMediator performCommandInTerminalTab:command];
    } else if (inCurrent) {
        [terminalMediator performCommandInCurrentTerminal:command];
    } else {
        [terminalMediator performCommandInTerminal:command];
    }
    
    return nil;
}


/*
 Execute a script in a new terminal
 */
- (QSObject *) executeScript:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj inTab:NO inCurrent:NO];
}


/*
 Execute a script in a new terminal
 */
- (QSObject *) executeScriptInTab:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj inTab:YES inCurrent:NO];
}

/*
 Execute a script in the current terminal
 */
- (QSObject *) executeScriptInCurrent:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj inTab:NO inCurrent:YES];
}


/*
 Execute a script
 
 This method runs executable scripts in a new iTerm terminal window. An executable
 script either has +x set or is a shell script beginning with #!.
 
 In the case of a shell script, this method parses the hash bang command to find
 out what binary should be used to execute the script, and calls that binary with
 the script as the argument, just like the hash bang would do.
 */
- (QSObject *) executeScript:(QSObject *)directObj withArguments: (QSObject *)indirectObj inTab:(BOOL)inTab inCurrent:(BOOL)inCurrent {
    NSString *script = [directObj singleFilePath];
    NSString *args = [indirectObj stringValue];
    NSString *executable = @"";
    
    BOOL isExecutable = [[NSFileManager defaultManager] isExecutableFileAtPath:script];
    
    if (!isExecutable) {
        // Parse the hash bang
        NSString *contents = [NSString stringWithContentsOfFile:script encoding:NSUTF8StringEncoding error:nil];
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
    
    if (inTab) {
        [terminalMediator performCommandInTerminalTab:command];
    } else if (inCurrent) {
        [terminalMediator performCommandInCurrentTerminal:command];
    } else {
        [terminalMediator performCommandInTerminal:command];
    }
    
    return nil;
}


/*
 Open directory in a new terminal
 */
- (QSObject *) openDir:(QSObject *)directObj {
    return [self openDir:directObj inTab:NO inCurrent:NO];
}


/*
 Open directory in a new tab in the current terminal
 */
- (QSObject *) openDirInTab:(QSObject *)directObj {
    return [self openDir:directObj inTab:YES inCurrent:NO];
}


/*
 Open directory in a new tab in the current terminal
 */
- (QSObject *) openDirInCurrent:(QSObject *)directObj {
    return [self openDir:directObj inTab:NO inCurrent:YES];
}


/*
 Open directory
 */
- (QSObject *) openDir:(QSObject *)directObj inTab:(BOOL)inTab inCurrent:(BOOL)inCurrent {
    NSString *path = [directObj singleFilePath];
    [self openPath:path inTab:inTab inCurrent:(BOOL)inCurrent];
    return nil;
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParent:(QSObject *)directObj {
    return [self openParent:directObj inTab:NO inCurrent:NO];
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParentInTab:(QSObject *)directObj {
    return [self openParent:directObj inTab:YES inCurrent:NO];
}


/*
 Open an object's parent the current terminal
 */
- (QSObject *) openParentInCurrent:(QSObject *)directObj {
    return [self openParent:directObj inTab:NO inCurrent:YES];
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParent:(QSObject *)directObj inTab:(BOOL)inTab inCurrent:(BOOL)inCurrent {
    NSString *path = [directObj singleFilePath];
    NSArray *comps = [path pathComponents];

    if ([comps count] > 1) {
        // Remove the file's name from the path
        path = [NSString pathWithComponents:[comps subarrayWithRange:(NSRange){0, [comps count] - 1}]];
    }

    [self openPath:path inTab:inTab inCurrent:inCurrent];
    return nil;
}


/*
 Utility method for cd:ing to a given path in a new terminal window
 */
- (void) openPath:(NSString *)path inTab:(BOOL)inTab inCurrent:(BOOL)inCurrent {
    NSString *command = [NSString stringWithFormat:@"cd %@", [self escapeString:path]];
    
    if (inTab) {
        [terminalMediator performCommandInTerminalTab:command]; 
    } else if (inCurrent) {
        [terminalMediator performCommandInCurrentTerminal:command];
    } else {
        [terminalMediator performCommandInTerminal:command];
    }
}


/*
 Open an iTerm session in a window
 */
- (QSObject *) openSessionWindow:(QSObject *)directObj {
    if ([directObj containsType:kQSiTerm2SessionType]) {
        NSString *sessionName = [directObj objectForType:kQSiTerm2SessionType];
        [terminalMediator openSession:sessionName inTab:NO];
    }
    return nil;
}


/*
 Open an iTerm session in tab in the current terminal
 */
- (QSObject *) openSessionTab:(QSObject *)directObj {
    if ([directObj containsType:kQSiTerm2SessionType]) {
        NSString *sessionName = [directObj objectForType:kQSiTerm2SessionType];
        [terminalMediator openSession:sessionName inTab:YES];
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
            return [NSArray arrayWithObjects:
                    kQSiTerm2OpenDirAction,
                    kQSiTerm2OpenDirInTabAction,
                    kQSiTerm2OpenDirInCurrentAction,
                    nil];
        }
        
        if ([QSShellScriptTypes containsObject:[[NSFileManager defaultManager] typeOfFile:path]]) {
            BOOL executable = [[NSFileManager defaultManager] isExecutableFileAtPath:path];
            
            if (!executable) {
                NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
                NSData *buffer = [file readDataOfLength:kQSiTerm2UnknownBufSize];
                NSString *header = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
                if ([header hasPrefix:@"#!"]) {
                    executable = YES;
                }
                [header release];
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
                        kQSiTerm2ExecuteScriptInTabAction,
                        kQSiTerm2ExecuteScriptInCurrentAction,
                        nil];
            }
        }
        
        return [NSArray arrayWithObjects:
                kQSiTerm2OpenParentAction,
                kQSiTerm2OpenParentInTabAction,
                kQSiTerm2OpenParentInCurrentAction,
                nil];
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
    
    NSUInteger i;
    for (i = 0; i < [escapeString length]; i++){
        NSString *thisString = [escapeString substringWithRange:NSMakeRange(i,1)];
        string = [[string componentsSeparatedByString:thisString] componentsJoinedByString:[@"\\" stringByAppendingString:thisString]];
        
    }
    return string;
}


@end
