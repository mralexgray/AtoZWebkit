/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBLocationTextFieldCell : NSTextFieldCell
{
@private
	NSImage*	mImage;
	NSSZ		mSpaceOnRight;
}
- (void) setExtraSpaceOnRight: (NSSZ) extraSize;
@end
