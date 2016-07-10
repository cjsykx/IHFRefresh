//
//  IHFRefreshFooterView.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "IHFRefreshFooterView.h"
#import "UIView+IHF.h"

@interface IHFRefreshFooterView ()
@property (assign,nonatomic) CGFloat originalScrollViewContentHeight;
@end

@implementation IHFRefreshFooterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textForNormalState = @"上拉可以加载最新数据";
        self.textForRefreshingState = @"正在加载最新数据,请稍候";
        self.textForWillRefreshState = @"松开即可加载最新数据";
        [self setRefreshState:IHFRefreshViewStateNormal];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.activityIndicatorView.hidden = YES;
    _originalScrollViewContentHeight = self.scrollView.contentSize.height;
    
    CGFloat refreshWidth = self.scrollView.frameWidth;
    
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    if(self.scrollView.frameWidth > screenW){
        refreshWidth = screenW;
    }

    self.center = CGPointMake(refreshWidth * 0.5, self.scrollView.contentSize.height + self.frameHeight * 0.5); // + self.scrollView.contentInset.bottom
    self.hidden = [self shouldHide];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.scrollViewEdgeInsets = UIEdgeInsetsMake(0, 0, self.frameHeight, 0);
}

- (BOOL)shouldHide{
    if (self.isEffectedByNavigationController) {
        return (self.scrollView.bounds.size.height - IHFNavigationBarHeight > self.frameY); //  + self.scrollView.contentInset.bottom
    }
    return (self.scrollView.bounds.size.height> self.frameY); // + self.scrollView.contentInset.bottom
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (![keyPath isEqualToString:IHFRefreshViewObservingkeyPath] || self.refreshState == IHFRefreshViewStateRefreshing) return;
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    CGFloat criticalY = self.scrollView.contentSize.height - self.scrollView.frameHeight + self.frameHeight + self.scrollView.contentInset.bottom;
    
    // if have load more data , cause the scroll view content change , it need to layout footer position
    if (self.scrollView.contentSize.height != _originalScrollViewContentHeight) {
        [self layoutSubviews];
    }
    
    // if the y<=0 AND scrollview height is not 0 ,can do refresh
    if ((y <= 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    self.curveView.progress = MAX(0.0, MIN((y - (self.scrollView.contentSize.height - self.scrollView.frameHeight)) / self.frameHeight, 1.0));
    
    // trigger RefreshViewState Refreshing
    if (y <= criticalY && (self.refreshState == IHFRefreshViewStateWillRefresh) && !self.scrollView.isDragging) {
        [self setRefreshState:IHFRefreshViewStateRefreshing];
        return;
    }
    
    // trigger RefreshViewState will refresh
    if (y > criticalY && (IHFRefreshViewStateNormal == self.refreshState)) {
        if (self.hidden) return;
        [self setRefreshState:IHFRefreshViewStateWillRefresh];
        return;
    }
    
    //trigger RefreshViewState normal
    if (y <= criticalY && self.scrollView.isDragging && (IHFRefreshViewStateNormal != self.refreshState)) {
        [self setRefreshState:IHFRefreshViewStateNormal];
    }
}

#pragma mark - 
+ (instancetype)footerWithRefreshingOperation:(BeginRefreshingOperation)refreshingOperation
{
    IHFRefreshFooterView *footer = [[self alloc] init];
    footer.refreshingOperation = refreshingOperation;
    return footer;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    IHFRefreshFooterView *footer = [[self alloc] init];
    footer.beginRefreshingTarget = target;
    footer.beginRefreshingAction = action;
    return footer;
}

-(void)dealloc {
//    [self removeFromSuperview];
}

@end
