//
//  QSiTerm2Definitions.h
//  iTerm2
//
//  Created by Andreas Johansson on 2012-03-29.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

// Special shell characters
#define QSShellEscape @"\\!$&\"'*(){[|;<>?~` "

// File types classified as scripts
#define QSShellScriptTypes [NSArray arrayWithObjects: @"sh", @"pl", @"command", @"php", @"py", @"'TEXT'", @"rb", @"", nil]

// Action constants, matches those in Info.plist
#define kQSiTerm2ExecuteScriptInWindowAction @"QSiTerm2ExecuteScriptInWindow"
#define kQSiTerm2OpenDirInWindowAction @"QSiTerm2OpenDirInWindow"
#define kQSiTerm2OpenParentInWindowAction @"QSiTerm2OpenParentInWindow"

#define kQSiTerm2ExecuteScriptInTabAction @"QSiTerm2ExecuteScriptInTab"
#define kQSiTerm2OpenDirInTabAction @"QSiTerm2OpenDirInTab"
#define kQSiTerm2OpenParentInTabAction @"QSiTerm2OpenParentInTab"

#define kQSiTerm2ExecuteScriptInCurrentAction @"QSiTerm2ExecuteScriptInCurrent"
#define kQSiTerm2OpenDirInCurrentAction @"QSiTerm2OpenDirInCurrent"
#define kQSiTerm2OpenParentInCurrentAction @"QSiTerm2OpenParentInCurrent"

// The type for the iTerm2 session QS objects
#define kQSiTerm2SessionType @"com.googlecode.iterm2.session"

// iTerm2 settings
#define kQSiTerm2Bundle @"com.googlecode.iterm2"

// The session name to use when no default session can be found
#define kQSiTerm2FallbackSession @"Default"

// Bytes read in unknown files
#define kQSiTerm2UnknownBufSize 5

// Target enum
typedef enum {
    QSTerminalTargetCurrent,
    QSTerminalTargetWindow,
    QSTerminalTargetTab
} QSTerminalTarget;