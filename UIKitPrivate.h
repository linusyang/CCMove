#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIScreenEdgePanRecognizerType) {
    UIScreenEdgePanRecognizerTypeMultitasking,
    UIScreenEdgePanRecognizerTypeNavigation,
    UIScreenEdgePanRecognizerTypeOther
};

@protocol _UIScreenEdgePanRecognizerDelegate;

@interface _UIScreenEdgePanRecognizer : NSObject
- (id)initWithType:(UIScreenEdgePanRecognizerType)type;
- (void)incorporateTouchSampleAtLocation:(CGPoint)location timestamp:(double)timestamp modifier:(NSInteger)modifier interfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)reset;
- (CGPoint)_velocity;
@property (nonatomic, assign) id <_UIScreenEdgePanRecognizerDelegate> delegate;
@property (nonatomic, readonly) NSInteger state;
@property (nonatomic) UIRectEdge targetEdges;
@property (nonatomic) CGRect screenBounds;
@end

@protocol _UIScreenEdgePanRecognizerDelegate <NSObject>
@optional
- (void)screenEdgePanRecognizerStateDidChange:(_UIScreenEdgePanRecognizer *)screenEdgePanRecognizer;
@end

@interface UIDevice (UIDevicePrivate)
- (void)setOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
@end

@interface _UIBackdropViewSettings : NSObject
@property (nonatomic) CGFloat grayscaleTintAlpha;
@property (nonatomic) CGFloat grayscaleTintLevel;
@end

@interface _UIBackdropView : UIView
@property (retain, nonatomic) _UIBackdropViewSettings *outputSettings;
@property (retain, nonatomic) _UIBackdropViewSettings *inputSettings;
@end

@interface UIKeyboard : UIView
+ (BOOL)isOnScreen;
+ (CGSize)keyboardSizeForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (CGRect)defaultFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation;
@end