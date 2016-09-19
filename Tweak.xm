#import "FullSwitch.h"

BOOL enabled;
BOOL indicator;
BOOL menu;
BOOL animation;
BOOL privacy;
BOOL setTo1;
CGFloat indicLocation;
CGFloat landIndicLocation;
UIViewController *scrollerView;
UIViewController *iconScrollerView;
UIView *closeContainerView = [[UIView alloc] init];
UIView *springContainerView = [[UIView alloc] init];
UIView *bootContainerView = [[UIView alloc] init];
UIView *cancelContainerView = [[UIView alloc] init];
UIImageView *indicatorView = [[UIImageView alloc] init];
UIImageView *indicatorViewRight = [[UIImageView alloc] init];
UIImageView *menClose = [[UIImageView alloc] init];
UIImageView *menRespring = [[UIImageView alloc] init];
UIImageView *menReboot = [[UIImageView alloc] init];
UIImageView *menCancel = [[UIImageView alloc] init];
UILabel *closeLabel = [[UILabel alloc] init];
UILabel *springLabel = [[UILabel alloc] init];
UILabel *bootLabel = [[UILabel alloc] init];
UILabel *cancelLabel = [[UILabel alloc] init];
UIView *transView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2030];
_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
CGRect screenRect = [[UIScreen mainScreen] bounds];
CGFloat indicMax = (screenRect.size.height - 64);
CGFloat indicHalf = (indicMax/2);
CGFloat landIndicMax = (screenRect.size.width - 64);
CGFloat landIndicHalf = (landIndicMax/2);
int privblur;
UIColor *wcolor = [UIColor whiteColor];
UIColor *ccolor = [UIColor clearColor];

static void reloadPrefs()
{
	NSMutableDictionary *dict = (id)CFPreferencesCopyMultiple(CFPreferencesCopyKeyList (CFSTR("com.xtm3x.fullswitch"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost), CFSTR("com.xtm3x.fullswitch"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ;
	enabled = [dict objectForKey:@"enabled"] ? [[dict objectForKey:@"enabled"] boolValue] : TRUE;
	indicator = [dict objectForKey:@"indic"] ? [[dict objectForKey:@"indic"] boolValue] : TRUE;
	menu = [dict objectForKey:@"menu"] ? [[dict objectForKey:@"menu"] boolValue] : TRUE;
	animation = [dict objectForKey:@"anim"] ? [[dict objectForKey:@"anim"] boolValue] : TRUE;
	privacy = [[dict objectForKey:@"priv"] boolValue];
	indicLocation = [dict objectForKey:@"indicLocation"] ? [[dict objectForKey:@"indicLocation"] floatValue] : indicHalf;
	landIndicLocation = [dict objectForKey:@"landIndicLocation"] ? [[dict objectForKey:@"landIndicLocation"] floatValue] : landIndicHalf;
	privblur = [dict objectForKey:@"privblur"] ? [[dict objectForKey:@"privblur"] intValue] : 10;
	if (indicLocation > indicMax)
	{
		[dict setObject:[NSNumber numberWithFloat:indicMax] forKey:@"indicLocation"];
		[dict writeToFile:@"/var/mobile/Library/Preferences/com.xtm3x.fullswitch.plist" atomically:YES];
		reloadPrefs();
	}
	if (landIndicLocation > landIndicMax)
	{
		[dict setObject:[NSNumber numberWithFloat:landIndicMax] forKey:@"landIndicLocation"];
		[dict writeToFile:@"/var/mobile/Library/Preferences/com.xtm3x.fullswitch.plist" atomically:YES];
		reloadPrefs();
	}
}

%hook SBAppSwitcherSettings
-(int)switcherStyle {
	return 0;
}
-(void)setSwitcherStyle:(int)arg1 {
	%orig(0);
}
%end

%hook SBAppSwitcherController
-(void)switcherWasPresented:(BOOL)arg1 {
	reloadPrefs();
	if (enabled)
	{
		if (indicator)
		{
			%orig(arg1);
			CGRect screenRect = [[UIScreen mainScreen] bounds];
			CGFloat R = (screenRect.size.width - (64*2));
			CGFloat one = (R/1);
			NSNumber *byOne = [NSNumber numberWithFloat:one];
			//CGFloat H = (screenRect.size.height - 64);
			//CGFloat two = (H/2);
			NSNumber *byTwo = nil;
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) 
			{
				byTwo = [NSNumber numberWithFloat:indicLocation];
			} 
			else 
			{
				if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
				{
				   byTwo = [NSNumber numberWithFloat:landIndicLocation];
				}
			}
			#pragma clang diagnostic pop
			indicatorView.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSLeft.png"];
			indicatorViewRight.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSRight.png"];
			[[self view] addSubview:indicatorView];			
			[[self view] addSubview:indicatorViewRight];
			[indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
			[indicatorViewRight setTranslatesAutoresizingMaskIntoConstraints:NO];
			NSDictionary *indicView = @{@"indicLeft": indicatorView, @"indicRight": indicatorViewRight};
     		NSDictionary *metrics = @{@"oneDis": byOne, @"twoHigh": byTwo};
       		NSArray *lindicvConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-twoHigh-[indicLeft(==64)]-|" options:0 metrics:metrics views:indicView];
      		NSArray *rindicvConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-twoHigh-[indicRight(==64)]-|" options:0 metrics:metrics views:indicView];
      		NSArray *indichConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[indicLeft(==64)]-oneDis-[indicRight(==64)]-|" options:0 metrics:metrics views:indicView];
        	[[self view] addConstraints:lindicvConstraints];
        	[[self view] addConstraints:rindicvConstraints];
        	[[self view] addConstraints:indichConstraints];
			indicatorView.hidden = NO;
			indicatorView.alpha = 0.0f;
			indicatorViewRight.hidden = NO;
			indicatorViewRight.alpha = 0.0f;				
			[UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
			indicatorView.alpha = 1.0f;
			indicatorViewRight.alpha = 1.0f;
			} completion:^(BOOL finished) {
				
	     	}];
		}
		else
		{
			%orig;
		}
	}
	else
	{
		%orig;
	}
}
-(void)switcherWillBeDismissed:(BOOL)arg1 {
	reloadPrefs();
	if (enabled)
	{
		setTo1 = 0;
		indicatorView.hidden = NO;
		indicatorViewRight.hidden = NO;
		indicatorView.alpha = 1.0f;
		indicatorViewRight.alpha = 1.0f;
		[UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
		indicatorView.alpha = 0.0f;
		indicatorViewRight.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[menClose removeFromSuperview];
			[menRespring removeFromSuperview];
			[menReboot removeFromSuperview];
			[menCancel removeFromSuperview];
			[closeLabel removeFromSuperview];
			[springLabel removeFromSuperview];
			[bootLabel removeFromSuperview];
			[cancelLabel removeFromSuperview];
			[closeContainerView removeFromSuperview];
			[springContainerView removeFromSuperview];
			[bootContainerView removeFromSuperview];
			[cancelContainerView removeFromSuperview];
			[transView removeFromSuperview];
			[blurView removeFromSuperview];
			[indicatorView removeFromSuperview];
			[indicatorViewRight removeFromSuperview];
			}];
	}
	%orig(arg1);
}
-(BOOL)switcherIconScroller:(id)scroller shouldHideIconForDisplayLayout:(id)displayLayout {
	reloadPrefs();
	return %orig;
	if (enabled)
	{
		if (menu)
		{
			iconScrollerView = scroller;
		}
	}
}
-(BOOL)switcherScroller:(id)scroller isDisplayItemRemovable:(SBDisplayItem *)removable  {
	reloadPrefs();
	if (enabled)
	{
		if (menu)
		{
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) 
			{
				scrollerView = scroller;
				return [removable.displayIdentifier isEqualToString:@"com.apple.springboard"] ? YES : %orig;
			} 
			else 
			{
				if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
				{
				    return %orig;
				}
			}
			#pragma clang diagnostic pop
		}
		else
		{
			return %orig;
		}
	}
	else
	{
		return %orig;
	}
}
- (void)switcherScroller:(id)scroller displayItemWantsToBeRemoved:(SBDisplayItem *)beRemoved {
	reloadPrefs();
	if (enabled)
	{
		if (menu)
		{
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) 
			{
			    if ([beRemoved.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
					CGRect screenRect = [[UIScreen mainScreen] bounds];
					CGFloat four = ((screenRect.size.width - (89*3))/4);
					CGFloat two = ((screenRect.size.width - 89)/2);
					NSNumber *byTwo = [NSNumber numberWithFloat:two];
					NSNumber *byFour = [NSNumber numberWithFloat:four];
					//blurView.alpha = 0.0;
					[[self view] addSubview:transView];
					[transView addSubview:blurView];
					indicatorView.hidden = NO;
					indicatorViewRight.hidden = NO;
					indicatorView.alpha = 1.0f;
					indicatorViewRight.alpha = 1.0f;
					[UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
					indicatorView.alpha = 0.0f;
					indicatorViewRight.alpha = 0.0f;
					//blurView.alpha = 1.0;
					} completion:^(BOOL finished) {
						[indicatorView removeFromSuperview];
						[indicatorViewRight removeFromSuperview];
					}];
					closeLabel.text = @"Close Apps";
					springLabel.text = @"Respring";
					bootLabel.text = @"Reboot";
					cancelLabel.text = @"Cancel";
					closeLabel.textColor = wcolor;
					springLabel.textColor = wcolor;
					bootLabel.textColor = wcolor;
					cancelLabel.textColor = wcolor;
					cancelLabel.textAlignment = NSTextAlignmentCenter;
					bootLabel.textAlignment = NSTextAlignmentCenter;
					springLabel.textAlignment = NSTextAlignmentCenter;
					closeLabel.textAlignment = NSTextAlignmentCenter;
					menClose.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSClose.png"];
					menRespring.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSRespring.png"];
					menReboot.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSReboot.png"];
					menCancel.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/FSCancel.png"];
					[closeContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
					[springContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
					[bootContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
					[cancelContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
					[menClose setTranslatesAutoresizingMaskIntoConstraints:NO];
					[menRespring setTranslatesAutoresizingMaskIntoConstraints:NO];
					[menReboot setTranslatesAutoresizingMaskIntoConstraints:NO];
					[menCancel setTranslatesAutoresizingMaskIntoConstraints:NO];
					[closeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					[springLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					[bootLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					[cancelLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
					[closeContainerView addSubview:menClose];
					[springContainerView addSubview:menRespring];
					[bootContainerView addSubview:menReboot];
					[cancelContainerView addSubview:menCancel];
					[closeContainerView addSubview:closeLabel];
					[springContainerView addSubview:springLabel];
					[bootContainerView addSubview:bootLabel];
					[cancelContainerView addSubview:cancelLabel];
					[transView addSubview:closeContainerView];
					[transView addSubview:springContainerView];
					[transView addSubview:bootContainerView];
					[transView addSubview:cancelContainerView];
					NSDictionary *menView = @{@"leftContView": closeContainerView, @"centerContView": springContainerView, @"rightContView": bootContainerView, @"bottomContView": cancelContainerView, @"closeText": closeLabel, @"springText": springLabel, @"bootText": bootLabel, @"cancelText": cancelLabel, @"closeView": menClose, @"respringView": menRespring, @"rebootView": menReboot, @"cancelView": menCancel};
	      			NSDictionary *metrics = @{@"fourDis": byFour, @"twoDis": byTwo};
	      			NSArray *vLRootContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[leftContView(==93)]-|" options:0 metrics:nil views:menView];
	      			NSArray *vCRootContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[centerContView(==93)]-|" options:0 metrics:nil views:menView];
	      			NSArray *vRRootContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[rightContView(==93)]-|" options:0 metrics:nil views:menView];
	      			NSArray *vBRootContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bottomContView(==93)]-(10)-|" options:0 metrics:nil views:menView];
	      			NSArray *hContainers = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-fourDis-[leftContView(==89)]-fourDis-[centerContView(==89)]-fourDis-[rightContView(==89)]-fourDis-|" options:0 metrics:metrics views:menView];
	      			NSArray *hBContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-twoDis-[bottomContView(==89)]-twoDis-|" options:0 metrics:metrics views:menView];
	      			NSArray *vLeftContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeView(==64)][closeText]-|" options:0 metrics:nil views:menView];
	      			NSArray *hTopLeftContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(14)-[closeView(==64)]-|" options:0 metrics:nil views:menView];
	      			NSArray *hBottomLeftContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[closeText]|" options:0 metrics:nil views:menView];
	      			NSArray *vCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[respringView(==64)][springText]-|" options:0 metrics:nil views:menView];
	      			NSArray *hTopCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(14)-[respringView(==64)]-|" options:0 metrics:nil views:menView];
	      			NSArray *hBottomCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(1)-[springText]|" options:0 metrics:nil views:menView];
	      			NSArray *vRightContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rebootView(==64)][bootText]-|" options:0 metrics:nil views:menView];
	      			NSArray *hTopRightContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(14)-[rebootView(==64)]-|" options:0 metrics:nil views:menView];
	      			NSArray *hBottomRightContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bootText]|" options:0 metrics:nil views:menView];
	      			NSArray *vBCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cancelView(==64)][cancelText]-|" options:0 metrics:nil views:menView];
	      			NSArray *hBTopCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(14)-[cancelView(==64)]-|" options:0 metrics:nil views:menView];
	      			NSArray *hBBottomCenterContainer = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(1)-[cancelText]|" options:0 metrics:nil views:menView];
	        		[transView addConstraints:vLRootContainer];
	        		[transView addConstraints:vCRootContainer];
	        		[transView addConstraints:vRRootContainer];
	        		[transView addConstraints:vBRootContainer];
	        		[transView addConstraints:hContainers];
	        		[transView addConstraints:hBContainer];
	        		[closeContainerView addConstraints:vLeftContainer];
	        		[closeContainerView addConstraints:hTopLeftContainer];
	        		[closeContainerView addConstraints:hBottomLeftContainer];
	        		[springContainerView addConstraints:vCenterContainer];
	        		[springContainerView addConstraints:hTopCenterContainer];
	        		[springContainerView addConstraints:hBottomCenterContainer];
	        		[bootContainerView addConstraints:vRightContainer];
	        		[bootContainerView addConstraints:hTopRightContainer];
	        		[bootContainerView addConstraints:hBottomRightContainer];
	        		[cancelContainerView addConstraints:vBCenterContainer];
	        		[cancelContainerView addConstraints:hBTopCenterContainer];
	        		[cancelContainerView addConstraints:hBBottomCenterContainer];
					menClose.hidden = NO;
					menClose.alpha = 0.0f;
					menRespring.hidden = NO;
					menRespring.alpha = 0.0f;
					menReboot.hidden = NO;
					menReboot.alpha = 0.0f;	
					menCancel.hidden = NO;
					menCancel.alpha = 0.0f;	
					closeLabel.hidden = NO;
					closeLabel.alpha = 0.0f;
					springLabel.hidden = NO;
					springLabel.alpha = 0.0f;
					bootLabel.hidden = NO;
					bootLabel.alpha = 0.0f;
					cancelLabel.hidden = NO;
					cancelLabel.alpha = 0.0f;
					blurView.blurRadius = 0.0f;
					[UIView animateWithDuration:0.7 delay:0 options:0 animations:^{
					blurView.blurRadius = 1.0f;
					menClose.alpha = 1.0f;
					menRespring.alpha = 1.0f;
					menReboot.alpha = 1.0f;
					menCancel.alpha = 1.0f;
					closeLabel.alpha = 1.0f;
					springLabel.alpha = 1.0f;
					bootLabel.alpha = 1.0f;
					cancelLabel.alpha = 1.0f;
					} completion:^(BOOL finished) {
						//Chill out, max, relax all cool
				   	}];
					UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetected)];
			   		closeTap.numberOfTapsRequired = 1;
			    	menClose.userInteractionEnabled = YES;
			    	[menClose addGestureRecognizer:closeTap];
			    	UITapGestureRecognizer *springTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(springDetected)];
			   		springTap.numberOfTapsRequired = 1;
			    	menRespring.userInteractionEnabled = YES;
			    	[menRespring addGestureRecognizer:springTap];
			    	UITapGestureRecognizer *bootTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bootDetected)];
			   		bootTap.numberOfTapsRequired = 1;
			    	menReboot.userInteractionEnabled = YES;
			    	[menReboot addGestureRecognizer:bootTap];
			    	UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDetected)];
			   		cancelTap.numberOfTapsRequired = 1;
			    	menCancel.userInteractionEnabled = YES;
			    	[menCancel addGestureRecognizer:cancelTap];
				}
				else
				{
					%orig;
				}		
			} 
			else 
			{
				if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
				{
				    if ([beRemoved.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
				    	//Landscape Menu for later
				    }
				    else
				    {
				    	%orig;
				    }
				}
			}
			#pragma clang diagnostic pop	
		}
		else
		{
			%orig;
		}
	}
	else
	{
		%orig;
	}
}
%new
- (id)getSelf
{
	SBUIController *uiController = [%c(SBUIController) sharedInstance];
	SBAppSwitcherController *switcherController = [uiController _appSwitcherController];
	return switcherController;
}
%new
- (id)getIconController
{
	SBUIController *uiController = [%c(SBUIController) sharedInstance];
	SBAppSwitcherController *switcherController = [uiController _appSwitcherController];
	SBAppSwitcherIconController *iconController = MSHookIvar<SBAppSwitcherIconController *>(switcherController, "_iconController");
	return iconController;
}
%new - (void)closeDetected {
		reloadPrefs();
		menClose.hidden = NO;
		menClose.alpha = 1.0f;
		menRespring.hidden = NO;
		menRespring.alpha = 1.0f;
		menReboot.hidden = NO;
		menReboot.alpha = 1.0f;	
		menCancel.hidden = NO;
		menCancel.alpha = 1.0f;	
		closeLabel.hidden = NO;
		closeLabel.alpha = 0.5f;
		springLabel.hidden = NO;
		springLabel.alpha = 0.5f;
		bootLabel.hidden = NO;
		bootLabel.alpha = 0.5f;
		cancelLabel.hidden = NO;
		cancelLabel.alpha = 0.5f;
		blurView.hidden = NO;
		[UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
		menClose.alpha = 0.0f;
		menRespring.alpha = 0.0f;
		menReboot.alpha = 0.0f;
		menCancel.alpha = 0.0f;
		closeLabel.alpha = 0.0f;
		springLabel.alpha = 0.0f;
		bootLabel.alpha = 0.0f;
		cancelLabel.alpha = 0.0f;
		blurView.blurRadius = 0.0f;
		} completion:^(BOOL finished) {
			[menClose removeFromSuperview];
			[blurView removeFromSuperview];
			[menRespring removeFromSuperview];
			[menReboot removeFromSuperview];
			[menCancel removeFromSuperview];
			[closeLabel removeFromSuperview];
			[springLabel removeFromSuperview];
			[bootLabel removeFromSuperview];
			[cancelLabel removeFromSuperview];
			[transView removeFromSuperview];
			[closeContainerView removeFromSuperview];
			[springContainerView removeFromSuperview];
			[bootContainerView removeFromSuperview];
			[cancelContainerView removeFromSuperview];
			[self forceDismissAnimated:YES];
		}];
		NSMutableArray *applicationList = MSHookIvar<NSMutableArray *>([self getIconController], "_appList");
		NSMutableArray *appsToKill = [[NSMutableArray alloc] init];
		for (SBDisplayLayout *display in applicationList)
		{
			NSMutableArray *dispItems = [[NSMutableArray alloc] initWithArray:[display.displayItems copy]];
			SBDisplayItem *dispItem = dispItems[0];
			if (![dispItem.type isEqualToString:@"Homescreen"])
			{
				[appsToKill addObject:dispItem];
			}
		}
		for (id appToKill in appsToKill)
		{
			[self _quitAppWithDisplayItem:appToKill];
		}
}
%new - (void)springDetected {
		[(SpringBoard *)[%c(SpringBoard) sharedApplication] _relaunchSpringBoardNow];
}
%new - (void)bootDetected {
		[(SpringBoard *)[%c(SpringBoard) sharedApplication] _rebootNow];		
}
%new - (void)cancelDetected {
		reloadPrefs();
		menClose.hidden = NO;
		menClose.alpha = 1.0f;
		menRespring.hidden = NO;
		menRespring.alpha = 1.0f;
		menReboot.hidden = NO;
		menReboot.alpha = 1.0f;	
		menCancel.hidden = NO;
		menCancel.alpha = 1.0f;	
		closeLabel.hidden = NO;
		closeLabel.alpha = 1.0f;
		springLabel.hidden = NO;
		springLabel.alpha = 1.0f;
		bootLabel.hidden = NO;
		bootLabel.alpha = 1.0f;
		cancelLabel.hidden = NO;
		cancelLabel.alpha = 1.0f;
		blurView.hidden = NO;
		[UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
		menClose.alpha = 0.0f;
		menRespring.alpha = 0.0f;
		menReboot.alpha = 0.0f;
		menCancel.alpha = 0.0f;
		closeLabel.alpha = 0.0f;
		springLabel.alpha = 0.0f;
		bootLabel.alpha = 0.0f;
		cancelLabel.alpha = 0.0f;
		blurView.blurRadius = 0.0f;
		} completion:^(BOOL finished) {
			[menClose removeFromSuperview];
			[menRespring removeFromSuperview];
			[menReboot removeFromSuperview];
			[menCancel removeFromSuperview];
			[closeContainerView removeFromSuperview];
			[springContainerView removeFromSuperview];
			[bootContainerView removeFromSuperview];
			[cancelContainerView removeFromSuperview];
			[self forceDismissAnimated:YES];
			[transView removeFromSuperview];
			[blurView removeFromSuperview];
			[closeLabel removeFromSuperview];
			[springLabel removeFromSuperview];
			[bootLabel removeFromSuperview];
			[cancelLabel removeFromSuperview];
		}];
}
-(void)_updatePageViewScale:(CGFloat)arg1 xTranslation:(CGFloat)arg2 {
	reloadPrefs();
	if (enabled)
	{
		CGFloat scale = [self _scaleForFullscreenPageView];
		%orig(scale, 0);
	}
	else
	{
		%orig;
	}
}
%end
%hook SBAppSwitcherPageViewController
-(CGFloat)_distanceBetweenCenters {
	reloadPrefs();
	if (enabled)
	{
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) 
		{
		    CGRect screenRect = [[UIScreen mainScreen] bounds];
			if (screenRect.size.width == 320)
			{
				return 152;
			}
			else
			{
				CGFloat centers = (screenRect.size.width/2);
				return centers;
			}
		} 
		else 
		{
			if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
			{
			    CGRect screenRect = [[UIScreen mainScreen] bounds];
				if (screenRect.size.height == 568)
				{
					return 270;
				}
				else
				{
					CGFloat centers = (screenRect.size.height/2);
					return centers;
				}
			}
		}
		#pragma clang diagnostic pop
	}
	else
	{
		return %orig;
	}
}
-(void)setOffsetToIndex:(unsigned long long)arg1 animated:(BOOL)arg2 {
	reloadPrefs();
	if (enabled)
	{
		if (setTo1)
		{
			%orig(arg1, arg2);
		}
		else
		{
			if (arg1 == 1)
			{
				%orig(0, arg2);
			}
			else
			{
				%orig(1, arg2);
			}
			setTo1 = 1;
		}
	}
	else
	{
		%orig;
	}
}
%end
%hook SBAppSwitcherIconController
-(void)loadView {
	reloadPrefs();
	if (enabled)
	{
		//pass-through
	}
	else
	{
		%orig;
	}
}	
%end
%hook SBAppSwitcherPeopleViewController
-(void)loadView {
	reloadPrefs();
	if (enabled)
	{
		//pass-through
	}
	else
	{
		%orig;
	}
}
%end
// %hook SBAppSwitcherSnapshotView
// +(id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(int)arg2 loadAsync:(BOOL)arg3 withQueue:(id)arg4 statusBarCache:(id)arg5 {
// 	reloadPrefs();
// 	if (enabled)
// 	{
// 		if (privacy)
// 		{
// 			UIImageView *snapshot = (UIImageView *) %orig();
// 			CAFilter *filter = [CAFilter filterWithName:@"gaussianBlur"];
// 			[filter setValue:@(privblur) forKey:@"inputRadius"];
// 			snapshot.layer.filters = [NSArray arrayWithObject:filter];
// 			return snapshot;
//         }
// 		else
// 		{
// 			return %orig;
// 		}
// 	}
// 	else
// 	{
// 		return %orig;
// 	}
// }
// %end