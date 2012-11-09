/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "DeskBrowseConstants.h"

@class DBDownloadObject;
@class DBBezelController;
@class DBBezelWindow;
@class NSFileManagerSGSAdditions;


@interface DBDownloadController : NSWindowController
{
	IBOutlet NSTableView*	mDownloadTableView;
	
	DBBezelController*		mBezelController;
	
	NSFont*					mTableCellFont;
	NSMutableArray*			mDownloads;
	
	NSInteger						mNumloads;
	NSInteger						mNumloadsfinished;
	
	double					mLastUpdate;
	
	BOOL					mAllowClearButton;
	BOOL					mAllowCancelButton;
	BOOL					mAllowCancelAllButton;
	BOOL					mAllowShowInFinderButton;
}

- (void) prepareForDownloadWithRequest: (NSURLRequest*) aRequest;

- (IBAction) clearDownloads: (id) sender;
- (IBAction) cancelSelected: (id) sender;
- (IBAction) cancelAllDownloads: (id) sender;
- (IBAction) showDownloadInFinder: (id) sender;

- (void)handleNotification: (NSNotification*) note;
- (DBDownloadObject*) objectWithDownload: (NSURLDownload*) download;

- (void) tableViewDoubleClick;

- (NSI) downloadsInProgress;
- (BOOL) deskBrowseShouldTerminate;

@end