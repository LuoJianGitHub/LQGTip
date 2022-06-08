//
//  LQGAnimationView.m
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGAnimationView.h"

#import <Masonry/Masonry.h>

#import <LQGCategory/LQGCategory.h>

@interface LQGAnimationView ()
<
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) BOOL startAnimationFlag;

@end

@implementation LQGAnimationView

+ (void)show {
    [self showToView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showToView:(UIView *)view {
    [self showToView:view insets:UIEdgeInsetsZero];
}

+ (void)showToView:(UIView *)view insets:(UIEdgeInsets)insets {
    if (!view) return;

    LQGAnimationView *animatonView = [[self alloc] init];
    [animatonView addToView:view];
}

+ (void)hide {
    [self hideFromView:[UIApplication sharedApplication].keyWindow];
}

+ (void)hideFromView:(UIView *)view {
    if (!view) return;

    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:self]) {
            [(LQGAnimationView *)subView hide];
        }
    }
}


#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.startAnimationFlag) {
        self.startAnimationFlag = YES;
        [self show];
    }
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self || touch.view == self.backView;
}


#pragma mark - Other Method

- (void)addToView:(UIView *)view {
    [self addToView:view insets:UIEdgeInsetsZero];
}

- (void)addToView:(UIView *)view insets:(UIEdgeInsets)insets {
    if (!view) return;

    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(insets);
    }];
}

- (void)show {
    [self startStatus];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration: 0.3 animations:^{
            [self endStatus];
        }];
    });
}

- (void)hide {
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self startStatus];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)startStatus {
    self.backView.backgroundColor = [UIColor clearColor];
}

- (void)endStatus {
    self.backView.backgroundColor = self.backViewColor;
}


#pragma mark - Setter/Getter

- (void)setBackViewColor:(UIColor *)backViewColor {
    _backViewColor = backViewColor;

    self.backView.backgroundColor = backViewColor;
}

- (void)setBackViewInsets:(UIEdgeInsets)backViewInsets {
    _backViewInsets = backViewInsets;

    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(backViewInsets);
    }];
}


#pragma mark - 初始化

- (void)lqg_addSubviews {
    self.backgroundColor = [UIColor clearColor];

    [self addGestureRecognizer:({
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tapGR.delegate = self;
        tapGR;
    })];

    // backView
    self.backViewColor = [UIColor colorWithHex:0x000000 a:0.65];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}


#pragma mark - Lazy

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

@end
