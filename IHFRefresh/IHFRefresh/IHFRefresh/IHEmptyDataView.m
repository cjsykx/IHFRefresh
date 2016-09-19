//
//  IHEmptyDataView.m
//  nurse
//
//  Created by CjSon on 16/4/20.
//  Copyright © 2016年 ihefe. All rights reserved.
//
#import "IHEmptyDataView.h"
#import "UIView+IHF.m"
@interface IHEmptyDataView ()
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@end

@implementation IHEmptyDataView

+ (instancetype)emptyDataViewLoadFromXib {
    
    IHEmptyDataView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

+ (instancetype)emptyDataViewShowInView:(UIView *)view title:(NSString *)title buttonTitle:(NSString *)buttonTitle {
    
    IHEmptyDataView *emptyView = [self emptyDataViewLoadFromXib];
    
    // If the title and buttonTitle is NIL , the title is defalut from the IHEmptyDataViewXIB
    if (title) emptyView.errorLabel.text = title;
    if (buttonTitle) [emptyView.refreshBtn setTitle:buttonTitle forState:UIControlStateNormal];
    emptyView.backgroundColor = view.backgroundColor;
    
    [emptyView setFrameX:(view.frameWidth - emptyView.frameWidth) * 0.5];
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    if(view.frameWidth > screenW) {
        [emptyView setCenterX:screenW * 0.5];
    }
    
    [view addSubview:emptyView];

    [emptyView showAnimationInView:view];
    
    return emptyView;
}

- (void)showAnimationInView:(UIView *)inView {

    // Show
    self.hidden = NO;
    
    // begin Animation
    __weak typeof(self) weakSelf = self;
    self.center = CGPointMake(inView.center.x, -self.bounds.size.height * 0.5);
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        weakSelf.transform = CGAffineTransformMakeRotation(0);
        [weakSelf setFrameY:(inView.frameHeight - self.frameHeight) * 0.5];

    } completion:nil];
}

- (void)hide{
    self.hidden = YES;
}

- (IBAction)didClickRefreshBtn:(id)sender {
        
    if (self.didClickRefreshButtonOperation) {
        self.didClickRefreshButtonOperation();
    }
}

@end
