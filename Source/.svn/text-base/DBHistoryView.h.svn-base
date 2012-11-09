/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>

@class DBHistoryController;


@interface DBHistoryView : NSView
{
	id						delegate;
	NSColor*				textColor;
	NSColor*				selectedTextColor;
	NSColor*				finishedTextColor;
	NSInteger						textSize;
	NSInteger						selectedRow;
	NSMutableDictionary*	textAttributes;
	CGFloat						rowHeight;
	CGFloat						topPadding;
}

- (void) setDelegate: (id) object;

//

- (NSString*) string: (NSString*) string withAttributes: (NSDictionary*) attributes constrainedToWidth: (CGFloat) width;
- (void) setTextColor: (NSColor*) color;
- (void) setTextSize: (NSInteger) size;

//
- (NSInteger) selectedRow;
- (void) updateSelectedRow;
- (void) reloadData;

@end
