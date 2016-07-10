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

-(void)emptyDataView:(IHEmptyDataView *)emptyData didClickRefreshBtn:(UIButton *)sender;
@end

@interface IHEmptyDataView : UIView
+(instancetype)emptyDataViewShowInView:(UIView *)view title:(NSString *)title buttonTitle:(NSString *)buttonTitle;

@property (weak,nonatomic) id <EmptyDataViewDelagete> delegate;

typedef void (^DidClickRefreshButtonOperation)();
@property (nonatomic,copy) DidClickRefreshButtonOperation didClickRefreshButtonOperation; // when click the refresh btn , to tell delegate to refresh
@end
