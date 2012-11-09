/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "DeskBrowseConstants.h"
#import	"DBHistoryView.h"
//#import	"DBKeyStuff.h"
#import "NSFileManagerSGSAdditions.h"


@interface DBHistoryController : NSObject
{
	id			view;
	WebHistory*	webHistory;
	NSInteger			numberOfDaysToDisplay;
}

- (void) setView: (id) newView;

// Save/Load
- (void) loadHistoryFile;
- (void) saveHistoryFile;

// Notifications
- (void) historyDidAddItems: (NSNotification*) notification;
- (void) historyDidRemoveItems: (NSNotification*) notification;
- (void) historyDidRemoveAllItems: (NSNotification*) notification;

// UI
- (void) clearHistory;
- (void) loadSelected;
- (void) removeSelected;

// History View
- (NSI) numberOfDates;
- (NSI) numberOfItemsForDate: (NSCalendarDate*) date;
- (NSI) numberOfRows;
- (BOOL) isDateAtIndex: (NSI) index;
- (NSCalendarDate*) dateAtIndex: (NSI) index;
- (id) itemAtIndex: (NSI) index;
- (id) objectForDate: (NSCalendarDate*) date index: (NSI) index;
- (void) rowClicked: (NSI) row;

- (NSMenu *)menuForHistory;

@end

