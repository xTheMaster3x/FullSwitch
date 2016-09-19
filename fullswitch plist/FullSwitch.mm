#include <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Twitter/Twitter.h>
#import "PSListController.h"

#define SB_TINTCOLOR [UIColor colorWithRed:246/255.0 green:99/255.0 blue:70/255.0 alpha:1.0]
#define URL_ENCODE(string) (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8)

@interface FullSwitchListController: PSListController {
}
@end

@implementation FullSwitchListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"FullSwitch" target:self] retain];
	}
	return _specifiers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = SB_TINTCOLOR;
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
    [[self navigationItem] setRightBarButtonItem:share];
}
- (void)viewWillAppear:(BOOL)animated{
	self.view.tintColor =
	self.navigationController.navigationBar.tintColor =
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = SB_TINTCOLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.view.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

- (void)shareTapped:(UIBarButtonItem *)sender {
    NSString *text = @"Magnify that App Switcher with FullSwitch by @xTM3x";

    if (%c(UIActivityViewController)) {
        UIActivityViewController *viewController = [[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, nil] applicationActivities:nil];
        [self.navigationController presentViewController:viewController animated:YES completion:NULL];
    }

    else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
        viewController.initialText = text;
        [self.navigationController presentViewController:viewController animated:YES completion:NULL];
    }

    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20", URL_ENCODE(text)]]];
    }
}
- (void)twitter {

    NSString * _user = @"xTM3x";

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:_user]]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:_user]]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:_user]]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:_user]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:_user]]];
    }
}
- (void)respring {
    system("killall -9 SpringBoard");
}

@end

// vim:ft=objc
