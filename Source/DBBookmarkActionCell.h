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
	NSColor*			mDefaultColor, *mMouseOverColor, *mMouseDownColor;
	BOOL				mMouseOver, mMouseDown;
}

@property (NATOM) NSTrackingRectTag	mTrackingRectTag;
@property (NATOM) NSR				frame;

- (id) initWithTarget: (id) target action: (SEL) action;
@end