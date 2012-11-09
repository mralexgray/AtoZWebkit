/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/

#import "DBWebsposePassword.h"

#import "DBKeychainAccess.h"


static NSString* webpsosePasswordKeychainName		= @"DeskBrowse";
static NSString* webpsosePasswordKeychainAccount	= @"Webspose";

@implementation DBWebsposePassword


+ (NSString*) websposePassword
{
	NSString*		password = nil;
	DBKeychainAccess*	keychain = [DBKeychainAccess keychainAccess];
	
	
	// Get password from the keychain
	
	password = [keychain passwordFromKeychainWithName: webpsosePasswordKeychainName account: webpsosePasswordKeychainAccount];
		
	if (password == nil)
	{
		// Password wasn't in the keychain, so see if it's in the DeskBrowse preferences
		
		password = [[NSUserDefaults standardUserDefaults] stringForKey: kWebsposePassword];
	}
	
	return password;
}

+ (void) setWebsposePassword: (NSString*) password
{
	DBKeychainAccess* keychain = [DBKeychainAccess keychainAccess];
	
	
	// Save password to the keychain
	
	[keychain addNewKeychainItemWithName: webpsosePasswordKeychainName account: webpsosePasswordKeychainAccount password: password];
}


@end