/* Copyright Airship and Contributors */

#import "UABeveledLoadingIndicator.h"
#include <QuartzCore/QuartzCore.h>

@interface UABeveledLoadingIndicator()

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end

@implementation UABeveledLoadingIndicator

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
        self.hidden = NO;
    }

    return self;
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7;
    self.layer.cornerRadius = 10.0;
    self.hidden = YES;
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.hidesWhenStopped = YES;
    self.activity.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.activity];
    
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    xConstraint.active = YES;
    yConstraint.active = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setHidden:(BOOL)hidden {
    if (hidden) {
        [self.activity stopAnimating];
    } else {
        [self.activity startAnimating];
    }

    super.hidden = hidden;
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

@end