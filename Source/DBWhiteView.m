//
//  DBWhiteView.m
//  DeskBrowse
//
//  Created by Joel Levin on 11/17/08.
//  Copyright 2008 Joel Levin. All rights reserved.
//

#import "DBWhiteView.h"


@implementation DBWhiteView

- (void)drawRect:(NSRect)rect
{
	[RANDOMCOLOR set];
//	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:rect];
}

@end
