/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>


static NSString* kLinkTitleKey		= @"HTMLParserLink";
static NSString* kLinkURLStringKey	= @"HTMLParserURLString";

@interface DBHTMLParser : NSObject
{
	NSXMLParser*	mXMLParser;
	NSMutableArray*	mLinkDictionaries;
	BOOL			mStillParsing;
}

+ (DBHTMLParser*) HTMLParser;

- (NSArray*) linksFromHTMLString: (NSString*) HTMLString;
- (NSArray*) linksFromHTMLFileAtPath: (NSString*) HTMLFilePath;

@end