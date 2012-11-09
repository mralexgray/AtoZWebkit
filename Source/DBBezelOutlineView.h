/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/


#import <Cocoa/Cocoa.h>

#import "DBBezelScroller.h"
#import "DBBezelDataCell.h"
#import "DBBezelButtonCell.h"


@interface NSOutlineView (SGSAdditions)
//@property (strong, nonatomic) NSButtonCell* outlineCell;
- (void) setOutlineCell: (NSButtonCell*) newCell;
//
@end

@interface DBBezelOutlineView : NSOutlineView
{
}

@end
