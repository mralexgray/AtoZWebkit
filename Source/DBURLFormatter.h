/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBURLFormatter : NSObject {
//	NSS *oldurl;
}
//- (id)initWithStringURL:(NSS*) url;
+ (NSS*) formatAndReturnStringWithString: (NSS*) URLString;
+ (NSURL *)formatAndReturnURLWithString: (NSS*) URLString;
//- (void)setStringURL:(NSS*) url;
//- (NSS*) stringURL;
@end
