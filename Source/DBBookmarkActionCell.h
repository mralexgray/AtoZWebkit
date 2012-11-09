/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>
#import "DBBookmarkBarCell.h"


@interface DBBookmarkActionCell : NSActionCell <DBBookmarkBarCell>
{
	NSView*				mControlView;
	
	NSColor*			mDefaultColor;
	NSColor*			mMouseOverColor;
	NSColor*			mMouseDownColor;
	
	NSTrackingRectTag	mTrackingRectTag;
	
	BOOL				mMouseOver;
	BOOL				mMouseDown;
	
	NSR				mFrame;
}

- (id) initWithTarget: (id) target action: (SEL) action;

@end