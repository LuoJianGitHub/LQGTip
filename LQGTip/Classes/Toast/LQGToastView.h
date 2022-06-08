//
//  LQGToastView.h
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGAnimationView.h"

@interface LQGToastView : LQGAnimationView

//MARK:HUD

+ (void)showHUDWithMessage:(NSString*)message;

+ (void)showHUDWithMessage:(NSString*)message toView:(UIView *)view;

//MARK:Toast

+ (void)showToastWithMessage:(NSString *)message;

+ (void)showToastWithMessage:(NSString *)message toView:(UIView *)view;

@end
