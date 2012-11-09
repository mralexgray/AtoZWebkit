/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBHistoryWindowController.h"

#import "DBBezelScroller.h"


@implementation DBHistoryWindowController


// Constructor/Destructor

- (id) initWithWindowNibName: (NSString*) windowNibName historyController: (DBHistoryController*) controller
{
	if(self = [super initWithWindowNibName: windowNibName])
	{
		historyController = controller;
	}
	
	return self;
}

- (void) dealloc
{
	[historyController release];
}

- (void) awakeFromNib
{
	[historyController	setView:		historyView];
	[historyView		setDelegate:	historyController];
	
	DBBezelScroller* scroller = [[DBBezelScroller alloc] init];

	[scrollView setVerticalScroller: scroller];
	[scroller	release];
		
	[historyView reloadData];
	
	// TODO: scroll the history view up to the top... i really hate how it starts at the bottom
}


// Window

- (IBAction) closeWindow: (id) sender
{
	[[self window] close];
}


// UI

- (IBAction) clear: (id) sender
{
	[historyController clearHistory];
}

- (IBAction) load: (id) sender
{
	[historyController loadSelected];
}

- (IBAction) remove: (id) sender
{
	[historyController removeSelected];
}

- (void) windowDidResize: (NSNotification*) aNotification
{
	[historyView reloadData];
}


@end
