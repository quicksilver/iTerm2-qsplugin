/*
 * iTerm.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class iTermApplication, iTermWindow, iTermTab, iTermSession;

enum iTermSaveOptions {
	iTermSaveOptionsYes = 'yes ' /* Save the file. */,
	iTermSaveOptionsNo = 'no  ' /* Do not save the file. */,
	iTermSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum iTermSaveOptions iTermSaveOptions;

@protocol iTermGenericMethods

- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (BOOL) exists;  // Verify if an object exists.
- (void) moveTo:(SBObject *)to;  // Move object(s) to a new location.
- (void) close;  // Close a document.
- (iTermTab *) createTabWithProfile:(NSString *)withProfile command:(NSString *)command;  // Create a new tab
- (iTermTab *) createTabWithDefaultProfileCommand:(NSString *)command;  // Create a new tab with the default profile
- (void) writeContentsOfFile:(NSURL *)contentsOfFile text:(NSString *)text newline:(BOOL)newline;  // Send text as though it was typed.
- (void) select;  // Make receiver visible and selected.
- (iTermSession *) splitVerticallyWithProfile:(NSString *)withProfile command:(NSString *)command;  // Split a session vertically.
- (iTermSession *) splitVerticallyWithDefaultProfileCommand:(NSString *)command;  // Split a session vertically, using the default profile for the new session
- (iTermSession *) splitVerticallyWithSameProfileCommand:(NSString *)command;  // Split a session vertically, using the original session's profile for the new session
- (iTermSession *) splitHorizontallyWithProfile:(NSString *)withProfile command:(NSString *)command;  // Split a session horizontally.
- (iTermSession *) splitHorizontallyWithDefaultProfileCommand:(NSString *)command;  // Split a session horizontally, using the default profile for the new session
- (iTermSession *) splitHorizontallyWithSameProfileCommand:(NSString *)command;  // Split a session horizontally, using the original session's profile for the new session
- (NSString *) variableNamed:(NSString *)named;  // Returns the value of a session variable with the given name
- (NSString *) setVariableNamed:(NSString *)named to:(NSString *)to;  // Sets the value of a session variable
- (void) revealHotkeyWindow;  // Reveals a hotkey window. Only to be called on windows that are hotkey windows.
- (void) hideHotkeyWindow;  // Hides a hotkey window. Only to be called on windows that are hotkey windows.
- (void) toggleHotkeyWindow;  // Toggles the visibility of a hotkey window. Only to be called on windows that are hotkey windows.

@end



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface iTermApplication : SBApplication

- (SBElementArray<iTermWindow *> *) windows;

@property (copy) iTermWindow *currentWindow;  // The frontmost window
@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (NSString *) requestCookieAndKeyForAppNamed:(NSString *)andKeyForAppNamed;  // Request a Python API cookie
- (iTermWindow *) createWindowWithProfile:(NSString *)x command:(NSString *)command;  // Create a new window
- (iTermWindow *) createHotkeyWindowWithProfile:(NSString *)x;  // Create a hotkey window
- (void) launchAPIScriptNamed:(NSString *)x arguments:(NSArray<NSString *> *)arguments;  // Launch API script by name
- (NSString *) invokeAPIExpression:(NSString *)x;  // Invokes an expression, such as a registered function.
- (iTermWindow *) createWindowWithDefaultProfileCommand:(NSString *)command;  // Create a new window with the default profile

@end

// A window.
@interface iTermWindow : SBObject <iTermGenericMethods>

- (SBElementArray<iTermTab *> *) tabs;

- (NSInteger) id;  // The unique identifier of the session.
@property (copy, readonly) NSString *alternateIdentifier;  // The alternate unique identifier of the session.
@property (copy, readonly) NSString *name;  // The full title of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Whether the window has a close box.
@property (readonly) BOOL miniaturizable;  // Whether the window can be minimized.
@property BOOL miniaturized;  // Whether the window is currently minimized.
@property (readonly) BOOL resizable;  // Whether the window can be resized.
@property BOOL visible;  // Whether the window is currently visible.
@property (readonly) BOOL zoomable;  // Whether the window can be zoomed.
@property BOOL zoomed;  // Whether the window is currently zoomed.
@property BOOL frontmost;  // Whether the window is currently the frontmost window.
@property (copy) iTermTab *currentTab;  // The currently selected tab
@property (copy) iTermSession *currentSession;  // The current session in a window
@property BOOL isHotkeyWindow;  // Whether the window is a hotkey window.
@property (copy) NSString *hotkeyWindowProfile;  // If the window is a hotkey window, this gives the name of the profile that created the window. 
@property NSPoint position;  // The position of the window, relative to the upper left corner of the screen.
@property NSPoint origin;  // The position of the window, relative to the lower left corner of the screen.
@property NSPoint size;  // The width and height of the window
@property NSRect frame;  // The bounding rectangle, relative to the lower left corner of the screen.


@end



/*
 * iTerm2 Suite
 */

// A terminal tab
@interface iTermTab : SBObject <iTermGenericMethods>

- (SBElementArray<iTermSession *> *) sessions;

@property (copy) iTermSession *currentSession;  // The current session in a tab
@property NSInteger index;  // Index of tab in parent tab view control


@end

// A terminal session
@interface iTermSession : SBObject <iTermGenericMethods>

- (NSString *) id;  // The unique identifier of the session.
@property BOOL isProcessing;  // The session has received output recently.
@property BOOL isAtShellPrompt;  // The terminal is at the shell prompt. Requires shell integration.
@property NSInteger columns;
@property NSInteger rows;
@property (copy, readonly) NSString *tty;
@property (copy) NSString *contents;  // The currently visible contents of the session.
@property (copy, readonly) NSString *text;  // The currently visible contents of the session.
@property (copy) NSString *colorPreset;
@property (copy) NSColor *backgroundColor;
@property (copy) NSColor *boldColor;
@property (copy) NSColor *cursorColor;
@property (copy) NSColor *cursorTextColor;
@property (copy) NSColor *foregroundColor;
@property (copy) NSColor *selectedTextColor;
@property (copy) NSColor *selectionColor;
@property (copy) NSColor *ANSIBlackColor;
@property (copy) NSColor *ANSIRedColor;
@property (copy) NSColor *ANSIGreenColor;
@property (copy) NSColor *ANSIYellowColor;
@property (copy) NSColor *ANSIBlueColor;
@property (copy) NSColor *ANSIMagentaColor;
@property (copy) NSColor *ANSICyanColor;
@property (copy) NSColor *ANSIWhiteColor;
@property (copy) NSColor *ANSIBrightBlackColor;
@property (copy) NSColor *ANSIBrightRedColor;
@property (copy) NSColor *ANSIBrightGreenColor;
@property (copy) NSColor *ANSIBrightYellowColor;
@property (copy) NSColor *ANSIBrightBlueColor;
@property (copy) NSColor *ANSIBrightMagentaColor;
@property (copy) NSColor *ANSIBrightCyanColor;
@property (copy) NSColor *ANSIBrightWhiteColor;
@property (copy) NSColor *underlineColor;
@property BOOL useUnderlineColor;  // Whether the use a dedicated color for underlining.
@property (copy) NSString *backgroundImage;
@property (copy) NSString *name;
@property double transparency;
@property (copy, readonly) NSString *uniqueID;
@property (copy, readonly) NSString *profileName;  // The session's profile name
@property (copy) NSString *answerbackString;  // ENQ Answerback string


@end

