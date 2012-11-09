/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBTabController.h"
#import "DBTab.h"
#import "DBTabBar.h"

@implementation DBTabController

- (id) initWithTabBar: (DBTabBar*) bar tabView: (NSTabView*) view
{
	if (self = [super init])
	{
		[AZNOTCENTER addObserver: self selector: @selector(tabClicked:) name: @"DBTabClicked" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(tabWantsToClosed:) name:@"DBTabWantsToBeClosed" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(slideWindowResized:) name:@"DBSlideWindowResized" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(removeAllTabs) name:@"DBCloseAllTabs" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(reloadTab) name:@"DBReloadTab" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(reloadAllTabs) name:@"DBReloadAllTabs" object: nil];
		[AZNOTCENTER addObserver: self selector: @selector(frameDidChange) name: NSViewFrameDidChangeNotification object: bar];
		[AZNOTCENTER addObserver: self selector: @selector(frameDidChange) name: NSViewBoundsDidChangeNotification object: bar];
															
		tabs		= [[NSMutableArray alloc] init];
		tabView		= view;
		tabBar		= bar;
		tabWidth	= 120.0;
		
		// create new tab ** Do not call newTabWithWebView: here **
		DBTab* newTab	= [[DBTab alloc] initWithFrame: NSMakeRect(0, 0, tabWidth, 29)];
		
		[tabs	addObject:	newTab];
		[tabBar addSubview: newTab];
		
		[self	selectTab: newTab refresh: NO];
		[self	updateTabSize];
		[tabBar setNeedsDisplay: YES];
		
		[newTab	release];
	}
	
	return self;
}
- (WebView*)defaultWebView {
	return defaultWebView;
}
- (void)setDefaultWebView:(WebView *)aWebView {
	[defaultWebView release];
	defaultWebView = aWebView;
}
- (DBTabBar *)tabBar {
	return tabBar;
}
- (void) dealloc
{
	[AZNOTCENTER removeObserver:self];
	
	[tabs		release];
	[tabView	release];
	[tabBar		release];
	[defaultWebView release];
	
}
- (void) tabClicked: (NSNotification*) notification
{
	NSD*	userInfo;
	DBTab*			clickedTab;
	
	userInfo = [notification userInfo];
	
	if (userInfo != nil)
	{
		clickedTab = userInfo[@"clickedTab"];
		[self selectTab: clickedTab refresh: YES];
	}
}
- (void) tabWantsToClosed:(NSNotification *)notification {
	DBTab *tTab = (DBTab *)[notification userInfo][@"sender"];
	if ([tabs count] > 1) {
		[self removeTab: tTab redraw: YES resize: YES];
	}
}
- (void) slideWindowResized: (NSNotification*) notification
{
	[self updateTabSize];
	[tabBar setNeedsDisplay: YES];
}
- (void) newTabWithWebView: (WebView*) webView select: (BOOL) selectNewTab
{
	if ([self canFitMoreTabs])
	{
		DBTab*			newTab;
		NSTabViewItem*	newTabViewItem;
		newTab			= [[DBTab alloc] initWithFrame: NSMakeRect(0, 0, 0, 0)];
		newTabViewItem	= [[NSTabViewItem alloc] init];
		[newTabViewItem	setView: webView];
		[tabView addTabViewItem: newTabViewItem];
		[tabs	addObject:	newTab];
		[tabBar addSubview: newTab];
		
		if (selectNewTab)
		{
			[self selectTab: newTab refresh: NO];
		}
		
		[self	updateTabSize];
		[tabBar setNeedsDisplay: YES];
		[newTab			release];
		[newTabViewItem release];
	}
	else
	{
		NSLog(@"Can't fit anymore tabs");
		NSBeep();
	}
}
- (void) newTabWithWebView: (WebView*) webView select: (BOOL) selectNewTab URLString:(NSS *)URLString {
	[self newTabWithWebView:webView select:selectNewTab];
	[(DBTab *)tabs[([tabs count] - 1)] setURLString:URLString];
}
- (void) removeTab: (DBTab*) tab redraw: (BOOL) redraw resize: (BOOL) resize
{
	// Eventually need to disable "Close" menu item when there is only one tab
	if ([tabs count] > 1)
	{
		DBTab *currentTab;
		DBTab *newTab;
		NSInteger i;
		NSInteger indexOfTab			= [tabs indexOfObject: tab];
		NSInteger selectedTab			= [tabs indexOfObject: [self selectedTab]];
		NSInteger	indexOfTabToSelect	= selectedTab;
		
		if (indexOfTab != NSNotFound)
		{
			if (indexOfTab == selectedTab)
			{
				if (indexOfTab == ([tabs count] - 1)) // Last tab
				{
					indexOfTabToSelect = indexOfTab - 1;
				}
			}
			else
			{
				if (indexOfTab < selectedTab)
				{
					indexOfTabToSelect = selectedTab - 1;
				}
			}
						
			[tab		removeFromSuperview];
			[tabs		removeObjectAtIndex: indexOfTab]; // faster to removeObjectAtIndex: than removeObject:
			[[[tabView	tabViewItemAtIndex: indexOfTab] view] stopLoading: self];
			[tabView	removeTabViewItem: [tabView tabViewItemAtIndex: indexOfTab]];
			[tabView	selectTabViewItemAtIndex: indexOfTabToSelect];
			[self		selectTab: tabs[indexOfTabToSelect] refresh: NO];
			
			if (resize)
			{
				[self updateTabSize];
			}
			
			if (redraw)
			{
				[tabBar setNeedsDisplay: YES];
			}
		}
	}
}
- (void) removeAllTabs
{
	DBTab*			selectedTab		= [self selectedTab];
	DBTab*			currentTab		= nil;
	NSMutableArray*	tabsToRemove	= [[NSMutableArray alloc] init];
	
	NSInteger i;
	for(i = 0; i < [tabs count]; i++)
	{
		currentTab = tabs[i];
		if (currentTab != selectedTab)
		{
			[tabsToRemove addObject: currentTab];
		}
	}
	
	for(i = 0; i < [tabsToRemove count]; i++)
	{
		currentTab = tabsToRemove[i];
		[self removeTab: currentTab redraw: NO resize: NO];
	}
	
	[tabsToRemove release];
	[self updateTabSize];
	[tabBar setNeedsDisplay: YES];
}
- (void) updateTabSize
{
	CGFloat tabWidthToFit = [tabBar frame].size.width / [tabs count];
		
	if (tabWidth >= tabWidthToFit)
	{
		tabWidth = tabWidthToFit;
	}
	else
	{
		if (tabWidthToFit <= 120.0)
		{
			tabWidth = tabWidthToFit;
		}
		else
		{
			if (tabWidth < 120.0)
			{
				tabWidth = 120.0;
			}
		}
	}
			
	DBTab*	currentTab;
	NSP	newOrigin;
	NSSZ	newSize;
	
	newSize	= NSMakeSize(tabWidth, 29);
	
	NSInteger i;
	for(i = 0; i < [tabs count]; i++)
	{
		currentTab	= tabs[i];
		newOrigin	= NSMakePoint((i * (tabWidth )), 0);
		
		[currentTab setFrame: NSMakeRect(newOrigin.x, newOrigin.y, newSize.width, newSize.height)];
	}
	
	[tabBar setNeedsDisplay: YES];
}
- (BOOL) canFitMoreTabs
{
	BOOL	canFit			= YES;
	CGFloat	tabWidthToFit	= [tabBar frame].size.width / [tabs count];
	
	if (tabWidthToFit < 50.0)
	{
		canFit = NO;
	}
	else
	{
		canFit = YES;
	}
	
	return canFit;
}
- (void)selectTab:(DBTab *)aTab refresh: (BOOL) refresh {
	DBTab*			currentTab = nil;
	
	NSInteger i;
	for(i = 0; i < [tabs count]; i++)
	{
		currentTab = tabs[i];
				
		if (currentTab != nil)
		{
			if (currentTab == aTab)
			{
				[currentTab setSelected: YES];
				[tabView selectTabViewItemAtIndex: i];
				[[[tabView tabViewItemAtIndex: i] view] setNeedsDisplay: YES];
				
				// Send notification
				NSMD *dic = [[NSMD alloc] init];
				dic[@"WebView"] = [[tabView tabViewItemAtIndex: i] view];
				dic[@"Tab"] = tabs[i];
				[AZNOTCENTER postNotificationName:@"DBTabSelected"
																	object:nil
																  userInfo:dic];
				[dic release];
			}
			else
			{
				[currentTab setSelected: NO];
			}
		}		
	}
	
	if (refresh)
	{
		[tabBar setNeedsDisplay: YES];
	}
}
- (void) selectTabRight
{
	NSInteger		indexOfTabToSelect;
	DBTab*	tabToSelect			= nil;
	DBTab*	selectedTab			= [self selectedTab];
	NSInteger		indexOfSelectedTab	= [tabs indexOfObject: selectedTab];
	NSInteger		tabCount			= [tabs count];
	
	if (tabCount > 1)
	{
		if (indexOfSelectedTab != NSNotFound)
		{
			if (indexOfSelectedTab < tabCount - 1)
			{
				indexOfTabToSelect = indexOfSelectedTab + 1;
			}
			else
			{
				indexOfTabToSelect = 0;
			}
			
			tabToSelect = tabs[indexOfTabToSelect];
			
			if (tabToSelect)
			{
				[self selectTab: tabToSelect refresh: YES];
			}
		}
	}
}
- (void) selectTabLeft
{
	NSInteger		indexOfTabToSelect;
	DBTab*	tabToSelect			= nil;
	DBTab*	selectedTab			= [self selectedTab];
	NSInteger		indexOfSelectedTab	= [tabs indexOfObject: selectedTab];
	NSInteger		tabCount			= [tabs count];
	
	if (tabCount > 1)
	{
		if (indexOfSelectedTab != NSNotFound)
		{
			if (indexOfSelectedTab > 0)
			{
				indexOfTabToSelect = indexOfSelectedTab - 1;
			}
			else
			{
				indexOfTabToSelect = tabCount - 1;
			}
			
			tabToSelect = tabs[indexOfTabToSelect];
			
			if (tabToSelect)
			{
				[self selectTab: tabToSelect refresh: YES];
			}
		}
	}
}
- (DBTab *)selectedTab {
	DBTab		*currentTab = nil;
	DBTab		*returnTab	= nil;
	NSInteger i;
	for(i = 0; i < [tabs count]; i++) {
		currentTab = tabs[i];
		
		if (currentTab != nil) {
			if ([currentTab selected]) {
				returnTab = currentTab;
				break;
			}
		}
	}
	return returnTab;
}
- (DBTab*) tabWithWebView: (WebView*) webView
{
	DBTab*	tabWithWebView	= nil;
	DBTab*	currentTab		= nil;
	
	NSInteger i;
	for(i = 0; i < [tabs count]; i++)
	{
		if (webView == [[tabView tabViewItemAtIndex: i] view])
		{
			tabWithWebView = tabs[i];
			break;
		}
	}
	
	return tabWithWebView;
}
- (NSI)tabCount {
	return [tabs count];
}
- (void)reloadTab {
	DBTab *sel = [self selectedTab];
	NSInteger i;
	NSInteger index = -1;
	for (i=0; i<[tabs count]; i++) {
		if (sel == tabs[i]) {
			index = i;
			break;
		}
	}
	
	if (index != -1) {
		WebView *wv = [[tabView tabViewItemAtIndex:index] view];
		[wv reload:self];
	}
}
- (void)reloadAllTabs {
	NSInteger i;
	WebView *wv;
	for (i=0; i<[tabs count]; i++) {
		wv = [[tabView tabViewItemAtIndex:i] view];
		[wv reload:self];
	}
}
- (void) frameDidChange
{
	[self updateTabSize];
	
	NSEnumerator*	tabEnumerator	= [tabs objectEnumerator];
	DBTab*			currentTab		= nil;
	
	while ((currentTab = [tabEnumerator nextObject]) != nil)
	{
		[currentTab resetTrackingRect];
	}
}
@end
