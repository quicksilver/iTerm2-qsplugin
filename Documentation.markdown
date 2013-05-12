## Quicksilver iTerm2 plugin ##

This plugin provides functionality for having commands from the [Terminal
plugin](http://github.com/quicksilver/Terminal-qsplugin) work in
[iTerm2](http://www.iterm2.com/). It does so by registering iTerm2 as a
Command line interface.

When the iTerm2 plugin is installed, iTerm2 becomes available as a choice under
Command Line Interface in the Handlers section of the Quicksilver preferences.

In addition, this plugin provides iTerm2-specific functionality.

This plugin contains adapted code from the [Terminal
plugin](http://github.com/quicksilver/Terminal-qsplugin).

### Types ###

* **iTerm Session** - A representation of an iTerm session. Access all sessions by right-arrowing into iTerm2.

### Actions ###

This plugin supplies the following actions:

 * **Open New Window** - Opens a new iTerm window. This action is available
   directly on the iTerm2 application in QS.

 * **Run a Text Command in iTerm** - Runs a text command entered in Quicksilver's text mode in iTerm.

    The action opens a new terminal. The alternate action is **Run a Text
    Command in iTerm Tab**.

 * **Run a Text Command in iTerm Tab** - Runs a text command entered in Quicksilver's text mode in iTerm.

    The action opens a new tab in the current terminal. The alternate action is
    **Run a Text Command in iTerm**.

    Disabled by default.

 * **Run a Text Command in Current iTerm** - Runs a text command entered in Quicksilver's text mode in iTerm.

    The action runs the command in the frontmost tab in the frontmost iTerm window.

    Disabled by default.

 * **Run in iTerm [...]** - Runs the selected shell script/binary in iTerm.

    The target either has to be an executable or a shell script with a #!
    declaration.

    The action opens a new terminal. The alternate action is **Run in iTerm Tab
    [...]**.

 * **Run in iTerm Tab [...]** - Runs the selected shell script/binary in iTerm.

    The target either has to be an executable or a shell script with a #!
    declaration.

    The action opens a new tab in the current terminal. The alternate action is
    **Run in iTerm [...]**.

    Disabled by default.

 * **Run in Current iTerm [...]** - Runs the selected shell script/binary in iTerm.

    The target either has to be an executable or a shell script with a #!
    declaration.

    The action runs the command in the frontmost tab in the frontmost iTerm window.

    Disabled by default.

 * **Open Parent Directory in iTerm** - Opens the selected directory's parent in iTerm.

    This action is only provided for targets that are neither directories nor
    runnables (Terminal plugin compatibility).

    The action opens a new terminal. The alternate action is **Open Parent
    Directory in iTerm Tab**.

 * **Open Parent Directory in iTerm tab** - Opens the selected directory's parent in iTerm.

    This action is only provided for targets that are neither directories nor
    runnables (Terminal plugin compatibility).

    The action opens a new tab in the current terminal. The alternate action is
    **Open Parent Directory in iTerm**.

    Disabled by default.

 * **Open Parent Directory in Current iTerm** - Opens the selected directory's parent in iTerm.

    This action is only provided for targets that are neither directories nor
    runnables (Terminal plugin compatibility).

    The action opens the directory in the frontmost tab in the frontmost iTerm window.

    Disabled by default.

 * **Open Directory in iTerm** - Opens the selected directory in iTerm.

    The action opens a new terminal. The alternate action is **Open Directory
    in iTerm Tab**.

 * **Open Directory in iTerm Tab** - Opens the selected directory in a new tab in iTerm.

    The action opens a new tab in the current terminal. The alternate action is
    **Open Directory in iTerm**.

 * **Open Directory in Current iTerm** - Opens the selected directory's parent in iTerm.

    The action opens the directory in the frontmost tab in the frontmost iTerm window.

    Disabled by default.


When configured as the Command Line Interface for Quicksilver, this plugin also
supports the following actions:

 * **Run a Text Command in Terminal** - Runs a text command entered in Quicksilver's text mode in the terminal.
 * **Run in Terminal [...]** - Runs the selected shell script/binary in the terminal.
 * **Open Parent Directory in Terminal** - Opens the selected directory's parent in the terminal.
 * **Open Directory in Terminal** - Opens the selected directory in the terminal.

The following actions are available for iTerm sessions:

 * **Open in New Window** - Opens a new terminal window with the selected session
 * **Open in New Tab** - Opens a new tab with the selected session in the current terminal

