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
- (NSS*) pathOfCaminoBookmarksFile;
- (NSA*) caminoBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processCaminoBookmarksFromDictionary: (NSD*) caminoDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;
// Firefox
- (NSS*) pathOfFirefoxBookmarksFile;
- (NSA*) firefoxBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
// Mozilla
- (NSS*) pathOfMozillaBookmarksFile;
- (NSA*) mozillaBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (NSA*) mozillaBookmarksFromPath: (NSS*) filePath excludingBookmarks: (NSA*) excludedBookmarks;
// Safari
- (NSS*) pathOfSafariBookmarksFile;
- (NSA*) safariBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processSafariBookmarksFromDictionary: (NSD*) safariDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;
// Shiira
- (NSS*) pathOfShiiraBookmarksFile;
- (NSA*) shiiraBookmarksExcludingBookmarks: (NSA*) excludedBookmarks;
- (void) processShiiraBookmarksFromDictionary: (NSD*) shiiraDictionary intoArray: (NSMA*) bookmarkStorage excludingBookmarks: (NSA*) excludedBookmarks;
@end
@interface NSString (SGSURLHelper)
- (NSS*) stringByDeletingTrailingSlash;
@end