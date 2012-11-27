/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

//@class DBHotKeyController
@class  DeskBrowseConstants;
@interface DBApplication : NSApplication
- (void) initHotKeyController;
- (void) handleKeyEvent: (NSEvent*) theEvent;
//@property (strong, NATOM) DBHotKeyController *hotKeyController;
@end