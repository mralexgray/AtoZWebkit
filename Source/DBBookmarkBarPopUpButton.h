/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBBookmarkBarPopUpButton : NSPopUpButton
{
	NSS*			mText;
	NSFont*				mTextFont;
	NSColor*			mDefaultColor;
	
	BOOL				mShouldBeFilled;
}
- (void) drawBackground;
- (void) drawText;
- (void) deselectItems;
- (BOOL) shouldBeFilled;
@end