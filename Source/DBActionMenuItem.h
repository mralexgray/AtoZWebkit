/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBActionMenuItem : NSView {
	NSS *label;
	NSTrackingRectTag _tag;
}
- (id)initWithFrame:(NSR)frame label:(NSS *)aLabel;
- (void)setLabel:(NSS *)aLabel;
- (NSS *)label;
@end
