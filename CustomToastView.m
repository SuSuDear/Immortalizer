/* 
    Copyright (C) 2024  Serge Alagon

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>. 
*/

#import "CustomToastView.h"

@implementation CustomToastView

-(UIWindow *)getKeyWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if (window.hidden == NO && window.alpha > 0) return window;
    }
    return nil;
}

-(instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon autoHide:(int)seconds {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor clearColor];
        self.containerView.layer.cornerRadius = 24;
        self.containerView.layer.masksToBounds = YES;
        self.containerView.layer.borderWidth = 0.5;
        self.containerView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.containerView];

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.16;
        self.layer.shadowOffset = CGSizeMake(0, 8);
        self.layer.shadowRadius = 18;
        self.layer.masksToBounds = NO;

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        blurView.layer.cornerRadius = 24;
        blurView.layer.masksToBounds = YES;
        [self.containerView addSubview:blurView];

        UIView *tintView = [[UIView alloc] init];
        tintView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.18];
        tintView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:tintView];

        [NSLayoutConstraint activateConstraints:@[
            [blurView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
            [blurView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
            [blurView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
            [blurView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
            [tintView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
            [tintView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
            [tintView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
            [tintView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
        ]];

        self.hStack = [[UIStackView alloc] init];
        self.hStack.axis = UILayoutConstraintAxisHorizontal;
        self.hStack.alignment = UIStackViewAlignmentCenter;
        self.hStack.distribution = UIStackViewDistributionFill;
        self.hStack.spacing = 10.0;
        self.hStack.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:self.hStack];

        if (icon) {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            iconView.tintColor = [UIColor whiteColor];
            iconView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.hStack addArrangedSubview:iconView];
            
            [NSLayoutConstraint activateConstraints:@[
                [iconView.widthAnchor constraintEqualToConstant:22],
                [iconView.heightAnchor constraintEqualToConstant:22]
            ]];
        }

        self.vStack = [[UIStackView alloc] init];
        self.vStack.axis = UILayoutConstraintAxisVertical;
        self.vStack.alignment = UIStackViewAlignmentCenter;
        self.vStack.distribution = UIStackViewDistributionFill;
        self.vStack.spacing = 1.0;
        self.vStack.translatesAutoresizingMaskIntoConstraints = NO;
        [self.hStack addArrangedSubview:self.vStack];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.numberOfLines = 1;
        titleLabel.text = title;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.vStack addArrangedSubview:titleLabel];

        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.72];
        subtitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        subtitleLabel.numberOfLines = 1;
        subtitleLabel.text = subtitle;
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.vStack addArrangedSubview:subtitleLabel];

        [self.hStack setLayoutMargins:UIEdgeInsetsMake(8, 18, 8, 18)];
        self.hStack.layoutMarginsRelativeArrangement = YES;

        [NSLayoutConstraint activateConstraints:@[
            [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
            [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
            [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
            [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10]
        ]];

        [NSLayoutConstraint activateConstraints:@[
            [self.hStack.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
            [self.hStack.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
            [self.hStack.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
            [self.hStack.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
            [self.vStack.centerYAnchor constraintEqualToAnchor:self.hStack.centerYAnchor]
        ]];

        if (seconds > 0) {
            [self hideAfter:seconds];
        }
    }
    return self;
}

-(void)presentToast {
    UIWindow *keyWindow = [self getKeyWindow];
    
    if (!keyWindow) return;

    for (UIView *subview in keyWindow.subviews) {
        if ([subview isKindOfClass:[CustomToastView class]]) {
            [(CustomToastView *)subview hideWithAnimation];
        }
    }

    [keyWindow addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:@[
        [self.centerXAnchor constraintEqualToAnchor:keyWindow.centerXAnchor],
        [self.topAnchor constraintEqualToAnchor:keyWindow.topAnchor constant:40],
        [self.widthAnchor constraintLessThanOrEqualToConstant:keyWindow.bounds.size.width - 72],
        [self.widthAnchor constraintGreaterThanOrEqualToConstant:210],
        [self.heightAnchor constraintEqualToConstant:58]
    ]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [keyWindow layoutIfNeeded];
    
    self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

-(void)removeFromSuperview {
    [super removeFromSuperview];
}

-(void)hideWithAnimation {
    [UIView animateWithDuration:0.2  animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height - 30);
    } completion:^(BOOL finished) {
        if (finished) [self removeFromSuperview];
    }];
}

-(void)hideAfter:(NSTimeInterval)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), 
        dispatch_get_main_queue(), ^{
        [self hideWithAnimation];
    });
}
@end
