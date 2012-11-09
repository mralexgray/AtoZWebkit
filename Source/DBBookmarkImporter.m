/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import "DBBookmarkImporter.h"
#import "DBBookmark.h"
#import "DBHTMLParser.h"
#import "DBURLFormatter.h"

// Schemes
NSS* kFeedScheme								= @"feed";
NSS* kFileScheme								= @"file";
NSS* kHTTPScheme								= @"http";
NSS* kHTTPSScheme								= @"https";

// Camino
NSS* kPathOfCaminoBookmarksFile				= @"~/Library/Application Support/Camino/bookmarks.plist";
NSS* kCaminoChildrenKey						= @"Children";
NSS* kCaminoBookmarkURLStringKey				= @"URL";
NSS* kCaminoBookmarkTitleKey					= @"Title";

// Firefox
NSS* kPathOfFirefoxV8OrLessBookmarksDirectory	= @"~/Library/Phoenix/Profiles/default";
NSS* kPathOfFirefoxV9BookmarksDirectory		= @"~/Library/Application Support/Firefox/Profiles";
NSS* kNameOfFirefoxBookmarksFile				= @"bookmarks.html";
NSS* kPartOf9To10BookmarkDirectoryName			= @"default.";
NSS* kPartOf10UpBookmarkDirectoryName			= @".default";
NSS* kPartOf8OrLessBookmarkDirectoryName		= @".slt";

// Mozilla
NSS* kPathOfMozillaBookmarksDirectory			= @"~/Library/Mozilla/Profiles/default";
NSS* kNameOfMozillaBookmarksFile				= @"bookmarks.html";
NSS* kPartOfMozillaBookmarkDirectoryName		= @".slt";

// Safari
NSS* kPathOfSafariBookmarksFile				= @"~/Library/Safari/Bookmarks.plist";
NSS* kSafariWebBookmarkType					= @"WebBookmarkType";
NSS* kSafariWebBookmarkTypeList				= @"WebBookmarkTypeList";
NSS* kSafariWebBookmarkTypeLeaf				= @"WebBookmarkTypeLeaf";
NSS* kSafariChildrenKey						= @"Children";
NSS* kSafariBookmarkURIDictionaryKey			= @"URIDictionary";
NSS* kSafariBookmarkURLStringKey				= @"URLString";
NSS* kSafariBookmarkTitleKey					= @"title";

// Shiira
NSS* kPathOfShiiraBookmarksFile				= @"~/Library/Shiira/Bookmarks.plist";
NSS* kShiiraChildrenKey						= @"Children";
NSS* kShiiraBookmarkURLStringKey				= @"URLString";
NSS* kShiiraBookmarkTitleKey					= @"Title";

@implementation DBBookmarkImporter

+ (DBBookmarkImporter*) bookmarkImporter
{
	return [[[DBBookmarkImporter alloc] init] autorelease];
}
+ (BOOL) isURLEquivalent: (NSURL*) URL1 toURL: (NSURL*) URL2
{
	BOOL		equivalent	= NO;
	NSS*	scheme1		= [URL1 scheme];
	NSS*	scheme2		= [URL2 scheme];
	
	if ([scheme1 caseInsensitiveCompare: scheme2] == NSOrderedSame)
	{
		NSS* resSpec1 = [URL1 resourceSpecifier];
		NSS* resSpec2 = [URL2 resourceSpecifier];
		
		resSpec1 = [resSpec1 stringByDeletingTrailingSlash];
		resSpec2 = [resSpec2 stringByDeletingTrailingSlash];
				
		if ([resSpec1 caseInsensitiveCompare: resSpec2] == NSOrderedSame)
		{
			equivalent = YES;
		}
	}
	
	return equivalent;
}

#pragma mark Camino
- (NSS*) pathOfCaminoBookmarksFile
{
	NSS*		pathOfCaminoBookmarksFile	= [kPathOfCaminoBookmarksFile stringByExpandingTildeInPath];
	NSFileManager*	fileManager					= [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: pathOfCaminoBookmarksFile])
	{
		pathOfCaminoBookmarksFile = nil;
	}
	
	return pathOfCaminoBookmarksFile;
}
- (NSA*) caminoBookmarksExcludingBookmarks: (NSA*) excludedBookmarks
{
	NSMutableArray* caminoBookmarks				= [NSMutableArray array];
	NSS*		pathOfCaminoBookmarksFile	= [self pathOfCaminoBookmarksFile];
	
	excludedBookmarks = [excludedBookmarks mutableCopy];
	
	if (pathOfCaminoBookmarksFile != nil)
	{
		NSD* caminoBookmarkDictionary = [NSD dictionaryWithContentsOfFile: pathOfCaminoBookmarksFile];
		
		if (caminoBookmarkDictionary != nil)
		{
			[self processCaminoBookmarksFromDictionary: caminoBookmarkDictionary intoArray: caminoBookmarks excludingBookmarks: excludedBookmarks];
		}
	}
	
	[excludedBookmarks release];
	
	return caminoBookmarks;
}
- (void) processCaminoBookmarksFromDictionary: (NSD*) caminoDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks
{
	NSArray* children = caminoDictionary[kCaminoChildrenKey];
	
	if (children != nil)
	{
		// Loop through dictionaries in list and process them
		
		NSEnumerator*	childrenEnumerator	= [children objectEnumerator];
		NSD*	currentChild		= nil;
		
		while ((currentChild = [childrenEnumerator nextObject]) != nil)
		{
			[self processCaminoBookmarksFromDictionary: currentChild intoArray: bookmarkStorage excludingBookmarks: excludedBookmarks];
		}
	}
	else
	{
		// Create Bookmark from info
		
		NSS*		bookmarkTitle	= caminoDictionary[kCaminoBookmarkTitleKey];
		NSS*		URLString		= caminoDictionary[kCaminoBookmarkURLStringKey];
		
		if (URLString != nil)
		{
			NSURL* bookmarkURL = [NSURL URLWithString: URLString];
			
			if (bookmarkTitle != nil && bookmarkURL != nil)
			{
				//
				// We're not adding URLs of the "feed" scheme. I think it's RSS, which we don't have yet.
				//
				BOOL		isFeedScheme	= NO;
				NSS*	bookmarkScheme	= [bookmarkURL scheme];
				
				isFeedScheme = ([bookmarkScheme caseInsensitiveCompare: kFeedScheme] == NSOrderedSame);
				//
				//
				
				if (!isFeedScheme)
				{
					DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: bookmarkURL title: bookmarkTitle];
					
					if (newBookmark != nil)
					{
						BOOL			addBookmark					= YES;
						NSEnumerator*	excludedBookmarkEnumerator	= [excludedBookmarks objectEnumerator];
						DBBookmark*		currentExcludedBookmark		= nil;
						
						while ((currentExcludedBookmark = [excludedBookmarkEnumerator nextObject]) != nil)
						{
							if ([DBBookmarkImporter isURLEquivalent: bookmarkURL toURL: [currentExcludedBookmark URL]])
							{
								addBookmark = NO;
								break;
							}
						}
						
						if (addBookmark)
						{
							[bookmarkStorage addObject: newBookmark];
							[(NSMA*)excludedBookmarks addObject: newBookmark];
						}
						
						[newBookmark release];
						newBookmark = nil;
					}
				}
			}
		}
	}
}

#pragma mark Firefox
- (NSS*) pathOfFirefoxBookmarksFile
{
	NSS*		pathOfFirefoxBookmarksFile		= nil;
	NSS*		pathOfFirefoxBookmarksDirectory	= [kPathOfFirefoxV9BookmarksDirectory stringByExpandingTildeInPath];
	NSFileManager*	fileManager						= [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath: pathOfFirefoxBookmarksDirectory])
	{
		// Firefox V 0.9 or later
		// Enumerate bookmarks directory for bookmark folder
		
		NSArray*		contentsOfBookmarkDirectory		= [fileManager directoryContentsAtPath: pathOfFirefoxBookmarksDirectory];
		NSEnumerator*	bookmarksDirectoryEnumerator	= [contentsOfBookmarkDirectory objectEnumerator];
		NSS*		currentFileName					= nil;
		BOOL			foundBookmarkFolder				= NO;
		
		while ((currentFileName = [bookmarksDirectoryEnumerator nextObject]) != nil)
		{
			NSRange rangeOf9To10String	= [currentFileName rangeOfString: kPartOf9To10BookmarkDirectoryName];
			NSRange rangeOf10UpString	= [currentFileName rangeOfString: kPartOf10UpBookmarkDirectoryName];
			
			if (rangeOf9To10String.location != NSNotFound || rangeOf10UpString.location != NSNotFound)
			{
				foundBookmarkFolder = YES;
			}
			
			if (foundBookmarkFolder)
			{
				pathOfFirefoxBookmarksFile	= [pathOfFirefoxBookmarksDirectory stringByAppendingPathComponent: currentFileName];
				pathOfFirefoxBookmarksFile	= [pathOfFirefoxBookmarksFile stringByAppendingPathComponent: kNameOfFirefoxBookmarksFile];
				
				break;
			}
		}
	}
	else
	{
		// Firefox V 0.8.x or less
		// Enumerate bookmarks directory for bookmark folder
		
		pathOfFirefoxBookmarksDirectory	= [kPathOfFirefoxV8OrLessBookmarksDirectory stringByExpandingTildeInPath];
		
		NSArray*		contentsOfBookmarkDirectory		= [fileManager directoryContentsAtPath: pathOfFirefoxBookmarksDirectory];
		NSEnumerator*	bookmarksDirectoryEnumerator	= [contentsOfBookmarkDirectory objectEnumerator];
		NSS*		currentFileName					= nil;
		BOOL			foundBookmarkFolder				= NO;
		
		while ((currentFileName = [bookmarksDirectoryEnumerator nextObject]) != nil)
		{
			NSRange rangeOf8OrLessString = [currentFileName rangeOfString: kPartOf8OrLessBookmarkDirectoryName];
			
			if (rangeOf8OrLessString.location != NSNotFound)
			{
				foundBookmarkFolder = YES;
			}
			
			if (foundBookmarkFolder)
			{
				pathOfFirefoxBookmarksFile	= [pathOfFirefoxBookmarksDirectory stringByAppendingPathComponent: currentFileName];
				pathOfFirefoxBookmarksFile	= [pathOfFirefoxBookmarksFile stringByAppendingPathComponent: kNameOfFirefoxBookmarksFile];
				
				break;
			}
		}
	}
	
	if (![fileManager fileExistsAtPath: pathOfFirefoxBookmarksFile])
	{
		pathOfFirefoxBookmarksFile = nil;
	}
	
	return pathOfFirefoxBookmarksFile;
}
- (NSA*) firefoxBookmarksExcludingBookmarks: (NSA*) excludedBookmarks
{
	NSArray*	firefoxBookmarks			= [NSMutableArray array];
	NSS*	pathOfFirefoxBookmarksFile	= [self pathOfFirefoxBookmarksFile];
		
	if (pathOfFirefoxBookmarksFile != nil)
	{
		firefoxBookmarks = [self mozillaBookmarksFromPath: pathOfFirefoxBookmarksFile excludingBookmarks: excludedBookmarks];
	}
	
	return firefoxBookmarks;
}

#pragma mark Mozilla
- (NSS*) pathOfMozillaBookmarksFile
{
	NSS*		pathOfMozillaBookmarksFile		= nil;
	NSS*		pathOfMozillaBookmarksDirectory	= [kPathOfMozillaBookmarksDirectory stringByExpandingTildeInPath];
	NSFileManager*	fileManager						= [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath: pathOfMozillaBookmarksDirectory])
	{
		// Enumerate bookmarks directory for bookmark folder
		
		pathOfMozillaBookmarksDirectory	= [kPathOfMozillaBookmarksDirectory stringByExpandingTildeInPath];
		
		NSArray*		contentsOfBookmarkDirectory		= [fileManager directoryContentsAtPath: pathOfMozillaBookmarksDirectory];
		NSEnumerator*	bookmarksDirectoryEnumerator	= [contentsOfBookmarkDirectory objectEnumerator];
		NSS*		currentFileName					= nil;
		BOOL			foundBookmarkFolder				= NO;
		
		while ((currentFileName = [bookmarksDirectoryEnumerator nextObject]) != nil)
		{
			NSRange rangeOfPartString = [currentFileName rangeOfString: kPartOfMozillaBookmarkDirectoryName];
			
			if (rangeOfPartString.location != NSNotFound)
			{
				foundBookmarkFolder = YES;
			}
			
			if (foundBookmarkFolder)
			{
				pathOfMozillaBookmarksFile	= [pathOfMozillaBookmarksDirectory stringByAppendingPathComponent: currentFileName];
				pathOfMozillaBookmarksFile	= [pathOfMozillaBookmarksFile stringByAppendingPathComponent: kNameOfMozillaBookmarksFile];
				
				break;
			}
		}
	}
	
	if (![fileManager fileExistsAtPath: pathOfMozillaBookmarksFile])
	{
		pathOfMozillaBookmarksFile = nil;
	}
	
	return pathOfMozillaBookmarksFile;
}
- (NSA*) mozillaBookmarksExcludingBookmarks: (NSA*) excludedBookmarks
{
	NSArray*	mozillaBookmarks			= [NSMutableArray array];
	NSS*	pathOfMozillaBookmarksFile	= [self pathOfMozillaBookmarksFile];
		
	if (pathOfMozillaBookmarksFile != nil)
	{
		mozillaBookmarks = [self mozillaBookmarksFromPath: pathOfMozillaBookmarksFile excludingBookmarks: excludedBookmarks];
	}
	
	return mozillaBookmarks;
}
- (NSA*) mozillaBookmarksFromPath: (NSS*) filePath excludingBookmarks: (NSA*) excludedBookmarks
{
	NSMutableArray* bookmarks = [NSMutableArray array];
	
	excludedBookmarks = [excludedBookmarks mutableCopy];
	
	if (filePath != nil)
	{
		DBHTMLParser*		parser					= [DBHTMLParser HTMLParser];
		NSArray*		linksInFile				= [parser linksFromHTMLFileAtPath: filePath];
		NSEnumerator*	linkEnumerator			= [linksInFile objectEnumerator];
		NSD*	currentLinkDictionary	= nil;
		
		while ((currentLinkDictionary = [linkEnumerator nextObject]) != nil)
		{
			NSS*	linkTitle		= currentLinkDictionary[kLinkTitleKey];
			NSS*	linkURLString	= currentLinkDictionary[kLinkURLStringKey];
			NSURL*		bookmarkURL		= [NSURL URLWithString: linkURLString];
			
			if (linkTitle != nil && bookmarkURL != nil)
			{
				//
				// We're not adding URLs of the "feed" scheme. I think it's RSS, which we don't have yet.
				//
				BOOL		isFeedScheme	= NO;
				NSS*	bookmarkScheme	= [bookmarkURL scheme];
				
				isFeedScheme = ([bookmarkScheme caseInsensitiveCompare: kFeedScheme] == NSOrderedSame);
				//
				//
				
				if (!isFeedScheme)
				{
					DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: bookmarkURL title: linkTitle];
					
					if (newBookmark != nil)
					{
						BOOL			addBookmark					= YES;
						NSEnumerator*	excludedBookmarkEnumerator	= [excludedBookmarks objectEnumerator];
						DBBookmark*		currentExcludedBookmark		= nil;
						
						while ((currentExcludedBookmark = [excludedBookmarkEnumerator nextObject]) != nil)
						{
							if ([DBBookmarkImporter isURLEquivalent: bookmarkURL toURL: [currentExcludedBookmark URL]])
							{
								addBookmark = NO;
								break;
							}
						}
						
						if (addBookmark)
						{
							[bookmarks addObject: newBookmark];
							[(NSMA*)excludedBookmarks addObject: newBookmark];
						}
						
						[newBookmark release];
						newBookmark = nil;
					}
				}
			}
			
		}
	}
	
	[excludedBookmarks release];
	
	return bookmarks;
}

#pragma mark Safari
- (NSS*) pathOfSafariBookmarksFile
{
	NSS*		pathOfSafariBookmarksFile	= [kPathOfSafariBookmarksFile stringByExpandingTildeInPath];
	NSFileManager*	fileManager					= [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: pathOfSafariBookmarksFile])
	{
		pathOfSafariBookmarksFile = nil;
	}
	
	return pathOfSafariBookmarksFile;
}
- (NSA*) safariBookmarksExcludingBookmarks: (NSA*) excludedBookmarks
{	
	NSMutableArray* safariBookmarks				= [NSMutableArray array];
	NSS*		pathOfSafariBookmarksFile	= [self pathOfSafariBookmarksFile];
	
	excludedBookmarks = [excludedBookmarks mutableCopy];
	
	if (pathOfSafariBookmarksFile != nil)
	{
		NSD* safariBookmarkDictionary = [NSD dictionaryWithContentsOfFile: pathOfSafariBookmarksFile];
		
		if (safariBookmarkDictionary != nil)
		{
			[self processSafariBookmarksFromDictionary: safariBookmarkDictionary intoArray: safariBookmarks excludingBookmarks: excludedBookmarks];
		}
	}
	
	[excludedBookmarks release];
	
	return safariBookmarks;
}
- (void) processSafariBookmarksFromDictionary: (NSD*) safariDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks
{
	NSS* webBookmarkType = safariDictionary[kSafariWebBookmarkType];
	
	if ([webBookmarkType isEqualToString: kSafariWebBookmarkTypeList])
	{
		// Loop through dictionaries in list and process them
		
		NSArray*		children			= safariDictionary[kSafariChildrenKey];
		NSEnumerator*	childrenEnumerator	= [children objectEnumerator];
		NSD*	currentChild		= nil;
		
		while ((currentChild = [childrenEnumerator nextObject]) != nil)
		{
			[self processSafariBookmarksFromDictionary: currentChild intoArray: bookmarkStorage excludingBookmarks: excludedBookmarks];
		}
	}
	else if ([webBookmarkType isEqualToString: kSafariWebBookmarkTypeLeaf])
	{
		// Create Bookmark from info
		
		NSD*	URIDictionary	= safariDictionary[kSafariBookmarkURIDictionaryKey];
		NSS*		bookmarkTitle	= URIDictionary[kSafariBookmarkTitleKey];
		NSS*		URLString		= safariDictionary[kSafariBookmarkURLStringKey];
		
		if (URLString != nil)
		{
			NSURL* bookmarkURL = [NSURL URLWithString: URLString];
			
			if (bookmarkTitle != nil && bookmarkURL != nil)
			{
				//
				// We're not adding URLs of the "feed" scheme. I think it's RSS, which we don't have yet.
				//
				BOOL		isFeedScheme	= NO;
				NSS*	bookmarkScheme	= [bookmarkURL scheme];
				
				isFeedScheme = ([bookmarkScheme caseInsensitiveCompare: kFeedScheme] == NSOrderedSame);
				//
				//
				
				if (!isFeedScheme)
				{
					DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: bookmarkURL title: bookmarkTitle];
					
					if (newBookmark != nil)
					{
						BOOL			addBookmark					= YES;
						NSEnumerator*	excludedBookmarkEnumerator	= [excludedBookmarks objectEnumerator];
						DBBookmark*		currentExcludedBookmark		= nil;
						
						while ((currentExcludedBookmark = [excludedBookmarkEnumerator nextObject]) != nil)
						{
							if ([DBBookmarkImporter isURLEquivalent: bookmarkURL toURL: [currentExcludedBookmark URL]])
							{
								addBookmark = NO;
								break;
							}
						}
						
						if (addBookmark)
						{
							[bookmarkStorage addObject: newBookmark];
							[(NSMA*)excludedBookmarks addObject: newBookmark];
						}
						
						[newBookmark release];
						newBookmark = nil;
					}
				}
			}
		}
	}
}

#pragma mark Shiira
- (NSS*) pathOfShiiraBookmarksFile
{
	NSS*		pathOfShiiraBookmarksFile	= [kPathOfShiiraBookmarksFile stringByExpandingTildeInPath];
	NSFileManager*	fileManager					= [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: pathOfShiiraBookmarksFile])
	{
		pathOfShiiraBookmarksFile = nil;
	}
	
	return pathOfShiiraBookmarksFile;
}
- (NSA*) shiiraBookmarksExcludingBookmarks: (NSA*) excludedBookmarks
{
	NSMutableArray* shiiraBookmarks				= [NSMutableArray array];
	NSS*		pathOfShiiraBookmarksFile	= [self pathOfShiiraBookmarksFile];
	
	excludedBookmarks = [excludedBookmarks mutableCopy];
	
	if (pathOfShiiraBookmarksFile != nil)
	{
		NSD* shiiraBookmarkDictionary = [NSD dictionaryWithContentsOfFile: pathOfShiiraBookmarksFile];
		
		if (shiiraBookmarkDictionary != nil)
		{
			[self processShiiraBookmarksFromDictionary: shiiraBookmarkDictionary intoArray: shiiraBookmarks excludingBookmarks: excludedBookmarks];
		}
	}
	
	[excludedBookmarks release];
	
	return shiiraBookmarks;
}
- (void) processShiiraBookmarksFromDictionary: (NSD*) shiiraDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks
{
	NSArray* children = shiiraDictionary[kShiiraChildrenKey];
	
	if (children != nil)
	{
		// Loop through dictionaries in list and process them
		
		NSEnumerator*	childrenEnumerator	= [children objectEnumerator];
		NSD*	currentChild		= nil;
		
		while ((currentChild = [childrenEnumerator nextObject]) != nil)
		{
			[self processShiiraBookmarksFromDictionary: currentChild intoArray: bookmarkStorage excludingBookmarks: excludedBookmarks];
		}
	}
	else
	{
		// Create Bookmark from info
		
		NSS*		bookmarkTitle	= shiiraDictionary[kShiiraBookmarkTitleKey];
		NSS*		URLString		= shiiraDictionary[kShiiraBookmarkURLStringKey];
		
		if (URLString != nil)
		{
			NSURL* bookmarkURL = [NSURL URLWithString: URLString];
			
			if (bookmarkTitle != nil && bookmarkURL != nil)
			{
				//
				// We're not adding URLs of the "feed" scheme. I think it's RSS, which we don't have yet.
				//
				BOOL		isFeedScheme	= NO;
				NSS*	bookmarkScheme	= [bookmarkURL scheme];
				
				isFeedScheme = ([bookmarkScheme caseInsensitiveCompare: kFeedScheme] == NSOrderedSame);
				//
				//
				
				if (!isFeedScheme)
				{
					DBBookmark* newBookmark = [[DBBookmark alloc] initWithURL: bookmarkURL title: bookmarkTitle];
					
					if (newBookmark != nil)
					{
						BOOL			addBookmark					= YES;
						NSEnumerator*	excludedBookmarkEnumerator	= [excludedBookmarks objectEnumerator];
						DBBookmark*		currentExcludedBookmark		= nil;
						
						while ((currentExcludedBookmark = [excludedBookmarkEnumerator nextObject]) != nil)
						{
							if ([DBBookmarkImporter isURLEquivalent: bookmarkURL toURL: [currentExcludedBookmark URL]])
							{
								addBookmark = NO;
								break;
							}
						}
						
						if (addBookmark)
						{
							[bookmarkStorage addObject: newBookmark];
							[(NSMA*)excludedBookmarks addObject: newBookmark];
						}
						
						[newBookmark release];
						newBookmark = nil;
					}
				}
			}
		}
	}
}

@end

@implementation NSString (SGSURLHelper)

- (NSS*) stringByDeletingTrailingSlash
{
	NSS* stringWithoutTrailingSlash = self;
	
	if ([self length] > 0)
	{
		NSRange rangeOfLastCharacter = NSMakeRange([self length] - 1, 1);
		
		if ([[self substringWithRange: rangeOfLastCharacter] isEqualToString: @"/"])
		{
			NSRange rangeExcludingLastCharacter = NSMakeRange(0, [self length] - 1);
			stringWithoutTrailingSlash = [self substringWithRange: rangeExcludingLastCharacter];
		}
	}
	
	return stringWithoutTrailingSlash;
}

@end