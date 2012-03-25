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

### Actions ###

This plugin supplies the following actions:

 * Run a Text Command in iTerm - Runs a text command entered in Quicksilver's text mode in iTerm

 * Run in iTerm [...] - Runs the selected shell script/binary in iTerm.

     The target either has to be an executable or a shell script with a #! declaration.

 * Open Parent Directory in iTerm - Opens the selected directory's parent in iTerm.

     This action is only provided for targets that are neither directories nor
     runnables (Terminal plugin compatibility).

 * Open Directory in iTerm - Opens the selected directory in iTerm.

When configured as the Command Line Interface for Quicksilver, this plugin also
supports the following actions:

 * Run a Text Command in Terminal - Runs a text command entered in Quicksilver's text mode in the terminal.
 * Run in Terminal [...] - Runs the selected shell script/binary in the terminal.
 * Open Parent Directory in Terminal - Opens the selected directory's parent in the terminal.
 * Open Directory in Terminal - Opens the selected directory in the terminal.
