/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBPlistUtils : NSObject {}
+ (void)setIsBackgroundApp:(BOOL)bgappflag;
+ (BOOL)isBackgroundApp;
+ (NSS*) plistFilePath;
+ (void)updateApp;
@end
