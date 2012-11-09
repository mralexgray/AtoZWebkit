/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBDownloadObject.h"

NSS* kNoStatusString	= @"";
NSS* kCancelledString	= @"Cancelled";
NSS* kFinishedString	= @"Finished";
@implementation DBDownloadObject
- (id) init
{
	if(self = [super init])
	{
		[self setStatus: kDownloadStatusNone];
	}
	
	return self;
}
- (id) initWithURLDownload: (WebDownload*) download;
{
	if(self = [self init])
	{
		mURLDownload = download;
		
		[self setURLRequest: [download request]];
	}
	
	return self;
}
- (void) dealloc
{
	[mURLRequest			release];
	[mURLDownload			release];
	[mURLResponse			release];
	[mFileName				release];
	[mDownloadedFilePath	release];
	[mDisplayName			release];
	[mURL					release];
	
}
#pragma mark -

// URL download
- (WebDownload*) URLDownload
{
	return mURLDownload;
}

// URL request
- (void) setURLRequest: (NSURLRequest*) request
{
	// URLReques
	
	if(request != mURLRequest)
	{
		[mURLRequest	release];
		
		mURLRequest = request;
	}
	
	// URL
	[self setURL: [request URL]];
	
	// File name
	[mFileName release];
	mFileName = [[[mURL absoluteString] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	// Display name
	[self setDisplayName: [mFileName lastPathComponent]];
}

// URL response
- (void) setURLResponse: (NSURLResponse*) response
{
	if(response != mURLResponse)
	{
		[mURLResponse	release];
		
		mURLResponse = response;
	}
}

// URL
- (NSURL*) URL
{
	return mURL;
}
- (void) setURL: (NSURL*) URL
{
	if(URL != mURL)
	{
		[mURL	release];
		
		mURL = URL;
	}
}

// File name
- (NSS *) fileName
{
	return mFileName;
}

// Display name
- (NSS*) displayName
{
	if(mDisplayName != nil)
	{
		return mDisplayName;
	}
	else
	{
		return [self fileName];
	}
}
- (void) setDisplayName: (NSS*) name
{
	if(name != mDisplayName)
	{
		[mDisplayName	release];
		
		mDisplayName = name;
	}
}

// Downloaded file path
- (NSS*) downloadedFilePath
{	
	return mDownloadedFilePath;
}
- (void) setDownloadedFilePath: (NSS*) path
{
	if(path != mDownloadedFilePath)
	{
		[mDownloadedFilePath	release];
		
		mDownloadedFilePath = path;
	}
}

// File type
- (NSS*) fileType
{
	NSS* fileType;
	
	fileType = [mFileName pathExtension]; 
	
	return fileType;
}

// Icon
- (NSImage*) icon
{
	NSImage*		icon;
	NSWorkspace*	workspace;
	
	workspace	= [NSWorkspace sharedWorkspace];
	icon		= [workspace iconForFileType: [self fileType]];
	
	return icon;
}

// Progress

- (CGFloat) bytesLoaded
{
	return mBytesLoaded;
}
- (void) setBytesLoaded: (CGFloat) bytes
{
	mBytesLoaded	= bytes;
	mExpectedLength	= [mURLResponse expectedContentLength];
}
- (NSI) percentComplete
{
	NSInteger percentComplete = (mBytesLoaded / (CGFloat) mExpectedLength) * 100.0;
	
	if(percentComplete < 0)
	{
		percentComplete = 0;
	}
	else if(percentComplete > 100)
	{
		percentComplete = 100;
	}
	
	return percentComplete;
}

// Status
- (NSS*) stringStatus
{
	NSS*	stringStatus	= nil;
	NSNumber*	fileSize		= nil;
	
	if(mStatus == kDownloadStatusDownloading)
	{
		if (mExpectedLength != NSURLResponseUnknownLength)
		{
			//fileSize		= [NSNumber numberWithInt: (mExpectedLength / 1024)]; // kilobytes
			stringStatus	= [NSString stringWithFormat: @"%ld%%", [self percentComplete]];
		}
		else
		{
			stringStatus = @"?%";//[NSString stringWithFormat: @"?%"];
		}
	}
	else
	{
		if(mStatus == kDownloadStatusNone)
		{
			stringStatus = kNoStatusString;
		}
		else if(mStatus == kDownloadStatusCancelled)
		{
			stringStatus = kCancelledString;
		}
		else if(mStatus == kDownloadStatusFinished)
		{
			stringStatus = kFinishedString;
		}
	}
	
	return stringStatus;
}
- (void) cancel
{
	[mURLDownload cancel];
	
	[self setStatus: kDownloadStatusCancelled];
}
- (DBDownloadStatus) status
{
	return mStatus;
}
- (void) setStatus: (DBDownloadStatus) newStatus
{
	mStatus = newStatus;
}

@end
