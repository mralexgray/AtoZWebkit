/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
@class DBLocationTextFieldCell;

@interface DBLocationTextField : NSTextField
{
@private
	NSProgressIndicator* mProgressIndicator;
}
- (void) animate: (BOOL) animate;
- (void) setImage: (NSImage*) image;
@end
