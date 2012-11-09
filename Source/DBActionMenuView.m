/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/


#import "DBActionMenuView.h"


@implementation DBActionMenuView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bgImage = [[NSImage imageNamed:@"action_menu"] retain];
		opacity = 1.0;
		
		webspose	= [[DBActionMenuItem alloc] initWithFrame:NSMakeRect(15,28,100,18) label:@"Webspose"];
		downloads	= [[DBActionMenuItem alloc] initWithFrame:NSMakeRect(15,58,100,14) label:@"Downloads"];
		history		= [[DBActionMenuItem alloc] initWithFrame:NSMakeRect(15,74,100,14) label:@"History"];
		bookmarks	= [[DBActionMenuItem alloc] initWithFrame:NSMakeRect(15,90,100,14) label:@"Bookmarks"];
		
		[self addSubview:webspose];
		[self addSubview:downloads];
		[self addSubview:history];
		[self addSubview:bookmarks];
    }
    return self;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)mouseEntered:(NSEvent *)theEvent {
}

- (void)drawRect:(NSRect)rect {
    [bgImage compositeToPoint:NSZeroPoint
					operation:NSCompositeSourceOver
					 fraction:opacity];
}

- (void)dealloc {
	[webspose release];
	[downloads release];
	[history release];
	[bookmarks release];
	[bgImage release];
	[super dealloc];
}

@end

