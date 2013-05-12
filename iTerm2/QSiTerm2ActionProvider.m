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
 Execute text
 
 This method takes objects classified as shell commands and executes
 the commands in a new iTerm terminal window or a new tab in the
 current terminal.
 */
- (QSObject *) executeText:(QSObject *)directObj target:(QSTerminalTarget)target {
    NSString *command = [directObj objectForType:QSShellCommandType];
    
    if (!command) {
        command = [directObj stringValue];
    }
    
    [terminalMediator performCommandInTerminal:command target:target];
    
    return nil;
}

/*
 Execute text in a new terminal
 */
- (QSObject *) executeTextInWindow:(QSObject *)directObj {
    return [self executeText:directObj target:QSTerminalTargetWindow];
}


/*
 Execute text in a new tab in the current terminal
 */
- (QSObject *) executeTextInTab:(QSObject *)directObj {
    return [self executeText:directObj target:QSTerminalTargetTab];
}

/*
 Execute text in the current terminal
 */
- (QSObject *) executeTextInCurrent:(QSObject *)directObj {
    return [self executeText:directObj target:QSTerminalTargetCurrent];
}


/*
 Execute a script
 
 This method runs executable scripts in a new iTerm terminal window. An executable
 script either has +x set or is a shell script beginning with #!.
 
 In the case of a shell script, this method parses the hash bang command to find
 out what binary should be used to execute the script, and calls that binary with
 the script as the argument, just like the hash bang would do.
 */
- (QSObject *) executeScript:(QSObject *)directObj withArguments:(QSObject *)indirectObj target:(QSTerminalTarget)target {
    NSString *script = [directObj singleFilePath];
    NSString *args = [indirectObj stringValue];
    NSString *executable = @"";
    
    BOOL isExecutable = [[NSFileManager defaultManager] isExecutableFileAtPath:script];
    
    if (!isExecutable) {
        
        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:script];
        NSData *buffer;
        NSMutableString *header = [NSMutableString stringWithCapacity:kQSiTerm2UnknownBufSize];
        
        // Read bytes until newline or end of file
        while (true) {
            buffer = [file readDataOfLength:kQSiTerm2UnknownBufSize];
            NSString *temp = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            [header appendString:temp];
            [temp release];
            
            if (buffer.length < kQSiTerm2UnknownBufSize
                || [header rangeOfString:@"\r"].location != NSNotFound
                || [header rangeOfString:@"\n"].location != NSNotFound) {
                break;
            }
        }
        
        // Parse the hash bang
        NSScanner *scanner = [NSScanner scannerWithString:header];
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
    
    [terminalMediator performCommandInTerminal:command target:target];
    
    return nil;
}


/*
 Execute a script in a new terminal
 */
- (QSObject *) executeScriptInWindow:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj target:QSTerminalTargetWindow];
}


/*
 Execute a script in a new terminal tab
 */
- (QSObject *) executeScriptInTab:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj target:QSTerminalTargetTab];
}

/*
 Execute a script in the current terminal
 */
- (QSObject *) executeScriptInCurrent:(QSObject *)directObj withArguments: (QSObject *)indirectObj {
    return [self executeScript:directObj withArguments:indirectObj target:QSTerminalTargetCurrent];
}


/*
 Open directory
 */
- (QSObject *) openDir:(QSObject *)directObj target:(QSTerminalTarget)target {
    NSString *path = [directObj singleFilePath];
    [self openPath:path target:target];
    return nil;
}


/*
 Open directory in a new terminal
 */
- (QSObject *) openDirInWindow:(QSObject *)directObj {
    return [self openDir:directObj target:QSTerminalTargetWindow];
}


/*
 Open directory in a new tab in the current terminal
 */
- (QSObject *) openDirInTab:(QSObject *)directObj {
    return [self openDir:directObj target:QSTerminalTargetTab];
}


/*
 Open directory in a new tab in the current terminal
 */
- (QSObject *) openDirInCurrent:(QSObject *)directObj {
    return [self openDir:directObj target:QSTerminalTargetCurrent];
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParent:(QSObject *)directObj target:(QSTerminalTarget)target {
    NSString *path = [directObj singleFilePath];
    NSArray *comps = [path pathComponents];
    
    if ([comps count] > 1) {
        // Remove the file's name from the path
        path = [NSString pathWithComponents:[comps subarrayWithRange:(NSRange){0, [comps count] - 1}]];
    }
    
    [self openPath:path target:target];
    return nil;
}


/*
 Open an object's parent in a new terminal
 */
- (QSObject *) openParentInWindow:(QSObject *)directObj {
    return [self openParent:directObj target:QSTerminalTargetWindow];
}


/*
 Open an object's parent in a new terminal tab
 */
- (QSObject *) openParentInTab:(QSObject *)directObj {
    return [self openParent:directObj target:QSTerminalTargetTab];
}


/*
 Open an object's parent the current terminal
 */
- (QSObject *) openParentInCurrent:(QSObject *)directObj {
    return [self openParent:directObj target:QSTerminalTargetCurrent];
}


/*
 Utility method for cd:ing to a given path in a new terminal window
 */
- (void) openPath:(NSString *)path target:(QSTerminalTarget)target {
    NSString *command = [NSString stringWithFormat:@"cd %@", [self escapeString:path]];
    [terminalMediator performCommandInTerminal:command target:target];
}


/*
 Open an iTerm session in a window
 */
- (QSObject *) openSessionWindow:(QSObject *)directObj {
    if ([directObj containsType:kQSiTerm2SessionType]) {
        NSString *sessionName = [directObj objectForType:kQSiTerm2SessionType];
        [terminalMediator openSession:sessionName target:QSTerminalTargetWindow];
    }
    return nil;
}


/*
 Open an iTerm session in tab in the current terminal
 */
- (QSObject *) openSessionTab:(QSObject *)directObj {
    if ([directObj containsType:kQSiTerm2SessionType]) {
        NSString *sessionName = [directObj objectForType:kQSiTerm2SessionType];
        [terminalMediator openSession:sessionName target:QSTerminalTargetTab];
    }
    return nil;
}

/*
 Open a new iTerm window
 */
- (QSObject *) openNewWindow:(QSObject *)directObj {
    [terminalMediator openSession:[QSiTerm2Utils defaultSessionName] target:QSTerminalTargetWindow];
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
                    kQSiTerm2OpenDirInWindowAction,
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
                        kQSiTerm2ExecuteScriptInWindowAction,
                        kQSiTerm2ExecuteScriptInTabAction,
                        kQSiTerm2ExecuteScriptInCurrentAction,
                        nil];
            }
        }
        
        return [NSArray arrayWithObjects:
                kQSiTerm2OpenParentInWindowAction,
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
