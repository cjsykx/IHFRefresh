//
//  IHFRefresh.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshView.h"
#import "UIView+IHF.h"

CGFloat const IHFRefreshViewDefaultHeight = 70.0f;
CGFloat const IHFActivityIndicatorViewMargin = 50.0f;
CGFloat const IHFTextIndicatorMargin = 20.0f;
CGFloat const IHFTimeIndicatorMargin = 10.0f;

@interface IHFRefreshView ()
@property (weak,nonatomic) UILabel *textIndicator;
@property (weak,nonatomic) UILabel *timeIndicator;
@property (copy,nonatomic) NSString *lastRefreshingTimeString;
@property (assign,nonatomic) BOOL hasSetOriginalInsets;

@end
@implementation IHFRefreshView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        // text label for Indicator state
        UILabel *textIndicator = [[UILabel alloc] init];
        textIndicator.bounds = CGRectMake(0, 0, 300, 30);
        textIndicator.textAlignment = NSTextAlignmentCenter;
        textIndicator.backgroundColor = [UIColor clearColor];
        textIndicator.font = [UIFont systemFontOfSize:14];
        textIndicator.textColor = [UIColor lightGrayColor];
        [self addSubview:textIndicator];
        _textIndicator = textIndicator;
        
        // update time for Indicator state
        UILabel *timeIndicator = [[UILabel alloc] init];
        timeIndicator.bounds = CGRectMake(0, 0, 160, 16);;
        timeIndicator.textAlignment = NSTextAlignmentCenter;
        timeIndicator.textColor = [UIColor lightGrayColor];
        timeIndicator.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeIndicator];
        _timeIndicator = timeIndicator;
        
        _curveView = [[CurveView alloc]initWithFrame:CGRectMake(0, 0, 30, IHFRefreshViewDefaultHeight)];
        [self insertSubview:_curveView atIndex:0];
    }
    return self;
}

+ (instancetype)refreshView{
    return [[self alloc] init];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
        
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self.superview removeObserver:self forKeyPath:IHFRefreshViewObservingkeyPath];

    if (newSuperview) {
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        [_scrollView addObserver:self forKeyPath:IHFRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
        _originalEdgeInsets = _scrollView.contentInset;
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    CGFloat refreshWidth = self.scrollView.frameWidth;
    
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    if(self.scrollView.frameWidth > screenW){
        refreshWidth = screenW;
    }
    self.bounds = CGRectMake(0, 0, refreshWidth, IHFRefreshViewDefaultHeight);
    self.clipsToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // activityIndicatorView frame
    CGFloat viewCenterX = self.frameWidth * 0.5 - 80;
    CGFloat viewCenterY = self.frameHeight * 0.5 + 20;
    
    _curveView.center =  CGPointMake(viewCenterX, viewCenterY);

    // text frame
    CGFloat textCenterX = self.frameWidth * 0.5;
    CGFloat textCenterY = /*_curveView.frameHeight * 0.5 + */IHFTextIndicatorMargin;
    _textIndicator.center = CGPointMake(textCenterX,textCenterY);
    
    // time frame
    CGFloat timeCenterX = self.frameWidth * 0.5;
    CGFloat timeCenterY = self.frameHeight - _timeIndicator.frameHeight * 0.5 - IHFTimeIndicatorMargin;
    _timeIndicator.center = CGPointMake(timeCenterX,timeCenterY);
}

- (NSString *)lastRefreshingTimeString{
    if (_lastRefreshingTimeString == nil) {
        return [self refreshingTimeString];
    }
    return _lastRefreshingTimeString;
}

- (void)addTarget:(id)target refreshAction:(SEL)action{
    _beginRefreshingTarget = target;
    _beginRefreshingAction = action;
}

-(UIEdgeInsets)newEdgeInsetsWithOriginalEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    return UIEdgeInsetsMake(_originalEdgeInsets.top + edgeInsets.top, _originalEdgeInsets.left + edgeInsets.left, _originalEdgeInsets.bottom + edgeInsets.bottom, _originalEdgeInsets.right + edgeInsets.right);
}

- (void)setRefreshState:(IHFRefreshViewState)refreshState{
    
    _refreshState = refreshState;
    
    switch (refreshState) {
        case IHFRefreshViewStateRefreshing:
        {
            if (!_hasSetOriginalInsets) {
                _originalEdgeInsets = self.scrollView.contentInset;
                _hasSetOriginalInsets = YES;
            }
            
            [self startLoading:self.curveView];

            // new contentInset
            _scrollView.contentInset = [self newEdgeInsetsWithOriginalEdgeInsets:self.scrollViewEdgeInsets];
            
            _lastRefreshingTimeString = [self refreshingTimeString];
            _textIndicator.text = _textForRefreshingState;
            
            if (self.refreshingOperation) { // use block to do action
                self.refreshingOperation();
            } else if (self.beginRefreshingTarget) { // use target
                if ([self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction]) {
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.beginRefreshingTarget performSelector:self.beginRefreshingAction];
                }
            }
        }
            break;
        case IHFRefreshViewStateWillRefresh:
        {
            _textIndicator.text = _textForWillRefreshState;
            [UIView animateWithDuration:0.5 animations:^{
            }];
        }
            break;
        case IHFRefreshViewStateNormal:
        {
            [self stopLoading:self.curveView];

            [UIView animateWithDuration:0.5 animations:^{
                [self stopLoading:self.curveView];
            }];
            _textIndicator.text = self.textForNormalState;
            _timeIndicator.text = [NSString stringWithFormat:@"最后更新：%@", [self lastRefreshingTimeString]];
        }
            break;
        default:
            break;
    }
}

- (void)endRefreshing{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentInset = _originalEdgeInsets;
    } completion:^(BOOL finished) {
        [self setRefreshState:IHFRefreshViewStateNormal];
        if (self.isManuallyRefreshing) {
            self.manuallyRefreshing = NO;
        }
    }];
}

-(void)beginRefreshing{
    
    [self setRefreshState:IHFRefreshViewStateRefreshing];
}

// 更新时间
- (NSString *)refreshingTimeString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

-(void)setBeginRefreshingOperation:(void (^)())beginRefreshingOperation{
}

#pragma mark - start and stop loading
- (void)startLoading:(UIView *)rotateView{
    rotateView.transform = CGAffineTransformIdentity;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [rotateView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

- (void)stopLoading:(UIView *)rotateView{
    [rotateView.layer removeAllAnimations];
}


@end
