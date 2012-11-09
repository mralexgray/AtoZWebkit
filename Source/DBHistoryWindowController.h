/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

#import	"DBHistoryView.h"
#import "DBHistoryController.h"


@interface DBHistoryWindowController : NSWindowController
{
	IBOutlet DBHistoryView*	historyView;
	IBOutlet NSScrollView*	scrollView;
	
	DBHistoryController*		historyController;
}

- (id) initWithWindowNibName: (NSString*) windowNibName historyController: (DBHistoryController*) controller;

// Window
- (IBAction) closeWindow: (id) sender;

// UI
- (IBAction) clear: (id) sender;
- (IBAction) load: (id) sender;
- (IBAction) remove: (id) sender;

@end
