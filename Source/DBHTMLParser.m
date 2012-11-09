/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBHTMLParser.h"

//============================================================
//
//	Thank you Adium for being a great point of reference!
//
//============================================================
// For finding links
NSS* kAOpen			= @"A ";
NSS* kAClose			= @"</A";
NSS* kHREF				= @"HREF=";
NSS* kOpenBracket		= @"<";
NSS* kCloseBracket		= @">";
NSS* kQuoteCharacters	= @"'\"";
// For replacing HTML
NSS* kHTMLCharStart	= @"&";
NSS* kHTMLCharEnd		= @";";
NSS* kAmpersandHTML	= @"AMP";
NSS* kAmpersand		= @"&";
NSS* kApostropheHTML	= @"APOS";
NSS* kApostrophe		= @"'";
NSS* kDashHTML			= @"MDASH";
NSS* kDash				= @"-";
NSS* kGreaterThanHTML	= @"GT";
NSS* kGreaterThan		= @">";
NSS* kLessThanHTML		= @"LT";
NSS* kLessThan			= @"<";
NSS* kQuoteHTML		= @"QUOT";
NSS* kQuote			= @"\"";
NSS* kSpaceHTML		= @"NBSP";
NSS* kSpace			= @" ";

@interface DBHTMLParser (Private)
- (NSS*) pReplaceHTMLCodesInString: (NSS*) HTMLString;
@end

@implementation DBHTMLParser

+ (DBHTMLParser*) HTMLParser
{
	return [[[DBHTMLParser alloc] init] autorelease];
}
- (NSA*) linksFromHTMLString: (NSS*) HTMLString
{
	NSMutableArray*	links				= nil;
	NSScanner*		linkScanner			= [NSScanner scannerWithString: HTMLString];
	NSCharacterSet*	quotesCharacterSet	= [NSCharacterSet characterSetWithCharactersInString: kQuoteCharacters];
	NSInteger				lengthOfHTMLString	= [HTMLString length];
	NSInteger				lengthOfAOpen		= [kAOpen length];
	NSInteger				lengthOfHREF		= [kHREF length];
	while (![linkScanner isAtEnd])
	{
		NSS*	intoString				= nil;
		NSInteger			scanLocation			= [linkScanner scanLocation];
		NSInteger			lengthOfRemainingString	= lengthOfHTMLString - scanLocation;
		
		NSRange		rangeOfAOpen			= NSMakeRange(scanLocation, lengthOfAOpen);
		
		if (lengthOfRemainingString - 1 > lengthOfAOpen && [[HTMLString substringWithRange: rangeOfAOpen] caseInsensitiveCompare: kAOpen] == NSOrderedSame)
		{
			// Found "A" tag
			
			if ([linkScanner scanUpToString: kHREF intoString: nil])
			{
				// Advance the scanner to the URL
				
				if (lengthOfHTMLString - [linkScanner scanLocation] > lengthOfHREF + 1)
				{
					[linkScanner setScanLocation: [linkScanner scanLocation] + lengthOfHREF + 1];
				}
				
				
				// Scan the URL into an NSString
				
				NSS* URLString = nil;
				
				if ([linkScanner scanUpToCharactersFromSet: quotesCharacterSet intoString: &URLString])
				{
					// Advance the scanner to the end of the A tag
					
					if ([linkScanner scanUpToString: kCloseBracket intoString: nil])
					{
						// Advance the scanner to the title
						
						if (lengthOfHTMLString - [linkScanner scanLocation] > 1)
						{
							[linkScanner setScanLocation: [linkScanner scanLocation] + 1];
						}
						
						
						// Scan the title into an NSString
						
						NSS* title = nil;
						
						if ([linkScanner scanUpToString: kAClose intoString: &title])
						{
							if (URLString != nil)
							{
								if (title == nil)
								{
									title = [NSString string];
								}
								
								title = [self pReplaceHTMLCodesInString: title];
								
								NSArray*		objects				= @[title, URLString];
								NSArray*		keys				= @[kLinkTitleKey, kLinkURLStringKey];
								NSD*	newLinkDictionary	= [NSD dictionaryWithObjects: objects forKeys: keys];
								
								if (links == nil)
								{
									links = [NSMutableArray array];
								}
								
								[links addObject: newLinkDictionary];
							}
						}
					}
				}
			}
		}
		// Advance the scanner one character
		
		scanLocation = [linkScanner scanLocation];
		
		if ((lengthOfHTMLString - scanLocation) > 0)
		{
			[linkScanner setScanLocation: scanLocation + 1];
		}
	}
	
	return links;
}
- (NSA*) linksFromHTMLFileAtPath: (NSS*) HTMLFilePath
{
	NSS* HTMLStringFromFile = [NSString stringWithContentsOfFile: HTMLFilePath encoding: NSUTF8StringEncoding error: nil];
	
	return [self linksFromHTMLString: HTMLStringFromFile];
}

@end

@implementation DBHTMLParser (Private)

- (NSS*) pReplaceHTMLCodesInString: (NSS*) HTMLString
{
	NSMS* newString = [[HTMLString mutableCopy] autorelease];
	NSRange	currentRange;

	// Ampersand
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kAmpersandHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kAmpersand];
	}
	
	// Apostrophe
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kApostropheHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kApostrophe];
	}
	
	// Dash
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kDashHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kDash];
	}
	
	// Greater than
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kGreaterThanHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kGreaterThan];
	}
	
	// Less than
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kLessThanHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kLessThan];
	}
	
	// Quote
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kQuoteHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kQuote];
	}
	
	// Space
	while ((currentRange = [newString rangeOfString: [NSString stringWithFormat: @"%@%@%@", kHTMLCharStart, kSpaceHTML, kHTMLCharEnd] options: NSCaseInsensitiveSearch]).location != NSNotFound)
	{
		[newString replaceCharactersInRange: currentRange withString: kSpace];
	}
	
	return newString;
}

@end