/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

extern NSS	*DBBookmarkCellPboardType;
extern CGF	 DBBookmarkCellMaximumWidth;
extern CGF	 DBPaddingOnSidesOfTextFrame;

@protocol DBBookmarkBarCell

- (void) setFrame: (NSR) frame;
- (NSR) frame;
- (void) setStringValue: (NSS*) stringValue;

- (void) setMenu: (NSMenu*) menu;
- (void) mouseDown: (NSEvent*) event;
- (void) mouseUp: 	(NSEvent*) event;

- (void) drawWithFrame: (NSR) frameRect inView: (NSView*) controlView;

- (NSImage*) dragImage;
- (NSMenuItem*) menuItem;

- (void) resetTrackingRect;

@end