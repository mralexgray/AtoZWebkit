/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

typedef enum
{
	 kDownloadStatusNone = 0,
	kDownloadStatusDownloading,
	kDownloadStatusCancelled,
	kDownloadStatusFinished,
} DBDownloadStatus;

extern NSS* kNoStatusString;
extern NSS* kCancelledString;
extern NSS* kFinishedString;

@interface DBDownloadObject : NSObject
{
	WebDownload*	mURLDownload;
	
	NSURL*			mURL;
	NSURLRequest*	mURLRequest;
	NSURLResponse*	mURLResponse;
	NSS*		mFileName;
	NSS*		mDownloadedFilePath;
	NSS*		mDisplayName;
	
	DBDownloadStatus	mStatus;
	
	CGFloat			mBytesLoaded;
	CGFloat			mExpectedLength;
}
- (id) initWithURLDownload: (WebDownload*) download;
- (WebDownload*) URLDownload;
- (void) setURLRequest: (NSURLRequest*) request;
- (NSS*) fileName;
- (NSS*) displayName;
- (void) setDisplayName: (NSS*) name;
- (NSS*) downloadedFilePath;
- (void) setDownloadedFilePath: (NSS*) path;
- (NSURL*) URL;
- (void) setURL: (NSURL*) URL;
- (NSS*) fileType;
- (NSImage*) icon;
- (void) setURLResponse: (NSURLResponse*) response;
- (CGFloat) bytesLoaded;
- (void) setBytesLoaded: (CGFloat) bytes;
- (NSI) percentComplete;
- (NSS*) stringStatus;
- (void) cancel;
- (DBDownloadStatus) status;
- (void) setStatus: (DBDownloadStatus) newStatus;

@end