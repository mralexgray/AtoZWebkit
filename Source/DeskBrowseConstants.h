/*
*****************************
The DeskBrowse source code is the legal property of its developers, Joel Levin and Ian Elseth
*****************************
*/
extern	NSS*	kPathOfDeskBrowseFolder;
extern	NSS*	kShowMenuBarAndDock;
extern  NSS*	kShowMenuExtra;
extern	NSS*	kCheckForUpdates;
extern	NSS*	kHomePage;
extern	NSS*	kLoadHomePageOnLaunch;
extern	NSS*	kBrowserMode;
extern	NSS*	kHotkey;
extern	NSS*	kAllowJavaScript;
extern	NSS*	kAllowJava;
extern	NSS*	kAllowImages;
extern	NSS*	kAllowAnimatedImages;
extern	NSS*	kAllowPluginMedia;
extern	NSS*	kSelectNewTabs;
extern	NSS*	kWebsposePassword;
extern	NSS*	kWebsposeHotKey;
extern	NSS*	kWebsposeModifiers;


extern  NSS*	kSliderBGColor;

extern	NSS*	kSlideBrowseHotKey;
extern	NSS*	kSlideBrowseModifiers;
extern	NSS*	kSlideWindowX;
extern	NSS*	kSlideWindowY;
extern	NSS*	kSlideWindowWidth;
extern	NSS*	kSlideWindowHeight;
extern	NSS*	kBlockPopupWindows;
extern  NSS*	kBlockWebAds;
extern  NSS*	kDownloadLocation;
extern  NSS*	kFirstRun;
extern	NSS*	kPathToDefaultPrefsFile;
extern  CGFloat		kCurrentVersionNumber;

typedef NS_ENUM(NSUInteger, KeyCombination) {
//typedef enum _KeyCombination {
	kCommandRightArrow,
	kCommandLeftArrow,
	kCommandShiftRightArrow,
	kCommandShiftLeftArrow,
};
// KeyCombination;