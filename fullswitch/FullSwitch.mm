#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKPersonCell.h>
#import <SettingsKit/SKSharedHelper.h>
#import <SettingsKit/SKTintedCell.h>
#import <MessageUI/MFMailComposeViewController.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>

#define FS_TINTCOLOR [UIColor colorWithRed:246/255.0 green:99/255.0 blue:70/255.0 alpha:1.0]

@interface FullSwitchListController : SKTintedListController<SKListControllerProtocol, MFMailComposeViewControllerDelegate>

@end

@implementation FullSwitchListController

CGRect screenRect = [[UIScreen mainScreen] bounds];
int indicMax = (screenRect.size.height - 64);
int indicHalf = (indicMax/2);
int landIndicMax = (screenRect.size.width - 64);
int landIndicHalf = (landIndicMax/2);
-(UIColor*) navigationTintColor { return FS_TINTCOLOR; }
-(UIColor*) switchOnTintColor { return self.navigationTintColor; }
-(UIColor*) iconColor { return self.navigationTintColor; }
-(BOOL) tintNavigationTitleText { return NO; }
-(NSString*) shareMessage { return @"Make your App Switcher bigger with #FullSwitch by @xTM3x"; }
-(NSArray*) customSpecifiers
{
    return @[
             @{
                 @"cell": @"PSGroupCell",
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"key": @"enabled",
                 @"icon": @"enabled.png",
                 @"label": @"Enabled",
                 //@"PostNotification": @"FullSwitch/prefsChanged",
                 @"cellClass": @"SKTintedSwitchCell"
                 },
             /*@{
                 @"cell": @"PSButtonCell",
                 @"action": @"respring",
                 @"label": @"Respring",
                 @"cellClass": @"SKTintedCell",
                 },*/
             @{
                 @"cell": @"PSGroupCell",
                 @"footerText": @"Customize the indicators present in the app switcher.",
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"label": @"Multitasking Indicator",
                 @"key": @"indic",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"indic.png",
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"detail": @"FSIndicatorController",
                 @"label": @"Customize",
                 @"icon": @"brush.png",
                 //@"cellClass": @"SKTintedCell",
                 },
             /*@{
                 @"cell": @"PSLinkListCell",
                 @"default": @"0",
                 @"detail": @"FSPickerController",
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"key": @"indicLocation",
                 @"label": @"Indicator Location",
                 @"validTitles": @[@"Top", @"Middle", @"Bottom",],
                 @"validValues": @[@"1", @"0", @"2",],
                 },*/
             @{
                 @"cell": @"PSGroupCell",
                 @"footerText": @"Swipe up on the homescreen card to view the menu.  Homescreen menu is not avalible in landscape.",
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"label": @"Homescreen Menu",
                 @"key": @"menu",
                 @"icon": @"home.png",
                 @"cellClass": @"SKTintedSwitchCell"
                 },
             @{
                 @"cell": @"PSGroupCell",
                 @"footerText": @"Blur the in-app previews inside of the switcher.  Use the slider to adjust the blur level.",
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @NO,
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"label": @"Privacy Mode",
                 @"key": @"priv",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"bino.png",
                 },
             @{
                 @"cell": @"PSSliderCell",
                 @"default": @10,
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"key": @"privblur",
                 @"max": @20,
                 @"min": @1,
                 @"showValue": @YES,
                 },
             @{  
                 @"cell": @"PSGroupCell",
                 @"footerText": @"Reset FullSwitch's settings to their defaults."
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"action": @"reset",
                 @"label": @"Reset",
                 @"icon": @"reset.png",
                 //@"cellClass": @"SKTintedControlCell"
                 },
             @{  
                 @"cell": @"PSGroupCell"
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"action": @"helpMe",
                 @"label": @"Support",
                 @"icon": @"support.png",
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"detail": @"FSCreditsController",
                 @"label": @"Credits",
                 @"icon": @"makers.png",
                 //@"cellClass": @"SKTintedCell",
                 },
             ];
}
-(void) helpMe
{
    MFMailComposeViewController *mailViewController;
    if ([MFMailComposeViewController canSendMail])
    {
        mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"FullSwitch"];
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *sysInfo = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        [mailViewController addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile/Library/Preferences/com.xtm3x.fullswitch.plist"] mimeType:@"application/xml" fileName:@"Preferences"];
        NSString *msg = [NSString stringWithFormat:@"\n\n\n- Please do not edit below this line -\n%@ running %@\n", sysInfo, [UIDevice currentDevice].systemVersion];
        [mailViewController setMessageBody:msg isHTML:NO];
        [mailViewController setToRecipients:@[@"xtm3xyt@gmail.com"]];
            
        [self.rootController presentViewController:mailViewController animated:YES completion:nil];
    }

}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)reset {
    CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)@"com.xtm3x.fullswitch", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSetMultiple ( NULL, keyList, (__bridge CFStringRef)@"com.xtm3x.fullswitch", kCFPreferencesCurrentUser, kCFPreferencesAnyHost );
    UIAlertView *alert =[[UIAlertView alloc ] initWithTitle:@"Complete!"
                                                    message:[NSString stringWithFormat:@"You will need to respring to apply your changes."]
                                                   delegate:self
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Respring"];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //who are you, the declaration declarer?
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        system("killall -9 backboardd");
        #pragma clang diagnostic pop
    }
}
@end

@interface FSIndicatorController : SKTintedListController<SKListControllerProtocol>{
    
}
@end

@implementation FSIndicatorController

-(UIColor*) navigationTintColor { return FS_TINTCOLOR; }
-(UIColor*) switchOnTintColor { return self.navigationTintColor; }
-(BOOL) tintNavigationTitleText { return NO; }
-(BOOL) showHeartImage { return NO; }
-(NSArray*) customSpecifiers
{
    return @[
             @{  @"cell": @"PSGroupCell",
                 @"label": @"Portrait Location",
                 @"footerText": @"This modifies the vertical location of the portrait indicators.  You may tap the value on the right to see a preview."
                 },
             @{
                 @"cell": @"PSSliderCell",
                 @"default": @(indicHalf),
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"action": @"preview",
                 @"key": @"indicLocation",
                 @"max": @(indicMax),
                 @"min": @0,
                 @"showValue": @YES,
                 },
             @{  @"cell": @"PSGroupCell",
                 @"label": @"landscape Location",
                 @"footerText": @"This modifies the vertical location of the landscape indicators.  Open the switcher from a lanscape app to see a preview."
                 },
             @{
                 @"cell": @"PSSliderCell",
                 @"default": @(landIndicHalf),
                 @"defaults": @"com.xtm3x.fullswitch",
                 @"key": @"landIndicLocation",
                 @"max": @(landIndicMax),
                 @"min": @0,
                 @"showValue": @YES,
                 },
             ];
}
-(void)preview {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.xtm3x.fullswitch.plist"]];
    UIImageView *indicatorView = [[UIImageView alloc] init];//WithFrame:CGRectMake(0,yValue,64,64)];
    UIImageView *indicatorViewRight = [[UIImageView alloc] init];//WithFrame:CGRectMake(256,yValue,64,64)];
    UIWindow *settingsView;
    CGFloat indicLocation = [dict objectForKey:@"indicLocation"] ? [[dict objectForKey:@"indicLocation"] floatValue] : indicHalf;
    settingsView = [[UIApplication sharedApplication] keyWindow];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat R = (screenRect.size.width - (64*2));   
    CGFloat one = (R/1);
    NSNumber *byOne = [NSNumber numberWithFloat:one];
    //CGFloat H = (screenRect.size.height - 64);
    //CGFloat two = (H/2);
    NSNumber *byTwo = [NSNumber numberWithFloat:indicLocation];
    indicatorView.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSLeft.png"];
    indicatorViewRight.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSRight.png"];
    [settingsView addSubview:indicatorView];         
    [settingsView addSubview:indicatorViewRight];
    [indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [indicatorViewRight setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *indicView = @{@"indicLeft": indicatorView, @"indicRight": indicatorViewRight};
    NSDictionary *metrics = @{@"oneDis": byOne, @"twoHigh": byTwo};
    NSArray *lindicvConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-twoHigh-[indicLeft(==64)]-|" options:0 metrics:metrics views:indicView];
    NSArray *rindicvConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-twoHigh-[indicRight(==64)]-|" options:0 metrics:metrics views:indicView];
    NSArray *indichConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[indicLeft(==64)]-oneDis-[indicRight(==64)]-|" options:0 metrics:metrics views:indicView];
    [settingsView addConstraints:lindicvConstraints];
    [settingsView addConstraints:rindicvConstraints];
    [settingsView addConstraints:indichConstraints];
    indicatorView.hidden = NO;
    indicatorViewRight.hidden = NO;
    indicatorView.alpha = 1.0f;
    indicatorViewRight.alpha = 1.0f;
    [UIView animateWithDuration:4 delay:1 options:0 animations:^{
    indicatorView.alpha = 0.0f;
    indicatorViewRight.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [indicatorView removeFromSuperview];
        [indicatorViewRight removeFromSuperview];
    }];
}
@end

@interface FSCreditsController : SKTintedListController<SKListControllerProtocol>{
    
}
@end
@interface FSTM3PersonCell : SKPersonCell
@end

@implementation FSTM3PersonCell
-(NSString*)personDescription { return @"Developer"; }
-(NSString*)name { return @"xTheMaster3x"; }
-(NSString*)imageName { return @"xtm3x.png"; }
@end
@interface FSDeckePersonCell : SKPersonCell
@end

@implementation FSDeckePersonCell
-(NSString*)personDescription { return @"Designer"; }
-(NSString*)name { return @"Decke"; }
-(NSString*)imageName { return @"ddsg.png"; }
@end

@implementation FSCreditsController

-(UIColor*) navigationTintColor { return FS_TINTCOLOR; }
-(UIColor*) switchOnTintColor { return self.navigationTintColor; }
-(BOOL) tintNavigationTitleText { return NO; }
-(BOOL) showHeartImage { return NO; }
-(NSArray*) customSpecifiers
{
    return @[
             @{ @"cell": @"PSGroupCell" },
             @{
                 @"cell": @"PSLinkCell",
                 @"cellClass": @"FSTM3PersonCell",
                 @"height": @100,
                 @"action": @"xtm3x"
                 },
             @{ @"cell": @"PSGroupCell" },
             @{
                 @"cell": @"PSLinkCell",
                 @"cellClass": @"FSDeckePersonCell",
                 @"height": @100,
                 @"action": @"decke"
                 },
             @{
                 @"cell": @"PSGroupCell",
                 @"label": @"Special Thanks",
                 @"footerText": @"Others who contributed to FullSwitch."
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"label": @"@Nexuist",
                 @"icon": @"twitter.png",
                 @"action": @"nexuist",
                 @"cellClass": @"FSTintedLinkCell",
                 },
             @{
                 @"cell": @"PSLinkCell",
                 @"label": @"@DrewPlex",
                 @"icon": @"twitter.png",
                 @"action": @"drewplex",
                 @"cellClass": @"FSTintedLinkCell",
                 },
             ];
}
-(void) xtm3x
{
    [SKSharedHelper openTwitter:@"xTM3x"];
}
-(void) decke
{
    [SKSharedHelper openTwitter:@"deckedsg"];
}
-(void) nexuist
{
    [SKSharedHelper openTwitter:@"Nexuist"];
}
-(void) drewplex
{
    [SKSharedHelper openTwitter:@"DrewPlex"];
}
@end