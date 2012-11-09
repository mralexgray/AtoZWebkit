/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBBezelButtonCell.h"

@implementation DBBezelButtonCell

- (void) drawInteriorWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
}
- (void) drawWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
}
- (void) drawCellInside: (NSCell*) aCell
{
}
- (NSColor*) highlightColorWithFrame: (NSR) cellFrame inView: (NSView*) controlView
{
	return [NSColor colorWithDeviceRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.77];
}

@end