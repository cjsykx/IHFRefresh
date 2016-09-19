//
//  IHFRefreshHeaderView.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshHeaderView.h"
#import "UIView+IHF.h"

@interface IHFRefreshHeaderView ()
@property (assign,nonatomic) BOOL hasLayoutedForManuallyRefreshing;
@end

@implementation IHFRefreshHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)  {
        self.textForNormalState = @"下拉可以加载最新数据";
        self.textForRefreshingState = @"正在加载最新数据,请稍候";
        self.textForWillRefreshState = @"松开即可加载最新数据";
        [self setRefreshState:IHFRefreshViewStateNormal];
    }
    return self;
}

- (CGFloat)yOfCenterPoint {
    return - (self.frameHeight * 0.5);
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frameHeight, 0, 0, 0);

    CGFloat refreshWidth = self.scrollView.frameWidth;
    
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    if(self.scrollView.frameWidth > screenW) {
        refreshWidth = screenW;
    }
    
    self.center = CGPointMake(refreshWidth * 0.5, [self yOfCenterPoint]);
    
    // Manually Refreshing
    if (self.isManuallyRefreshing && !_hasLayoutedForManuallyRefreshing && self.scrollView.contentInset.top >= 0) {
        CGPoint temp = self.scrollView.contentOffset;
        temp.y -= self.frameHeight * 2;
        self.scrollView.contentOffset = temp;
        temp.y += self.frameHeight;
        self.scrollView.contentOffset = temp;
        
        _hasLayoutedForManuallyRefreshing = YES;
    }
}

- (void)autoRefreshWhenViewDidAppear {
    self.manuallyRefreshing = YES;
}

- (void)beginRefreshing {
    CGPoint temp = self.scrollView.contentOffset;
    temp.y -= self.frameHeight * 2;
    self.scrollView.contentOffset = temp;
    temp.y += self.frameHeight;
    self.scrollView.contentOffset = temp;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    // if the controller is refresing , return!
    if (![keyPath isEqualToString:IHFRefreshViewObservingkeyPath] || self.refreshState == IHFRefreshViewStateRefreshing) return;
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    CGFloat criticalY = -self.frameHeight - self.scrollView.contentInset.top;
    
    // if the y<=0 AND scrollview height is not 0 ,can do refresh
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    CGFloat diff = fabs(self.scrollView.contentOffset.y) - self.frameHeight + 10;
    self.curveView.transform = CGAffineTransformMakeRotation(M_PI * (diff*2/180));
    self.curveView.progress = MAX(0.0, MIN(fabs(y)/ self.frameHeight, 1.0));

    // trigger RefreshViewState Refreshing
    if (y <= criticalY && (self.refreshState == IHFRefreshViewStateWillRefresh) && !self.scrollView.isDragging) {
        [self setRefreshState:IHFRefreshViewStateRefreshing];
        return;
    }
    
    // trigger RefreshViewState Will Refresh
    if (y < criticalY && (self.refreshState == IHFRefreshViewStateNormal)) {
        [self setRefreshState:IHFRefreshViewStateWillRefresh];
        return;
    }
    
    // trigger RefreshViewState normal
    if (y > criticalY && self.scrollView.isDragging && (self.refreshState !=IHFRefreshViewStateNormal)) {
        [self setRefreshState:IHFRefreshViewStateNormal];
    }
}

#pragma mark - 

+ (instancetype)headerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation
 {
    IHFRefreshHeaderView *header = [[self alloc] init];
    header.refreshingOperation = refreshingOperation;
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
 {
    IHFRefreshHeaderView *header = [[self alloc] init];
    header.beginRefreshingTarget = target;
    header.beginRefreshingAction = action;
    return header;
}

@end
