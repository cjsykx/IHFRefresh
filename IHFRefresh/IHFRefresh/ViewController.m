//
//  ViewController.m
//  IHFRefresh
//
//  Created by CjSon on 16/4/23.
//  Copyright © 2016年 ihefe. All rights reserved.
//

#import "ViewController.h"
#import "UIView+IHF.h"
#import "IHFRefresh.h"
#import "TempViewController.h"
#import "CurveView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray *data;

@property (weak,nonatomic) UITableView *tableView;

@property (assign,nonatomic) BOOL flag;
@property (assign,nonatomic) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame =CGRectMake(0, 10, 44, 44);
    [button addTarget:self action:@selector(reloadTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 64, self.view.frameWidth, self.view.frameHeight - 64);
    
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    
    [self setupHeaderWithMethod4];
    [self setupFooterWithMethod4];
    
    [self ifNeedcustomButtonClickAction2];

    
    // text custom set by your self !
    _tableView.refreshFooter.textForNormalState = @"获取前一天医嘱";
    _tableView.refreshFooter.textForWillRefreshState = @"松开可以获取前一天医嘱";
    _tableView.refreshFooter.textForRefreshingState = @"正在获取前一天医嘱";    
}

#pragma mark - set header method

-(void)setupHeaderWithMethod1{
    __weak __typeof(self) weakSelf = self;
    _tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingOperation:^{
        
        [weakSelf reloadTableViewData:nil];
    }];
}

-(void)setupHeaderWithMethod2{
    
    __weak __typeof(self) weakSelf = self;

    _tableView.refreshHeader = [IHFRefreshHeaderView refreshView];

    _tableView.refreshHeader.refreshingOperation = ^(){
        
        [weakSelf reloadTableViewData:nil];
    };
}

-(void)setupHeaderWithMethod3{

    _tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(reloadTableViewData:)];
}


-(void)setupHeaderWithMethod4{
    
    _tableView.refreshHeader = [IHFRefreshHeaderView refreshView];

    [_tableView.refreshHeader addTarget:self refreshAction:@selector(reloadTableViewData:)];

}



#pragma mark - set footer method

-(void)setupFooterWithMethod1{

    __weak __typeof(self) weakSelf = self;

    _tableView.refreshFooter = [IHFRefreshFooterView refreshView];

    _tableView.refreshFooter.refreshingOperation = ^(){
        [weakSelf loadMore];
    };
}

-(void)setupFooterWithMethod2{

    __weak __typeof(self) weakSelf = self;

    _tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingOperation:^{
        [weakSelf loadMore];
    }];
}

-(void)setupFooterWithMethod3{
    _tableView.refreshFooter = [IHFRefreshFooterView refreshView];
    [_tableView.refreshFooter addTarget:self refreshAction:@selector(loadMore)];
}

-(void)setupFooterWithMethod4{
    _tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark - ifNeedcustomButtonClickAction
-(void)ifNeedcustomButtonClickAction1{
    
    // If call the method , it will do the Block method , else it will do the header refresh method!
    
    __weak __typeof(self) weakSelf = self;

    _tableView.refreshOperation = ^(){
        [weakSelf doCustomAction];
    };

}
-(void)ifNeedcustomButtonClickAction2{
    
    [_tableView addTarget:self refreshAction:@selector(doCustomAction)];

}

-(void)loadMore{
    
    self.count = self.count + 5;
    [self.tableView reloadDataWithEmptyData];
    [self.tableView.refreshFooter endRefreshing];
}

-(void)reloadTableViewData:(UIButton *)sender{
    
    self.flag = !self.flag;
    self.count = self.flag ? 100 : 0;
    
    // the title and buttonTitle by your set!
    [self.tableView reloadDataWithEmptyDataViewTitle:@"没有数据®" buttonTitle:@"load"];
    
    // default by XIB
//    [self.tableView reloadDataWithEmptyData];
    
    [self.tableView.refreshHeader endRefreshing];
}

-(void)doCustomAction{
    NSLog(@"is do your custom action!");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %d",indexPath.section,indexPath.row];
    return cell;
}
@end
