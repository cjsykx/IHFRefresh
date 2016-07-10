//
//  IHFRefresh.h
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveView.h"

// refresh state
typedef NS_ENUM(NSUInteger, IHFRefreshViewState) {
    IHFRefreshViewStateNormal = 0x00,
    IHFRefreshViewStateWillRefresh = 0x01,
    IHFRefreshViewStateRefreshing  = 0x02,
    IHFRefreshViewStateAny,
};


#define IHFRefreshViewVersionOverIOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define IHFRefreshViewObservingkeyPath @"contentOffset"
#define IHFNavigationBarHeight 64

@interface IHFRefreshView : UIView

typedef void (^BeginRefreshingOperation)();

@property (nonatomic, copy) BeginRefreshingOperation refreshingOperation;

@property (nonatomic, weak) id beginRefreshingTarget;
@property (nonatomic, assign) SEL beginRefreshingAction;
@property (nonatomic, assign) BOOL isEffectedByNavigationController;

+ (instancetype)refreshView;

- (void)addTarget:(id)target refreshAction:(SEL)action;
- (void)endRefreshing;
- (void)beginRefreshing;

// normal state , defalut
@property (nonatomic, copy) NSString *textForNormalState;
@property (nonatomic, copy) NSString *textForWillRefreshState;
@property (nonatomic, copy) NSString *textForRefreshingState;

/** if you want more content off set after end refresh , defalut zore! */
//@property (assign ,nonatomic) CGFloat additionalContentOffsetY ;


@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) IHFRefreshViewState refreshState;

@property (nonatomic, assign) UIEdgeInsets scrollViewEdgeInsets;

@property (nonatomic, assign) UIEdgeInsets originalEdgeInsets; /**< record original edgeinsets */

@property (nonatomic, assign,getter=isManuallyRefreshing) BOOL manuallyRefreshing;

/** Get the new scrollView contentInset by increase a certain value on the basis of the original ontentInset */

- (UIEdgeInsets)newEdgeInsetsWithOriginalEdgeInsets:(UIEdgeInsets)edgeInsets;

@property (strong,nonatomic) CurveView *curveView;

@end
