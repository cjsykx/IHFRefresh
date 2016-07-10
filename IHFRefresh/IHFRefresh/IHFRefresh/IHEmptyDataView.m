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

+(instancetype)emptyDataViewLoadFromXib{
    
    IHEmptyDataView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

-(void)awakeFromNib{
}

+(instancetype)emptyDataViewShowInView:(UIView *)view title:(NSString *)title buttonTitle:(NSString *)buttonTitle{
    
    IHEmptyDataView *emptyView = [self emptyDataViewLoadFromXib];
    
    // If the title and buttonTitle is NIL , the title is defalut from the IHEmptyDataViewXIB
    if (title) emptyView.errorLabel.text = title;
    if (buttonTitle) [emptyView.refreshBtn setTitle:buttonTitle forState:UIControlStateNormal];
    emptyView.backgroundColor = view.backgroundColor;
    
    [emptyView setFrameX:(view.frameWidth - emptyView.frameWidth) * 0.5];
    [emptyView setFrameY:(view.frameHeight - emptyView.frameHeight) * 0.5];

    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    if(view.frameWidth > screenW){
        [emptyView setCenterX:screenW * 0.5];
    }
    
    [view addSubview:emptyView];
    
    return emptyView;
}

- (IBAction)didClickRefreshBtn:(id)sender {
        
    if (self.didClickRefreshButtonOperation) {
        self.didClickRefreshButtonOperation();
    }
}


@end
