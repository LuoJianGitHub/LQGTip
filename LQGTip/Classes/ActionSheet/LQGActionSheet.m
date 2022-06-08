//
//  LQGActionSheet.m
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGActionSheet.h"

#import <Masonry/Masonry.h>

#import <LQGMacro/LQGMacro.h>
#import <LQGCategory/LQGCategory.h>

@interface LQGActionSheet ()
<
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *messageLab;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) LQGActionSheetModel *model;

@end

@implementation LQGActionSheet

+ (void)showWithModel:(LQGActionSheetModel *)model {
    [self showWithModel:model toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showWithModel:(LQGActionSheetModel *)model toView:(UIView *)view {
    [self showWithModel:model toView:view insets:UIEdgeInsetsZero];
}

+ (void)showWithModel:(LQGActionSheetModel *)model toView:(UIView *)view insets:(UIEdgeInsets)insets {
    if (!view) return;
    if (!model) return;
    if (!model.message.length && !model.normalActions.count && !model.cancelActionTitle.length) return;
    
    [self hideFromView:view];
            
    LQGActionSheet *actionSheet = [[LQGActionSheet alloc] initWithModel:model];
    [actionSheet addToView:view insets:insets];
    
    [view endEditing:YES];
}


#pragma mark - Life Cycle

- (instancetype)initWithModel:(LQGActionSheetModel *)model {
    if (self = [super init]) {
        self.model = model;
                        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
        }];
        
        if (model.message.length) {
            UIView *whiteView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor whiteColor];
                view;
            });
            [self.contentView addSubview:whiteView];
            [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_offset(0);
                if (!model.normalActions.count && !model.cancelActionTitle.length) {
                    make.bottom.mas_offset(-LQG_SS_BOTTOMSAFE_HEIGHT);
                }
            }];
            
            self.messageLab.font = model.messageFont;
            self.messageLab.textColor = model.messageColor;
            self.messageLab.text = model.message;
            [whiteView addSubview:self.messageLab];
            [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
            }];
        }
        
        if (model.normalActions.count) {
            self.tableView.scrollEnabled = model.normalActions.count > 5;
            [self.contentView addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (model.message.length) {
                    make.top.mas_equalTo(self.messageLab.mas_bottom).mas_offset(15 + 1);
                } else {
                    make.top.mas_offset(0);
                }
                make.left.right.mas_offset(0);
                make.height.mas_equalTo(MIN(model.normalActions.count, 5) * 44);
                if (!model.cancelActionTitle.length) {
                    make.bottom.mas_offset(-LQG_SS_BOTTOMSAFE_HEIGHT);
                }
            }];
        }
        
        if (model.cancelActionTitle.length) {
            self.cancelBtn.titleLabel.font = model.cancelActionFont;
            [self.cancelBtn setTitleColor:model.cancelActionColor forState:UIControlStateNormal];
            [self.cancelBtn setTitle:model.cancelActionTitle forState:UIControlStateNormal];
            [self.contentView addSubview:self.cancelBtn];
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (model.normalActions.count) {
                    make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(10);
                } else if (model.message.length) {
                    make.top.mas_equalTo(self.messageLab.mas_bottom).mas_offset(15 + 10);
                } else {
                    make.top.mas_offset(0);
                }
                make.left.right.mas_offset(0);
                make.bottom.mas_offset(-LQG_SS_BOTTOMSAFE_HEIGHT);
                make.height.mas_equalTo(44);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}


#pragma mark - TableView

//MARK:number

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.normalActions.count;
}

//MARK:height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//MARK:视图

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LQGActionSheetActionModel *actionModel = self.model.normalActions[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description]];
    UIButton *btn = ({
        UIButton *btn = [cell viewWithTag:9000];
        if (!btn) {
            btn = [[UIButton alloc] init];
            btn.userInteractionEnabled = NO;
            btn.tag = 9000;
            
            [cell.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_offset(0);
            }];
        }
        btn;
    });
    
    [btn setImage:actionModel.image forState:UIControlStateNormal];
    [btn setAttributedTitle:({
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        if (actionModel.title.length) {
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:actionModel.title
                                                                                     attributes:@{NSFontAttributeName:actionModel.titleFont,
                                                                                                  NSForegroundColorAttributeName:actionModel.titleColor}]];
        }
        if (actionModel.message.length) {
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:actionModel.message
                                                                                     attributes:@{NSFontAttributeName:actionModel.messageFont,
                                                                                                  NSForegroundColorAttributeName:actionModel.messageColor}]];
        }
        attributedString;
    }) forState:UIControlStateNormal];
    if (actionModel.image && (actionModel.title.length || actionModel.message.length)) {
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    } else {
        btn.contentEdgeInsets = UIEdgeInsetsZero;
        btn.titleEdgeInsets = UIEdgeInsetsZero;
    }
    return cell;
}

//MARK:事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.model.normalActionTapBlock) {
        self.model.normalActionTapBlock(indexPath.row);
    }
    
    [self hide];
}


#pragma mark - Response Action

- (void)cancelBtnAction {
    if (self.model.cancelActionTapBlock) {
        self.model.cancelActionTapBlock();
    }
    
    [self hide];
}


#pragma mark - Other Method

- (void)startStatus {
    [super startStatus];
    
    self.contentView.y = self.height;
}

- (void)endStatus {
    [super endStatus];
    
    self.contentView.y = self.height - self.contentView.height;
}


#pragma mark - Lazy

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
            view;
        });
    }
    return _contentView;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab;
        });
    }
    return _messageLab;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.separatorColor = [UIColor colorWithHex:0xF0F0F0];
            tableView.separatorInset = UIEdgeInsetsZero;
            tableView.showsVerticalScrollIndicator = NO;
            
            tableView.dataSource = self;
            tableView.delegate = self;

            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
            
            tableView;
        });
    }
    return _tableView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.backgroundColor = [UIColor whiteColor];
            
            [btn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
    }
    return _cancelBtn;
}

@end

@implementation LQGActionSheetModel

+ (instancetype)appearance {
    static LQGActionSheetModel *appearance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [self alloc];
        appearance.messageFont = [UIFont systemFontOfSize:15];
        appearance.messageColor = [UIColor colorWithHex:0x666666];
        appearance.cancelActionFont = [UIFont systemFontOfSize:17];
        appearance.cancelActionColor = [UIColor colorWithHex:0x999999];
    });
    return appearance;
}

- (instancetype)init {
    if (self = [super init]) {
        LQGActionSheetModel *appearance = [LQGActionSheetModel appearance];
        self.messageFont = appearance.messageFont;
        self.messageColor = appearance.messageColor;
        self.cancelActionFont = appearance.cancelActionFont;
        self.cancelActionColor = appearance.cancelActionColor;
    }
    return self;
}

@end

@implementation LQGActionSheetActionModel

+ (instancetype)appearance {
    static LQGActionSheetActionModel *appearance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [self alloc];
        appearance.titleFont = [UIFont systemFontOfSize:17];
        appearance.titleColor = [UIColor colorWithHex:0xE1730F];
        appearance.messageFont = [UIFont systemFontOfSize:13];
        appearance.messageColor = [UIColor colorWithHex:0x999999];
    });
    return appearance;
}

- (instancetype)init {
    if (self = [super init]) {
        LQGActionSheetActionModel *appearance = [LQGActionSheetActionModel appearance];
        self.titleFont = appearance.titleFont;
        self.titleColor = appearance.titleColor;
        self.messageFont = appearance.messageFont;
        self.messageColor = appearance.messageColor;
    }
    return self;
}

@end
