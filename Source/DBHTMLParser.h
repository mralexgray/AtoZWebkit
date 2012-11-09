/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

static NSS* kLinkTitleKey		= @"HTMLParserLink";
static NSS* kLinkURLStringKey	= @"HTMLParserURLString";
@interface DBHTMLParser : NSObject
{
	NSXMLParser*	mXMLParser;
	NSMutableArray*	mLinkDictionaries;
	BOOL			mStillParsing;
}
+ (DBHTMLParser*) HTMLParser;
- (NSA*) linksFromHTMLString: (NSS*) HTMLString;
- (NSA*) linksFromHTMLFileAtPath: (NSS*) HTMLFilePath;
@end