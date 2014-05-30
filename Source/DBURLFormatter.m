/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBURLFormatter.h"
@implementation DBURLFormatter
/*- (id)init {
	[self initWithStringURL:@""];
}
- (id)initWithStringURL:(NSS*) url {
	self = [super init];
	if (self) {
		oldurl = [url retain];
	}
	return self;
}
- (void)dealloc {
	[oldurl release];
	[super dealloc];
}*/
// method for actually doing the formatting
+ (NSS*) formatAndReturnStringWithString: (NSS*) URLString {
	NSS *newURL = URLString;
	
	// is it localhost?
	if ([URLString isEqualToString:@"localhost"]) {
		return @"http://localhost";
	}
	
	if ([URLString isEqualToString:@"about:blank"]) {
		return URLString;
	}
	
	if ([URLString hasPrefix:@"javascript:"]) {
		return URLString;
	}
	
	if ([URLString rangeOfString:@"://"].location == NSNotFound) {
		if ([URLString rangeOfString:@"."].location != NSNotFound || [URLString rangeOfString:@":"].location != NSNotFound) {
			newURL = [NSString stringWithFormat: @"http://%@", URLString];
		} else {
			if ([URLString rangeOfString:@":"].location == NSNotFound) {
				if ([URLString rangeOfString:@"localhost"].location == NSNotFound) {
					// there are no dots in the provided string, and it is not 'localhost', so make it loadable
					newURL = [NSString stringWithFormat:@"http://www.%@.com", URLString];
				} else {
					newURL = [NSString stringWithFormat:@"http://%@", URLString];
				}
			} else {
				return URLString;
			}
		}
	} else {
		// there is a scheme, but how's the rest of the url?
		if ([URLString rangeOfString:@"localhost"].location != NSNotFound) {
			// don't mess with it!
			return URLString;
		} else if ([URLString rangeOfString:@":"].location != NSNotFound) {
			// don't mess with it
			// http://server:port/page
			return URLString;
		} else {
			if ([URLString rangeOfString:@"."].location == NSNotFound) {
				// there is no dot (ie: http://google )
				// add www
				NSInteger loc = [newURL rangeOfString:@"//"].location;
				loc += 2; // skip past the slashes
				NSS *scheme = [newURL substringToIndex:loc];
				NSS *content = [newURL substringFromIndex:loc];
				if (![scheme isEqualToString:@"file://"]) {
					newURL = [NSString stringWithFormat:@"%@www.%@", scheme, content];
					
					// add dot com
					newURL = [NSString stringWithFormat:@"%@.com", newURL];
				}
			}
		}
	}
	
	return newURL;
}
+ (NSURL *)formatAndReturnURLWithString: (NSS*) URLString {
	NSURL *tURL = [NSURL URLWithString: [self formatAndReturnStringWithString: URLString]];
	
	return tURL;
}
// accessor methods for the string to format
/*
- (void)setStringURL:(NSS*) url {
	[url retain];
	[oldurl release];
	oldurl = url;
}
- (NSS*) stringURL {
	return oldurl;
}*/
@end
