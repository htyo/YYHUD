//
//  YYHUD.m
//  YYHUD
//
//  Created by 云庭 on 2025/8/8.
//

#import "YYHUD.h"


#define HUDAutoHideTimeInterval 2.5

@interface YYHUD () <MBProgressHUDDelegate>
@property (strong, nonatomic) MBProgressHUD * activityHUD;
@property (strong, nonatomic) MBProgressHUD * messageHUD;

@property (assign, nonatomic) DGActivityIndicatorAnimationType indicatorAnimationType;
@property (strong, nonatomic) UIColor * indicatorColor;
@end

@implementation YYHUD
+ (instancetype) instance {
    static YYHUD * hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[[self class] alloc] init];
        hud.indicatorAnimationType = DGActivityIndicatorAnimationTypeLineScalePulseOut;
        hud.indicatorColor = [UIColor colorWithRed:255.0/255.0 green:225.0/255.0 blue:125.0/255.0 alpha:1.0];
    });
    return hud;
}

+ (NSArray *)activityImagesWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading.bundle/loading%lu",(unsigned long)i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}

+ (UIWindow *)keyWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
        }
    }
    return keyWindow;
}

+ (void)setIndicatorAnimationType:(DGActivityIndicatorAnimationType)type {
    YYHUD.instance.indicatorAnimationType = type;
}

+ (void)setIndicatorColor:(UIColor *)color {
    YYHUD.instance.indicatorColor = color;
}


+ (void)showActivityHUD {
    [self showActivityHUDToView:[self keyWindow]];
}

+ (void)showActivityHUDToView:(UIView *)superView {
    [self hideActivityHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!YYHUD.instance.activityHUD) {
            YYHUD.instance.activityHUD = [[MBProgressHUD alloc] initWithView:superView];
            [superView addSubview:YYHUD.instance.activityHUD];
        }
        YYHUD.instance.activityHUD.animationType = MBProgressHUDAnimationZoomOut;
        YYHUD.instance.activityHUD.removeFromSuperViewOnHide = YES;
        YYHUD.instance.activityHUD.mode = MBProgressHUDModeCustomView;
        
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType: YYHUD.instance.indicatorAnimationType];
        activityIndicatorView.size = 50.0f;
        [activityIndicatorView startAnimating];
        
        YYHUD.instance.activityHUD.customView = activityIndicatorView;
        YYHUD.instance.activityHUD.customView.tintColor = YYHUD.instance.indicatorColor;
        YYHUD.instance.activityHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor; // 背景色设置为纯色
        YYHUD.instance.activityHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.8];
        [YYHUD.instance.activityHUD showAnimated:YES];
        
    });
}

+ (void)hideActivityHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (YYHUD.instance.activityHUD) {
            [YYHUD.instance.activityHUD hideAnimated:YES];
            YYHUD.instance.activityHUD = nil;
        }
    });
}

+ (void)showTextHUDWithMessage:(NSString *)message {
    [self showTextHUDToView:[self keyWindow] message:message];
}

+ (void)showTextHUDToView:(UIView *)superView
                  message:(NSString *)message {
    [self hideMessageHUD];
    [self hideActivityHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!YYHUD.instance.messageHUD) {
            YYHUD.instance.messageHUD = [[MBProgressHUD alloc] initWithView:superView];
            [superView addSubview:YYHUD.instance.messageHUD];
        }
        
        YYHUD.instance.messageHUD.removeFromSuperViewOnHide = YES;
        YYHUD.instance.messageHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        YYHUD.instance.messageHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.7];
        YYHUD.instance.messageHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        YYHUD.instance.messageHUD.backgroundView.color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        YYHUD.instance.messageHUD.userInteractionEnabled = NO;
        YYHUD.instance.messageHUD.mode = MBProgressHUDModeText;
        
        YYHUD.instance.messageHUD.detailsLabel.text = message;
        YYHUD.instance.messageHUD.detailsLabel.textColor = UIColor.whiteColor;
        YYHUD.instance.messageHUD.animationType = MBProgressHUDAnimationZoomOut;
        [YYHUD.instance.messageHUD showAnimated:YES];
        [YYHUD.instance.messageHUD hideAnimated: YES afterDelay:2.5];
        
    });
}

+ (void)hideMessageHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (YYHUD.instance.messageHUD != nil) {
            [YYHUD.instance.messageHUD hideAnimated:YES];
            YYHUD.instance.messageHUD = nil;
        }
    });
}

@end

