/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "DBURLFormatter.h"

@interface DBQuickDownload : NSObject {
	IBOutlet NSMatrix *directoryMatrix;
	IBOutlet NSButton *openButton;
	IBOutlet NSButton *decodeButton;
	IBOutlet NSButton *downloadCancelButton;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSTextField *URLField;
	
	BOOL isDownloading;
	
	WebDownload *download;
	
	NSInteger receivedContentLength;
	NSInteger expectedContentLength;
	
	NSS *_filename;
}
- (IBAction)downloadOrCancel:(id)sender;
- (void)setFilename:(NSS *)aString;
- (NSS *)filename;
@end
