//
//  LQGAlertController.h
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LQGBaseModel/LQGBaseModel.h>

@class LQGAlertModel;

@interface LQGAlertController : UIAlertController

+ (void)showWithModel:(LQGAlertModel *)model fromController:(UIViewController *)controller;

@end

@interface LQGAlertModel : LQGBaseModel

+ (instancetype)appearance;

/// 风格
@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;

/// 标题字体
@property (nonatomic, strong) UIFont *titleFont;

/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 标题（不存在就不显示标题）
@property (nonatomic, copy  ) NSString *title;

/// 提示字体
@property (nonatomic, strong) UIFont *messageFont;

/// 提示颜色
@property (nonatomic, strong) UIColor *messageColor;

/// 提示（不存在就不显示提示）
@property (nonatomic, copy  ) NSString *message;

/// action字体（暂时不生效）
@property (nonatomic, strong) UIFont *actionFont;

/// 一般action颜色
@property (nonatomic, strong) UIColor *normalActionColor;

/// 一般action标题数组（不存在就不显示一般action）
@property (nonatomic, copy  ) NSArray *normalActionTitles;

/// 一般action点击回调
@property (nonatomic, copy  ) void (^normalActionTapBlock)(NSInteger index);

/// 取消action颜色
@property (nonatomic, strong) UIColor *cancelActionColor;

/// 取消action标题（不存在就不显示取消action）
@property (nonatomic, copy  ) NSString *cancelActionTitle;

/// 取消action点击回调
@property (nonatomic, copy  ) void (^cancelActionTapBlock)(void);

@end
