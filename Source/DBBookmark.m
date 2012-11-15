/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmark.h"

#import "DBBookmarkActionCell.h"
#import "DBBookmarkMenuCell.h"

NSS*	kDBLoadURLNotification			= @"DBLoadURLNotification";
NSS*	kDBDeleteBookmarkNotification	= @"DBDeleteBookmarkNotification";
NSS*	kBookmarkInfoURLStringKey		= @"URLString";
NSS*	kBookmarkInfoTitleKey			= @"TitleString";
NSS*	kBookmarkInfoMoreBookmarksKey	= @"Bookmarks";

@implementation DBBookmark

- (id) initWithDictionary: (NSD*) dictionary
{
	NSArray* subBookmarks = dictionary[kBookmarkInfoMoreBookmarksKey];
	
	if (subBookmarks != nil)
	{
		[self release];
		
		self = [[BookmarkFolder alloc] initWithDictionary: dictionary];
	}
	else
	{
		NSS*	urlString	= dictionary[kBookmarkInfoURLStringKey];
		NSURL*		url			= nil;
		NSS*	title		= dictionary[kBookmarkInfoTitleKey];
		
		if (urlString != nil)
		{
			url = [NSURL URLWithString: urlString];
		}
		
		self = [self initWithURL: url title: title];
	}
	
	return self;
}
- (id) initWithURL: (NSURL*) URL title: (NSS*) title
{
	NSR newFrame = NSMakeRect(0, 0, 100, 15);
	
	if (self = [super initWithFrame: newFrame])
	{
		mURL	= URL;
		mTitle	= title;
	}
	
	return self;
}
- (void) dealloc
{
	[mURL release];
	[mTitle release];
	
}
- (id) copyWithZone: (NSZone*) zone
{
	DBBookmark* copyOfSelf = [[DBBookmark alloc] init];
	NSLog(@"Copy!!!");
	[copyOfSelf setURL: mURL];
	[copyOfSelf setTitle: mTitle];
	
	return copyOfSelf;
}
- (void) load
{
	if (mURL != nil)
	{
		NSD* userInfo = @{kBookmarkInfoURLStringKey: [mURL absoluteString]};
		
		[AZNOTCENTER postNotificationName: kDBLoadURLNotification object: self userInfo: userInfo];
	}
}
- (void) remove
{
	[AZNOTCENTER postNotificationName: kDBDeleteBookmarkNotification object: self userInfo: nil];
}
- (NSMD*) dictionary
{
	NSMD* dictionary = nil;
	
	if (mTitle != nil)
	{
		dictionary = [NSMD dictionary];
		
		dictionary[kBookmarkInfoTitleKey] = mTitle;
		
		if (mURL != nil)
		{
			dictionary[kBookmarkInfoURLStringKey] = [mURL absoluteString];
		}
	}
	
	return dictionary;
}
- (NSURL*) URL
{
	return mURL;
}
- (void) setURL: (NSURL*) url
{
	if (url != mURL)
	{
		[mURL release];
		
		mURL = url;
	}
}
- (NSS*) URLString
{
	return [mURL absoluteString];
}
- (void) setURLString: (NSS*) urlString
{
	[mURL release];
	mURL = [NSURL URLWithString: urlString];
}
- (NSS*) title
{
	return mTitle;
}
- (void) setTitle: (NSS*) title
{
	if (title != mTitle)
	{
		[mTitle release];
		mTitle = [title copy];
		
		[mBookmarkBarCell setStringValue: mTitle];
	}
}

// -----------------------------
//
//	Bookmark Bar related
//
// -----------------------------
#pragma mark Bookmark Bar
- (id <DBBookmarkBarCell>) cell
{
	if (mBookmarkBarCell == nil)
	{
		mBookmarkBarCell = [[DBBookmarkActionCell alloc] initWithTarget: self action: @selector(load)];
		
		[mBookmarkBarCell setStringValue: mTitle];
	}
	
	return mBookmarkBarCell;
}


- (void) setUpMenu
{
	NSMenu*		bookmarkMenu	= [[NSMenu alloc] initWithTitle: @"Bookmark"];
	NSMenuItem*	loadMenuItem	= [[NSMenuItem alloc] initWithTitle: @"Load" action: @selector(load) keyEquivalent: @""];
	NSMenuItem*	deleteMenuItem	= [[NSMenuItem alloc] initWithTitle: @"Delete" action: @selector(remove) keyEquivalent: @""];
	
	[bookmarkMenu	addItem: loadMenuItem];
	[bookmarkMenu	addItem: deleteMenuItem];
	
	[self setMenu: bookmarkMenu];
	
	[bookmarkMenu release];
	[loadMenuItem release];
	[deleteMenuItem release];
}

#pragma mark Sorting
- (NSComparisonResult) compare: (DBBookmark*) otherBookmark
{
	NSComparisonResult result = NSOrderedSame;
	
	if (otherBookmark != nil)
	{
		NSS*	stringToCompare1	= mTitle;
		NSS*	stringToCompare2	= [otherBookmark title];
		
		if (stringToCompare1 == nil)
		{
			stringToCompare1 = [mURL absoluteString];
		}
		
		if (stringToCompare2 == nil)
		{
			stringToCompare2 = [[otherBookmark URL] absoluteString];
		}
		
		result = [stringToCompare1 caseInsensitiveCompare: stringToCompare2];
	}
	
	return result;
}

@end

@implementation BookmarkFolder

- (id) initWithDictionary: (NSD*) dictionary
{
	NSS* title = dictionary[kBookmarkInfoTitleKey];
	
	if (self = [super initWithURL: nil title: title])
	{
		NSArray*		subBookmarks		= dictionary[kBookmarkInfoMoreBookmarksKey];
		NSEnumerator*	bookmarkEnumerator	= [subBookmarks objectEnumerator];
		NSD*	currentInfoDict		= nil;
		
		while ((currentInfoDict = [bookmarkEnumerator nextObject]) != nil)
		{
			DBBookmark* newBookmark = [[DBBookmark alloc] initWithDictionary: currentInfoDict];
			
			[self addBookmark: newBookmark];
			
			[newBookmark release];
		}
	}
	
	return self;
}
- (void) dealloc
{
	[mContainedBookmarks release];
	
}

- (id) copyWithZone: (NSZone*) zone
{
	BookmarkFolder* copyOfSelf = [[BookmarkFolder alloc] init];
	NSLog(@"Folder copy: %@ %@", self, mTitle);
	[copyOfSelf setURL: mURL];
	[copyOfSelf setTitle: mTitle];
	[copyOfSelf setSubBookmarks: mContainedBookmarks];
	
	return copyOfSelf;
}

- (NSMD*) dictionary
{
	NSMD*	dictionary		= [super dictionary];
	NSMutableArray*			subBookmarks	= nil;
	
	if (dictionary != nil && mContainedBookmarks != nil)
	{
		subBookmarks						= [NSMutableArray array];
		NSEnumerator*	bookmarkEnumerator	= [mContainedBookmarks objectEnumerator];
		DBBookmark*		currentBookmark		= nil;
		
		while ((currentBookmark = [bookmarkEnumerator nextObject]) != nil)
		{
			NSD* bookmarkDictionaryInfo = [currentBookmark dictionary];
			
			if (bookmarkDictionaryInfo != nil)
			{
				[subBookmarks addObject: bookmarkDictionaryInfo];
			}
		}
		
		if (subBookmarks != nil && [subBookmarks count] > 0)
		{
			dictionary[kBookmarkInfoMoreBookmarksKey] = subBookmarks;
		}
	}
	
	return dictionary;
}

- (unsigned) numberOfBookmarks
{
	return [mContainedBookmarks count];
}

- (NSA*) subBookmarks
{
	return mContainedBookmarks;
}
- (void) setSubBookmarks: (NSA*) bookmarks
{
	if (bookmarks != mContainedBookmarks)
	{
		[mContainedBookmarks release];
		
		mContainedBookmarks = [bookmarks mutableCopy];
	}
}

- (void) addBookmark: (DBBookmark*) bookmark
{
	if (mContainedBookmarks == nil)
	{
		mContainedBookmarks = [[NSMutableArray alloc] init];
	}
	
	if (bookmark != nil)
	{
		[mContainedBookmarks addObject: bookmark];
		[self reloadCellMenu];
	}
}
- (void) removeBookmark: (DBBookmark*) bookmark
{
	if (bookmark != nil && mContainedBookmarks != nil)
	{
		[mContainedBookmarks removeObject: bookmark];
		[self reloadCellMenu];
	}
}

- (id <DBBookmarkBarCell>) cell
{
	if (mBookmarkBarCell == nil)
	{
		if ([mContainedBookmarks count] > 0)
		{
			mBookmarkBarCell = [[DBBookmarkMenuCell alloc] init];
			
			[self reloadCellMenu];
			
			[mBookmarkBarCell setStringValue: mTitle];
		}
	}
	
	return mBookmarkBarCell;
}
- (void) reloadCellMenu
{
	NSMenu*			cellMenu			= [[NSMenu alloc] initWithTitle: @""];
	NSEnumerator*	bookmarkEnumerator	= [mContainedBookmarks objectEnumerator];
	DBBookmark*		currentBookmark		= nil;
	
	[cellMenu addItem: [NSMenuItem separatorItem]];
	
	while ((currentBookmark = [bookmarkEnumerator nextObject]) != nil)
	{
		NSMenuItem*	bookmarkMenuItem = [[currentBookmark cell] menuItem];
		
		if (bookmarkMenuItem != nil)
		{
			[cellMenu addItem: bookmarkMenuItem];
		}
	}
	
	[mBookmarkBarCell setMenu: cellMenu];
	
	[cellMenu release];
}

@end