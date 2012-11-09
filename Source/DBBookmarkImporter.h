/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import <Cocoa/Cocoa.h>


@interface DBBookmarkImporter : NSObject
{

}

+ (DBBookmarkImporter*) bookmarkImporter;
+ (BOOL) isURLEquivalent: (NSURL*) URL1 toURL: (NSURL*) URL2;

// Camino
- (NSString*) pathOfCaminoBookmarksFile;
- (NSA*) caminoBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processCaminoBookmarksFromDictionary: (NSD*) caminoDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;

// Firefox
- (NSString*) pathOfFirefoxBookmarksFile;
- (NSA*) firefoxBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;

// Mozilla
- (NSString*) pathOfMozillaBookmarksFile;
- (NSA*) mozillaBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (NSA*) mozillaBookmarksFromPath: (NSString*) filePath excludingBookmarks: (NSA*) excludedBookmarks;

// Safari
- (NSString*) pathOfSafariBookmarksFile;
- (NSA*) safariBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processSafariBookmarksFromDictionary: (NSD*) safariDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;

// Shiira
- (NSString*) pathOfShiiraBookmarksFile;
- (NSA*) shiiraBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processShiiraBookmarksFromDictionary: (NSD*) shiiraDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;

@end

@interface NSString (SGSURLHelper)

- (NSString*) stringByDeletingTrailingSlash;

@end