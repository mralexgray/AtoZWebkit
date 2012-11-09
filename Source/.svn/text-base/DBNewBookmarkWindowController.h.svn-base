/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>


@class DBBookmark;
@class DBBookmarkController;

@interface DBNewBookmarkWindowController : NSWindowController
{
	IBOutlet NSTextField*	mTitleField;
	
	DBBookmarkController*		mBookmarkController;
	NSURL*					mBookmarkURL;
	NSString*				mBookmarkTitle;
}

- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController title: (NSString*) bookmarkTitle url: (NSURL*) bookmarkURL;

- (void) runSheetOnWindow: (NSWindow*) window;

- (IBAction) ok: (id) sender;
- (IBAction) cancel: (id) sender;

@end