//
//  LQGAlertController.m
//  LQGTip
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGAlertController.h"

#import <LQGCategory/LQGCategory.h>

@implementation LQGAlertController

+ (void)showWithModel:(LQGAlertModel *)model fromController:(UIViewController *)controller {
    if (!controller) return;
    if (!model) return;
    if (!model.title.length && !model.message.length && !model.normalActionTitles.count && !model.cancelActionTitle.length) return;
    
    LQGAlertController *alertController = [LQGAlertController alertControllerWithModel:model];
    [controller presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Life Cycle

+ (instancetype)alertControllerWithModel:(LQGAlertModel *)model {
    LQGAlertController *alertController;
    if (model.preferredStyle == UIAlertControllerStyleAlert) {
        alertController = [self alertControllerWithTitle:nil message:nil preferredStyle:model.preferredStyle];
    } else {
        alertController = [[self alloc] init];
    }
    
    if (model.title.length) {
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:model.title
                                                                              attributes:@{NSFontAttributeName:model.titleFont,
                                                                                           NSForegroundColorAttributeName:model.titleColor}];;
        [alertController setValue:attributedTitle forKey:@"attributedTitle"];
    }
    
    if (model.message.length) {
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] init];
        if (model.title.length) {
            [attributedMessage appendAttributedString:[[NSAttributedString alloc] initWithString:@" \n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:1], NSParagraphStyleAttributeName:({
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.minimumLineHeight = 0;
                style.lineSpacing = 0;
                style;
            })}]];
        }
        [attributedMessage appendAttributedString:[[NSAttributedString alloc] initWithString:model.message attributes:@{NSFontAttributeName:model.messageFont, NSForegroundColorAttributeName:model.messageColor, NSParagraphStyleAttributeName:({
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentCenter;
            style.lineBreakMode = NSLineBreakByCharWrapping;
            style.lineSpacing = 4;
            style;
        })}]];
        [alertController setValue:attributedMessage forKey:@"attributedMessage"];
    }
    
    if (model.cancelActionTitle.length) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:model.cancelActionTitle style:model.preferredStyle == UIAlertControllerStyleAlert ? UIAlertActionStyleDefault : UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (model.cancelActionTapBlock) {
                model.cancelActionTapBlock();
            }
        }];
        [cancelAction setValue:model.cancelActionColor forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
    }
    
    for (NSInteger index = 0; index < model.normalActionTitles.count; index ++) {
        UIAlertAction *normalAction = [UIAlertAction actionWithTitle:model.normalActionTitles[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (model.normalActionTapBlock) {
                model.normalActionTapBlock(index);
            }
        }];
        [normalAction setValue:model.normalActionColor forKey:@"_titleTextColor"];
        [alertController addAction:normalAction];
    }
    
    return alertController;
}

@end

@implementation LQGAlertModel

+ (instancetype)appearance {
    static LQGAlertModel *appearance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearance = [self alloc];
        appearance.preferredStyle = UIAlertControllerStyleAlert;
        appearance.titleFont = [UIFont boldSystemFontOfSize:17];
        appearance.titleColor = [UIColor blackColor];
        appearance.messageFont = [UIFont systemFontOfSize:15];
        appearance.messageColor = [UIColor colorWithHex:0x666666];
        appearance.actionFont = [UIFont systemFontOfSize:17];
        appearance.normalActionColor = [UIColor colorWithHex:0xE1730F];
        appearance.cancelActionColor = [UIColor colorWithHex:0x999999];
    });
    return appearance;
}

- (instancetype)init {
    if (self = [super init]) {
        LQGAlertModel *appearance = [LQGAlertModel appearance];
        self.preferredStyle = appearance.preferredStyle;
        self.titleFont = appearance.titleFont;
        self.titleColor = appearance.titleColor;
        self.messageFont = appearance.messageFont;
        self.messageColor = appearance.messageColor;
        self.actionFont = appearance.actionFont;
        self.normalActionColor = appearance.normalActionColor;
        self.cancelActionColor = appearance.cancelActionColor;
    }
    return self;
}

@end
