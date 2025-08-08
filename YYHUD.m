//
//  YYHUD.m
//  YYHUD
//
//  Created by 云庭 on 2025/8/8.
//

#import <DGActivityIndicatorView.h>
#import "YYHUD.h"


#define HUDAutoHideTimeInterval 2.5

@interface ElarisHUD ()
@property (strong, nonatomic) MBProgressHUD * activityHUD;
@property (strong, nonatomic) MBProgressHUD * messageHUD;
@end

@implementation ElarisHUD
+ (instancetype) instance {
    static ElarisHUD * hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[[self class] alloc] init];
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

+ (void)showActivityHUD {
    [self showActivityHUDToView:[self keyWindow]];
}

+ (void)showActivityHUDToView:(UIView *)superView {
    [self hideActivityHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!ElarisHUD.instance.activityHUD) {
            ElarisHUD.instance.activityHUD = [[MBProgressHUD alloc] initWithView:superView];
            [superView addSubview:ElarisHUD.instance.activityHUD];
        }
        ElarisHUD.instance.activityHUD.animationType = MBProgressHUDAnimationZoomOut;
        ElarisHUD.instance.activityHUD.removeFromSuperViewOnHide = YES;
        ElarisHUD.instance.activityHUD.mode = MBProgressHUDModeCustomView;
        
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut];
        activityIndicatorView.size = 50.0f;
        [activityIndicatorView startAnimating];
        
        ElarisHUD.instance.activityHUD.customView = activityIndicatorView;
        ElarisHUD.instance.activityHUD.customView.tintColor = [UIColor colorWithRed:255.0/255.0 green:225.0/255.0 blue:125.0/255.0 alpha:1.0];
        ElarisHUD.instance.activityHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor; // 背景色设置为纯色
        ElarisHUD.instance.activityHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.8];
        [ElarisHUD.instance.activityHUD showAnimated:YES];
        
    });
}

+ (void)hideActivityHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ElarisHUD.instance.activityHUD) {
            [ElarisHUD.instance.activityHUD hideAnimated:YES];
            ElarisHUD.instance.activityHUD = nil;
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
        if (!ElarisHUD.instance.messageHUD) {
            ElarisHUD.instance.messageHUD = [[MBProgressHUD alloc] initWithView:superView];
            [superView addSubview:ElarisHUD.instance.messageHUD];
        }
        
        ElarisHUD.instance.messageHUD.removeFromSuperViewOnHide = YES;
        ElarisHUD.instance.messageHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        ElarisHUD.instance.messageHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.7];
        ElarisHUD.instance.messageHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        ElarisHUD.instance.messageHUD.backgroundView.color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        ElarisHUD.instance.messageHUD.userInteractionEnabled = NO;
        ElarisHUD.instance.messageHUD.mode = MBProgressHUDModeText;
        
        ElarisHUD.instance.messageHUD.detailsLabel.text = message;
        ElarisHUD.instance.messageHUD.detailsLabel.textColor = UIColor.whiteColor;
        ElarisHUD.instance.messageHUD.animationType = MBProgressHUDAnimationZoomOut;
        [ElarisHUD.instance.messageHUD showAnimated:YES];
        [ElarisHUD.instance.messageHUD hideAnimated: YES afterDelay:2.5];
        
    });
}

+ (void)hideMessageHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ElarisHUD.instance.messageHUD != nil) {
            [ElarisHUD.instance.messageHUD hideAnimated:YES];
            ElarisHUD.instance.messageHUD = nil;
        }
    });
}

@end

