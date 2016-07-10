//
//  UITableView+IHF.h
//  nursing
//
//  Created by CjSon on 16/5/30.
//  Copyright © 2016年 IHEFE CO., LIMITED. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol IHFTableViewDelegate <UITableViewDelegate>
@end

@interface UITableView (IHF)

-(void)rotateCell:(UITableViewCell *)cell;
@property (nonatomic,assign) BOOL rotateAnimate;


@property (nonatomic,weak) id <IHFTableViewDelegate> IHFDelegate; /**< IHFTableView Delegate  */

@end
