/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBStatusItemController.h"

@implementation DBStatusItemController
- (id)initWithController:(id)controller {
	self = [super init];
	if (self) {
		// set the controller
		_controller = controller;
		
		// create a status item
		NSStatusBar *bar = [NSStatusBar systemStatusBar];
		_item = [bar statusItemWithLength:33];
		 // the item must be retained to stay in the menubar
		[_item setImage:[NSImage imageNamed:@"DeskBrowse_Small"]];
		
		// load the archived menu and use it, fixing the bug about it not showing when no main menubar is shown
		NSS *path = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"dbmenu"];
		[_item setMenu:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
		
		[_item setHighlightMode:YES];
		
		// uncomment this to generate the dbmenu file
		//[NSKeyedArchiver archiveRootObject:[self standardMenu] toFile:[@"~/Desktop/main.dbmenu" stringByExpandingTildeInPath]];
	}
	return self;
}
- (void)dealloc {
	[_controller release];
	[[NSStatusBar systemStatusBar] removeStatusItem:_item];
	[_item release];
}
- (NSMenu *)standardMenu {
	// get the current menu
	NSMenu *menu = [[[NSApplication sharedApplication] mainMenu] copy];
	NSMenuItem *_m = [menu itemAtIndex:0];
	[_m setTitle:@"DeskBrowse"];
	[menu insertItem:[NSMenuItem separatorItem] atIndex:1];
	[menu addItem:[NSMenuItem separatorItem]];
	NSMenuItem *slide = [[NSMenuItem alloc] initWithTitle:@"Toggle SlideBrowser"
													action:@selector(toggleSlideBrowse) 
											keyEquivalent:@""];
	NSMenuItem *websp = [[NSMenuItem alloc] initWithTitle:@"Toggle Webspose"
													action:@selector(toggleWebspose)
											keyEquivalent:@""];
	[slide setTarget:_controller];
	[websp setTarget:_controller];
	
	[menu addItem:slide];
	[menu addItem:websp];
	
//	[slide autorelease];
//	[websp autorelease];
	return menu;// autorelease];
}
@end
