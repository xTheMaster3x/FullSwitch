#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "substrate.h"
//#import <SpringBoard/SBApplicationIcon.h>
//#import <SpringBoard/SBUIController.h>*/
#import "CKBlurView.h"
//#import "SBAppSwitcherController.h"
//#import "SBDisplayItem.h"

@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
-(CGFloat)blurRadius;
-(void)setBlurRadius:(CGFloat)arg1;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(long long)arg1 ;
@end

@interface SpringBoard
-(void)_rebootNow;
-(void)_relaunchSpringBoardNow;
@end

@interface SBApplication
- (id)bundleIdentifier;
@end

@interface SBAppSliderSnapshotView {
    UIImageView *_snapshotImage;
}
@property(retain, nonatomic) SBApplication *application;
+(id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(int)arg2 loadAsync:(BOOL)arg3 withQueue:(id)arg4 statusBarCache:(id)arg5;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (id)_appSwitcherController;
@end

@interface SBDisplayItem : NSObject
@property(readonly, assign, nonatomic) NSString* displayIdentifier;
@property(readonly, assign, nonatomic) NSString* type;
+ (id)displayItemWithType:(NSString*)type displayIdentifier:(id)identifier;
- (id)initWithType:(NSString*)type displayIdentifier:(id)identifier;
@end

@interface SBDisplayLayout : NSObject
@property(readonly, assign, nonatomic) NSArray* displayItems;
@end

@interface SBAppSwitcherIconController : UIViewController
@end

@interface SBAppSwitcherController : UIViewController
{
	SBAppSwitcherIconController* _iconController;
}
-(id)getSelf;
-(id)getIconController;
-(void)_quitAppWithDisplayItem:(SBDisplayItem *)displayItem;
-(void)forceDismissAnimated:(BOOL)animated;
-(void)killAllApps;
-(CGFloat)_scaleForFullscreenPageView;
@end

@interface SBAppSwitcherPageViewController : UIViewController
-(void)setOffsetToIndex:(int)arg1 animated:(BOOL)arg2;
-(unsigned long long)currentPage;
@end