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


extern NSString* kNoStatusString;
extern NSString* kCancelledString;
extern NSString* kFinishedString;


@interface DBDownloadObject : NSObject
{
	WebDownload*	mURLDownload;
	
	NSURL*			mURL;
	NSURLRequest*	mURLRequest;
	NSURLResponse*	mURLResponse;
	NSString*		mFileName;
	NSString*		mDownloadedFilePath;
	NSString*		mDisplayName;
	
	DBDownloadStatus	mStatus;
	
	CGFloat			mBytesLoaded;
	CGFloat			mExpectedLength;
}

- (id) initWithURLDownload: (WebDownload*) download;
- (WebDownload*) URLDownload;

- (void) setURLRequest: (NSURLRequest*) request;

- (NSString*) fileName;
- (NSString*) displayName;
- (void) setDisplayName: (NSString*) name;
- (NSString*) downloadedFilePath;
- (void) setDownloadedFilePath: (NSString*) path;
- (NSURL*) URL;
- (void) setURL: (NSURL*) URL;
- (NSString*) fileType;
- (NSImage*) icon;

- (void) setURLResponse: (NSURLResponse*) response;
- (CGFloat) bytesLoaded;
- (void) setBytesLoaded: (CGFloat) bytes;
- (NSInteger) percentComplete;

- (NSString *)stringStatus;
- (void) cancel;
- (DBDownloadStatus) status;
- (void) setStatus: (DBDownloadStatus) newStatus;


@end