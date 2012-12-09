/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBNewBookmarkWindowController.h"
#import "DBBookmark.h"
#import "DBBookmarkController.h"

NSS* const kNewBookmarkWindowNibName = @"NewBookmark";
@implementation DBNewBookmarkWindowController

- (id) initWithBookmarkController: (DBBookmarkController*) bookmarkController title: (NSS*) bookmarkTitle url: (NSURL*) bookmarkURL
{
	if (self = [super initWithWindowNibName: kNewBookmarkWindowNibName])
	{
		mBookmarkController = bookmarkController;
		mBookmarkTitle		= bookmarkTitle;
		mBookmarkURL		= bookmarkURL;
	}
	
	return self;
}
//- (void) dealloc
//{
//	[mBookmarkController release];
//	[mBookmarkURL release];
//	[mBookmarkTitle release];
//	
//}

- (void) close
{
	[NSApp endSheet: [self window]];
	[super close];
	
//	[self release];
}

- (void) runSheetOnWindow: (NSWindow*) window
{
	[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: nil didEndSelector: nil contextInfo: nil];
	
	NSS* titleFieldValue = @"";
	
	if (mBookmarkTitle != nil)
	{
		titleFieldValue = mBookmarkTitle;
	}
	
	[mTitleField setStringValue: titleFieldValue];
	
}

- (IBAction) ok: (id) sender
{
	NSS* newTitle = [mTitleField stringValue];
	
	if ([newTitle length] <= 0)
	{
		newTitle = [mBookmarkURL absoluteString];
	}
	
	if ([newTitle length] > 0)
	{
		DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: mBookmarkURL title: newTitle];
		
		[mBookmarkController addBookmark: newBookmark toFront: YES];
		
//		[newBookmark release];
	}
	
	[self close];
}
- (IBAction) cancel: (id) sender
{
	[self close];
}

@end