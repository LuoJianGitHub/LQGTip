//
//  LQGToastView.m
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGToastView.h"

#import <Masonry/Masonry.h>

#import <LQGCategory/LQGCategory.h>

@interface LQGToastView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *messageLab;

@end

@implementation LQGToastView

//MARK:HUD

+ (void)showHUDWithMessage:(NSString*)message {
    [self showHUDWithMessage:message toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHUDWithMessage:(NSString*)message toView:(UIView *)view {
    [self showToastViewWithIsHUD:YES message:message toView:view];
}

//MARK:Toast

+ (void)showToastWithMessage:(NSString *)message {
    [self showToastWithMessage:message toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showToastWithMessage:(NSString *)message toView:(UIView *)view {
    [self showToastViewWithIsHUD:NO message:message toView:view];
}

+ (void)showToastViewWithIsHUD:(BOOL)isHUD message:(NSString *)message toView:(UIView *)view {
    if (!view) return;
    if (!isHUD && !message.length) return;
    
    [self hideFromView:view];
            
    LQGToastView *toastView = [[LQGToastView alloc] initWithIsHUD:isHUD message:message];
    [toastView addToView:view];
    
    if (isHUD) {
        [view endEditing:YES];
    } else {
        CGFloat time = message.length / 10.f;
        if (time < 2) {
            time = 2;
        } else if (time > 5) {
            time = 5;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toastView hide];
        });
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithIsHUD:(BOOL)isHUD message:(NSString *)message {
    if (self = [super init]) {
        self.userInteractionEnabled = isHUD;
        self.backViewColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_greaterThanOrEqualTo(20);
            make.left.mas_greaterThanOrEqualTo(20);
            make.center.mas_offset(0);
            if (isHUD && message.length) {
                make.width.mas_greaterThanOrEqualTo(115);
            }
        }];
        
        if (isHUD) {
            [self.contentView addSubview:self.activityView];
            [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(20);
                make.centerX.mas_offset(0);
                if (!message.length) {
                    make.left.mas_offset(20);
                    make.centerY.mas_offset(0);
                }
            }];
        }
        
        if (message.length) {
            self.messageLab.text = message;
            [self.contentView addSubview:self.messageLab];
            [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                if (isHUD) {
                    make.top.mas_equalTo(self.activityView.mas_bottom).mas_offset(20);
                } else {
                    make.top.mas_offset(10);
                }
                make.left.mas_offset(10);
                make.bottom.mas_offset(isHUD ? -20 : -10);
                make.centerX.mas_offset(0);
            }];
        }
    }
    return self;
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return NO;
}


#pragma mark - Other Method

- (void)show {
    if (self.activityView.superview) {
        [self startStatus];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super show];
        });
    } else {
        [super show];
    }
}

- (void)startStatus {
    self.contentView.alpha = 0;
}

- (void)endStatus {
    self.contentView.alpha = 1.f;
}


#pragma mark - Lazy

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithHex:0x000000 a:0.8];
            view.layer.cornerRadius = 8;
            view;
        });
    }
    return _contentView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = ({
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityView startAnimating];
            activityView;
        });
    }
    return _activityView;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [UIColor whiteColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab.lineBreakMode = NSLineBreakByTruncatingTail;
            lab;
        });
    }
    return _messageLab;
}

@end
