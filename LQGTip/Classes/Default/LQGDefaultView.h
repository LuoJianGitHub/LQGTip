//
//  LQGDefaultView.h
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LQGBaseView/LQGBaseView.h>
#import <LQGBaseModel/LQGBaseModel.h>

@class LQGDefaultViewModel;

@interface LQGDefaultView : LQGBaseView

+ (void)showWithModel:(LQGDefaultViewModel *)model toView:(UIView *)view;

+ (void)showWithModel:(LQGDefaultViewModel *)model toView:(UIView *)view insets:(UIEdgeInsets)insets;

+ (void)hideFromView:(UIView *)view;

@end

@interface LQGDefaultViewModel : LQGBaseModel

+ (instancetype)appearance;

/// 是否是加载中
@property (nonatomic, assign) BOOL isProcess;

/// 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 图片（不存在就不显示图片布局）
@property (nonatomic, strong) UIImage *image;

/// 提示字体
@property (nonatomic, strong) UIFont *messageFont;

/// 提示颜色
@property (nonatomic, strong) UIColor *messageColor;

/// 提示（不存在就不显示文本布局）
@property (nonatomic, copy  ) NSString *message;

/// 操作按钮背景颜色
@property (nonatomic, strong) UIColor *handleBtnBackgroundColor;

/// 操作按钮标题字体
@property (nonatomic, strong) UIFont *handleBtnFont;

/// 操作按钮标题颜色
@property (nonatomic, strong) UIColor *handleBtnTitleColor;

/// 操作按钮标题（不存在就不显示按钮布局）
@property (nonatomic, copy  ) NSString *handleBtnTitle;

/// 操作按钮点击回调
@property (nonatomic, copy  ) void (^handleBtnTapBlock)(void);

/// 背景视图点击回调
@property (nonatomic, copy  ) void (^backTapBlock)(void);

@end
