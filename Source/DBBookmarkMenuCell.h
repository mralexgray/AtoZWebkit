/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>
#import "DBBookmarkBarCell.h"

@interface DBBookmarkMenuCell : NSPopUpButtonCell <DBBookmarkBarCell>
{
	NSView*				mControlView;
	
	NSS*			mStringValue;
	
	NSColor*			mDefaultColor;
	NSColor*			mMouseOverColor;
	NSColor*			mMouseDownColor;
	
	NSTrackingRectTag	mTrackingRectTag;
	
	BOOL				mMouseOver;
	BOOL				mMouseDown;
	BOOL				mPopUpMenuVisible;
	
	NSR				mFrame;
}
@end