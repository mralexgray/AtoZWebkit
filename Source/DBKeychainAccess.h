/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
#import <Cocoa/Cocoa.h>

@interface DBKeychainAccess : NSObject
{
}
+ (DBKeychainAccess*) keychainAccess;
- (BOOL) getKeychainWithName: (NSS*) name account: (NSS*) account keychainItem: (SecKeychainItemRef*) keychainItem;
- (BOOL) addNewKeychainItemWithName: (NSS*) name account: (NSS*) account password: (NSS*) password;
- (NSS*) passwordFromKeychainWithName: (NSS*) keychainName account: (NSS*) account;
- (NSS*) passwordFromKeychainItem: (SecKeychainItemRef) keychainItem;
@end