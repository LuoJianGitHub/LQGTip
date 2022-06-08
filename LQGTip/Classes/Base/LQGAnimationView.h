//
//  LQGAnimationView.h
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LQGBaseView/LQGBaseView.h>

@interface LQGAnimationView : LQGBaseView

@property (nonatomic, strong) UIColor *backViewColor;

@property (nonatomic, assign) UIEdgeInsets backViewInsets;

+ (void)show;

+ (void)showToView:(UIView *)view;

+ (void)showToView:(UIView *)view insets:(UIEdgeInsets)insets;

+ (void)hide;

+ (void)hideFromView:(UIView *)view;

- (void)addToView:(UIView *)view;

- (void)addToView:(UIView *)view insets:(UIEdgeInsets)insets;

- (void)show;

- (void)hide;

- (void)startStatus;

- (void)endStatus;

@end
