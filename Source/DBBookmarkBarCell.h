/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>


extern NSString*	DBBookmarkCellPboardType;
extern CGFloat		DBBookmarkCellMaximumWidth;
extern CGFloat		DBPaddingOnSidesOfTextFrame;

@protocol DBBookmarkBarCell

- (void) setFrame: (NSR) frame;
- (NSR) frame;

- (void) setStringValue: (NSString*) stringValue;
- (void) setMenu: (NSMenu*) menu;

- (void) mouseDown: (NSEvent*) event;
- (void) mouseUp: (NSEvent*) event;

- (void) drawWithFrame: (NSR) frameRect inView: (NSView*) controlView;

- (NSImage*) dragImage;
- (NSMenuItem*) menuItem;

- (void) resetTrackingRect;

@end