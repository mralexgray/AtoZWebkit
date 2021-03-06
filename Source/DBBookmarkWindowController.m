/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmarkWindowController.h"
#import "DBBookmarkController.h"
#import "DBBezelScroller.h"

@implementation DBBookmarkWindowController

// Constructor/Destructor
- (id) initWithWindowNibName: (NSS*) windowNibName bookmarkController: (DBBookmarkController*) controller
{
	if (self = [super init])
//	if(self = [super initWithWindowNibName: windowNibName])
	{
//		mBookmarkController = [controller retain];
	}
	
	return self;
}
/*
- (void) dealloc
{
	[mBookmarkController release];
	
	[super dealloc];
}
- (void) awakeFromNib
{
	if (mBookmarkController != nil)
	{
		[mBookmarkController setTableView: mTableView];
		
		[mOutlineView setDelegate: mBookmarkController];
		[mOutlineView setDataSource: mBookmarkController];
	}
}

// Window
- (IBAction) closeWindow: (id) sender
{
	[[self window] close];
}
- (IBAction) openEditWindow: (id) sender
{
	[mEditingWindow setFrame: [[self window] frame] display: NO];
	
	[NSApp beginSheet: mEditingWindow modalForWindow: [self window] modalDelegate: self didEndSelector: nil contextInfo: nil];
}
- (IBAction) closeEditWindow: (id) sender
{
	[mOutlineView reloadData];
	
	[NSApp endSheet: mEditingWindow];
	[mEditingWindow orderOut: nil];
	
	[[self window] makeKeyAndOrderFront: nil];
}

// UI
- (IBAction) remove: (id) sender
{
	NSInteger selectedRow = [mTableView selectedRow];
	
	if (selectedRow > -1 && selectedRow < [mTableView numberOfRows])
	{
		[mBookmarkController deleteBookmarkAtIndex: selectedRow];
	}
	
	[mTableView reloadData];
}
- (IBAction) load: (id) sender
{
	NSInteger selectedRow = [mTableView selectedRow];
	
	if (selectedRow > -1 && selectedRow < [mTableView numberOfRows])
	{
		[mBookmarkController loadBookmarkAtIndex: selectedRow];
	}
}
*/
@end