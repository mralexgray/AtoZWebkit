/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

@class DBBookmark;
@class DBBookmarkController;
@class DBBookmarkBarPopUpButton;

@interface DBBookmarkBar : NSView

@property (STRNG, NATOM) DBBookmarkController		*bookmarkController;
@property (STRNG, NATOM) DBBookmarkBarPopUpButton	*extraBookmarksPopUpButton;
@property (STRNG, NATOM) NSC  *bookmarksBGC;
@property (STRNG, NATOM) NSMA *bookmarkCells;
@property (NATOM)		 BOOL  dragging;
@property (NATOM)	     CGF   lastMouseX;
@property (NATOM)	 	 NSR   lastFrame;

@property (NATOM)	     CGF   bookmarkPadding;

//- (void) setBookmarkController: (DBBookmarkController*) bookmarkController;
- (void) reloadData;
- (void) setVisiblePosition: (NSP) position;
- (NSA*) menuItemsForPopUpButton: (NSPopUpButton*) popUpButton;

@end