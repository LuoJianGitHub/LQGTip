//
//  LQGDefaultView.m
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGDefaultView.h"

#import <Masonry/Masonry.h>

#import <LQGCategory/LQGCategory.h>

@interface LQGDefaultView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *messageLab;

@property (nonatomic, strong) UIButton *handleBtn;

@property (nonatomic, strong) LQGDefaultViewModel *model;

@end

@implementation LQGDefaultView

+ (void)showWithModel:(LQGDefaultViewModel *)model toView:(UIView *)view {
    [self showWithModel:model toView:view insets:UIEdgeInsetsZero];
}

+ (void)showWithModel:(LQGDefaultViewModel *)model toView:(UIView *)view insets:(UIEdgeInsets)insets {
    if (!view) return;
    if (!model) return;
    if (!model.isProcess && !model.image && !model.message.length && !model.handleBtnTitle.length) return;
    
    [self hideFromView:view];
    
    LQGDefaultView *defaultView = [[LQGDefaultView alloc] initWithModel:model];
    defaultView.backgroundColor = model.backgroundColor ? : view.backgroundColor;
    [view addSubview:defaultView];
    [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset((insets.left - insets.right) / 2.f);
        make.centerY.mas_offset((insets.top - insets.bottom) / 2.f);
        make.width.mas_equalTo(view).mas_offset(-insets.left - insets.right);
        make.height.mas_equalTo(view).mas_offset(-insets.top - insets.bottom);
    }];
}

+ (void)hideFromView:(UIView *)view {
    if (!view) return;
    
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[LQGDefaultView class]]) {
            [subView removeFromSuperview];
        }
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithModel:(LQGDefaultViewModel *)model {
    if (self = [super init]) {
        self.model = model;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction)]];
        
        if (model.isProcess) {
            [self addSubview:self.activityView];
            [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_offset(0);
                make.width.height.mas_equalTo(37);
            }];
        } else {
            [self addSubview:self.contentView];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_greaterThanOrEqualTo(0);
                make.left.mas_greaterThanOrEqualTo(0);
                make.center.mas_offset(0);
            }];
            
            if (model.image) {
                self.imageView.image = model.image;
                [self.contentView addSubview:self.imageView];
                [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(0);
                    make.left.mas_greaterThanOrEqualTo(0);
                    make.centerX.mas_offset(0);
                    if (!model.message.length && !model.handleBtnTitle.length) {
                        make.bottom.mas_offset(0);
                    }
                }];
            }
            
            if (model.message.length) {
                self.messageLab.font = model.messageFont;
                self.messageLab.textColor = model.messageColor;
                self.messageLab.text = model.message;
                [self.contentView addSubview:self.messageLab];
                [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (model.image) {
                        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15);
                    } else {
                        make.top.mas_offset(0);
                    }
                    make.left.mas_offset(15);
                    make.centerX.mas_offset(0);
                    if (!model.handleBtnTitle.length) {
                        make.bottom.mas_offset(0);
                    }
                }];
            }
            
            if (model.handleBtnTitle.length) {
                self.handleBtn.backgroundColor = model.handleBtnBackgroundColor;
                self.handleBtn.titleLabel.font = model.handleBtnFont;
                [self.handleBtn setTitleColor:model.handleBtnTitleColor forState:UIControlStateNormal];
                [self.handleBtn setTitle:model.handleBtnTitle forState:UIControlStateNormal];
                [self.contentView addSubview:self.handleBtn];
                [self.handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (model.message.length) {
                        make.top.mas_equalTo(self.messageLab.mas_bottom).mas_offset(15);
                    } else if (model.image) {
                        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15);
                    } else {
                        make.top.mas_offset(0);
                    }
                    make.bottom.mas_offset(0);
                    make.centerX.mas_offset(0);
                }];
            }
        }
    }
    return self;
}


#pragma mark - Response Action

- (void)backTapAction {
    if (self.model.backTapBlock) {
        self.model.backTapBlock();
    }
}

- (void)handleBtnTapAction {
    if (self.model.handleBtnTapBlock) {
        self.model.handleBtnTapBlock();
    }
}


#pragma mark - Lazy

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = ({
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.transform = CGAffineTransformMakeScale(1.85, 1.85);
            [activityView startAnimating];
            activityView;
        });
    }
    return _activityView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = ({
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView;
        });
    }
    return _imageView;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab.lineBreakMode = NSLineBreakByTruncatingTail;
            lab;
        });
    }
    return _messageLab;
}

- (UIButton *)handleBtn {
    if (!_handleBtn) {
        _handleBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.layer.cornerRadius = 4;
            btn.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
            
            [btn addTarget:self action:@selector(handleBtnTapAction) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
    }
    return _handleBtn;
}

@end

@implementation LQGDefaultViewModel

+ (instancetype)appearance {
    static LQGDefaultViewModel *appearance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [self alloc];
        appearance.messageFont = [UIFont systemFontOfSize:15];
        appearance.messageColor = [UIColor colorWithHex:0x666666];
        appearance.handleBtnBackgroundColor = [UIColor colorWithHex:0xE1730F];
        appearance.handleBtnFont = [UIFont systemFontOfSize:17];
        appearance.handleBtnTitleColor = [UIColor whiteColor];
    });
    return appearance;
}

- (instancetype)init {
    if (self = [super init]) {
        LQGDefaultViewModel *appearance = [LQGDefaultViewModel appearance];
        self.backgroundColor = appearance.backgroundColor;
        self.messageFont = appearance.messageFont;
        self.messageColor = appearance.messageColor;
        self.handleBtnBackgroundColor = appearance.handleBtnBackgroundColor;
        self.handleBtnFont = appearance.handleBtnFont;
        self.handleBtnTitleColor = appearance.handleBtnTitleColor;
    }
    return self;
}

@end
