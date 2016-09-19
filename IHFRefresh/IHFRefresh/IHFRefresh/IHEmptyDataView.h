//
//  IHEmptyDataView.h
//  nurse
//
//  Created by CjSon on 16/4/20.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IHEmptyDataView;
@protocol EmptyDataViewDelagete <NSObject>

@optional

- (void)emptyDataView:(IHEmptyDataView *)emptyData didClickRefreshBtn:(UIButton *)sender;
@end

@interface IHEmptyDataView : UIView

/**
 Empty data view add in view 
 
 @title : The title can be nil , if nil , default use the title from IHEmptyDataview.xib
 @buttonTitle : The buttonTitle can be nil , if nil , default use the buttonTitle from IHEmptyDataview.xib
 */
+ (instancetype)emptyDataViewShowInView:(UIView *)view title:(NSString *)title buttonTitle:(NSString *)buttonTitle;

/**
 Show with animation
 */
- (void)showAnimationInView:(UIView *)inView;
- (void)hide;


@property (weak,nonatomic) id <EmptyDataViewDelagete> delegate;

typedef void (^DidClickRefreshButtonOperation)();
@property (nonatomic,copy) DidClickRefreshButtonOperation didClickRefreshButtonOperation; // when click the refresh btn , to tell delegate to refresh
@end
