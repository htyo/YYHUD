//
//  YYHUD.h
//  YYHUD
//
//  Created by 云庭 on 2025/8/8.
//

#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface YYHUD : NSObject
+ (void)setIndicatorAnimationType:(DGActivityIndicatorAnimationType)type;
+ (void)setIndicatorColor:(UIColor *)color;

+ (void)showActivityHUD;

+ (void)showActivityHUDToView:(UIView *)superView;

+ (void)hideActivityHUD;

+ (void)showTextHUDWithMessage:(NSString *)message;

+ (void)showTextHUDToView:(UIView *)superView message:(NSString *)message;

+ (void)hideMessageHUD;
@end

NS_ASSUME_NONNULL_END
