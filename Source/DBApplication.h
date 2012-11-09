/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@class DBHotKeyController;
@class DeskBrowseConstants;


@interface DBApplication : NSApplication
{
//	DBHotKeyController*	hotKeyController;
}

- (void) initHotKeyController;
- (void) handleKeyEvent: (NSEvent*) theEvent;
//- (DBHotKeyController*) hotKeyController;
@property (strong, NATOM) DBHotKeyController *hotKeyController;
@end