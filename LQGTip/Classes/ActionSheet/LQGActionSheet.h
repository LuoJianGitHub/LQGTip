//
//  LQGActionSheet.h
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGAnimationView.h"

#import <LQGBaseModel/LQGBaseModel.h>

@class LQGActionSheetModel, LQGActionSheetActionModel;

@interface LQGActionSheet : LQGAnimationView

+ (void)showWithModel:(LQGActionSheetModel *)model;

+ (void)showWithModel:(LQGActionSheetModel *)model toView:(UIView *)view;

+ (void)showWithModel:(LQGActionSheetModel *)model toView:(UIView *)view insets:(UIEdgeInsets)insets;

@end

@interface LQGActionSheetModel : LQGBaseModel

+ (instancetype)appearance;

/// 提示字体
@property (nonatomic, strong) UIFont *messageFont;

/// 提示颜色
@property (nonatomic, strong) UIColor *messageColor;

/// 提示
@property (nonatomic, copy  ) NSString *message;

/// 一般action数组
@property (nonatomic, copy  ) NSArray<LQGActionSheetActionModel *> *normalActions;

/// 一般action点击回调
@property (nonatomic, copy  ) void (^normalActionTapBlock)(NSInteger index);

/// 取消action字体
@property (nonatomic, strong) UIFont *cancelActionFont;

/// 取消action颜色
@property (nonatomic, strong) UIColor *cancelActionColor;

/// 取消action标题（不存在就不显示取消action）
@property (nonatomic, copy  ) NSString *cancelActionTitle;

/// 取消action点击回调
@property (nonatomic, copy  ) void (^cancelActionTapBlock)(void);

@end

@interface LQGActionSheetActionModel : LQGBaseModel

+ (instancetype)appearance;

/// 图片
@property (nonatomic, strong) UIImage *image;

/// 标题字体
@property (nonatomic, strong) UIFont *titleFont;

/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 标题
@property (nonatomic, copy  ) NSString *title;

/// 提示字体
@property (nonatomic, strong) UIFont *messageFont;

/// 提示颜色
@property (nonatomic, strong) UIColor *messageColor;

/// 提示
@property (nonatomic, copy  ) NSString *message;

@end
