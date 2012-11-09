/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmarkEditWindowController.h"
#import "DBBetterOutlineView.h"
#import "DBBookmark.h"
#import "DBBookmarkController.h"
#import "DBBookmarkTableDataSource.h"

NSS* const kBookmarkEditWindowNibName = @"BookmarkEdit";
@implementation DBBookmarkEditWindowController

- (id) initWithOutlineDataSource: (DBBookmarkOutlineDataSource*) dataSource bookmarkController: (DBBookmarkController*) bookmarkController
{
	if (self = [super initWithWindowNibName: kBookmarkEditWindowNibName])
	{
		mOutlineDataSource	= dataSource;
		mBookmarkController	= bookmarkController;
		mOutlineViewFont	= [NSFont systemFontOfSize: 10.0];
		
		[AZNOTCENTER addObserver: self selector: @selector(reloadData) name: kBookmarksDidChangeNotification object: nil];
	}
	
	return self;
}
- (void) dealloc
{
	[AZNOTCENTER removeObserver: self];
	
	[mOutlineDataSource release];
	[mBookmarkController release];
	[mOutlineViewFont release];
		
}

- (IBAction) closeWindow: (id) sender
{
	[NSApp endSheet: [self window]];
	[self close];
}
- (IBAction) addBookmark: (id) sender
{
	DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: nil title: nil];
	
	[mBookmarkController addBookmark: newBookmark toFront: YES];
	[newBookmark release];
	
	[mOutlineView selectRow: 0 byExtendingSelection: NO];
	[mOutlineView editFirstColumnOfSelectedRow];
}

- (void) close
{
	[NSApp endSheet: [self window]];
	[super close];
	
	[self release];
}
- (void) runSheetOnWindow: (NSWindow*) window
{
	[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: nil didEndSelector: nil contextInfo: nil];
	
	[mOutlineView setDelegate: (id)self];
	[mOutlineView setDataSource: (id)mOutlineDataSource];
	
	[mOutlineView setDraggingSourceOperationMask: NSTableViewDropAbove forLocal: YES];
	[mOutlineView registerForDraggedTypes: @[kBookmarkDragType]];
	
}

- (void) reloadData
{
	[mOutlineView reloadData];
}

- (void) outlineView: (NSOutlineView*) outlineView willDisplayCell: (id) cell forTableColumn: (NSTableColumn*) tableColumn item: (id) item
{
	[cell setFont: mOutlineViewFont];
}

@end