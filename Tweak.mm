#import "UIKitPrivate.h"
#import <substrate.h>

%hook SBNotificationCenterViewController

+ (NSString *)_localizableTitleForBulletinViewControllerOfClass:(Class)aClass {
    if ([aClass isEqual:objc_getClass("SBControlCenterController")]) {
        NSBundle *preferencesAppBundle = [NSBundle bundleWithPath:@"/Applications/Preferences.app"];
        return [preferencesAppBundle localizedStringForKey:@"CONTROLCENTER" value:nil table:@"Settings"];
    }
    return %orig;
}

- (id)_newBulletinObserverViewControllerOfClass:(Class)theClass {
    if (strcmp(class_getName(theClass), "SBNotificationsMissedModeViewController") == 0)
        theClass = %c(SBControlCenterController);
    return %orig(theClass);
}

- (id)_newBackgroundView {
    id retval = %orig;
    if ([retval isKindOfClass:[_UIBackdropView class]]) {
        [retval release];
        _UIBackdropView *backdrop = [[_UIBackdropView alloc] initWithPrivateStyle:0x80C];
        [backdrop setGroupName:@"SBNotificationCenterBackdropGroupName"];
        [backdrop.inputSettings setGrayscaleTintLevel:0.3];
        [backdrop.outputSettings setGrayscaleTintLevel:0.3];
        return backdrop;
    }
    return retval;
}

%end


%hook _UIBackdropView

- (void)transitionToPrivateStyle:(NSInteger)style {
    if (style == 0x2B2A) {
        %orig(0x80C);
        [self.inputSettings setGrayscaleTintLevel:0.3];
        [self.outputSettings setGrayscaleTintLevel:0.3];
    }
    else
        %orig;
}

%end


%hook SBControlCenterController

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = %orig;
    if (signature == nil && class_respondsToSelector(objc_getClass("SBBulletinObserverViewController"), selector))
        signature = [objc_getClass("SBBulletinObserverViewController") instanceMethodSignatureForSelector:selector];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation { }

- (BOOL)isKindOfClass:(Class)aClass {
    if (strcmp(class_getName(aClass), "SBBulletinObserverViewController") == 0)
        return YES;
    return %orig;
}

%new
- (void)presentNow {
    [self setInGrabberOnlyMode:NO];
    [self _beginPresentation];
    if ([self isFullyRevealed])
        return;
    [self setTransitioning:YES];
    [self _revealSlidingViewToHeight:[self _yValueForOpen]];
    [self _finishPresenting:YES completion:nil];
}

%new
- (void)dismissNow {
    [self hideGrabberAnimated:NO];
    if ([self isPresented] == NO)
        return;
    if ([self isTransitioning] == NO)
        [self setTransitioning:YES];
    [self _revealSlidingViewToHeight:[self _yValueForClosed]];
    [self _finishPresenting:NO completion:nil];
}

%new
- (void)hostWillPresent {
    [self presentNow];
}

%new
- (void)hostDidPresent {
    [self dismissNow];
    [self presentNow];
}

%new
- (void)hostDidDismiss {
    [self dismissNow];
}

%end

%hook SBControlCenterContentContainerView

- (id)initWithFrame:(CGRect)frame {
    if ((self = %orig)) {
        _UIBackdropView *backdropView = MSHookIvar<_UIBackdropView*>(self, "_backdropView");
        [backdropView removeFromSuperview];
    }
    return self;
}

%end


%hook SBControlCenterWindow

+ (id)alloc {
    return nil;
}

%end


%hook SBControlCenterGrabberView

+ (id)alloc {
    return nil;
}

%end


%hook SBControlCenterContainerView

- (UIColor *)_currentBGColor {
    return [UIColor clearColor];
}

%end


%hook SBLockScreenView

- (void)setBottomGrabberHidden:(BOOL)hidden forRequester:(id)requestor {
    %orig(YES, requestor);
}

%end
