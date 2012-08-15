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
#define kQSiTerm2ExecuteScriptAction @"QSiTerm2ExecuteScript"
#define kQSiTerm2OpenDirAction @"QSiTerm2OpenDir"
#define kQSiTerm2OpenParentAction @"QSiTerm2OpenParent"
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
#define kQSiTerm2SettingsFile @"~/Library/Preferences/com.googlecode.iterm2.plist"
#define kQSiTerm2SessionSettingsKey @"New Bookmarks" // Sessions are stored under this key...

// The session to use unless otherwise specified
#define kQSiTerm2StandardSession @"Default"

// Bytes read in unknown files
#define kQSiTerm2UnknownBufSize 5

