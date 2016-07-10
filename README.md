# IHFRefresh
这是一个刷新控件，带有占位符刷新！


 ---------------------------------- 刷新 -------------------------------

1 . 下拉刷新

方法一

-(void)setupHeaderWithMethod1{
__weak __typeof(self) weakSelf = self;
_tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingOperation:^{
// refresh action
[weakSelf reloadTableViewData:nil];
}];
}

方法二


-(void)setupHeaderWithMethod2{

__weak __typeof(self) weakSelf = self;

_tableView.refreshHeader = [IHFRefreshHeaderView refreshView];

_tableView.refreshHeader.refreshingOperation = ^(){

[weakSelf reloadTableViewData:nil];
};
}

方法三


-(void)setupHeaderWithMethod3{

_tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(reloadTableViewData:)];
}


方法四

-(void)setupHeaderWithMethod4{

_tableView.refreshHeader = [IHFRefreshHeaderView refreshView];

[_tableView.refreshHeader addTarget:self refreshAction:@selector(reloadTableViewData:)];

}

2 上拉刷新（一般是加载更多）

方法一

-(void)setupFooterWithMethod1{

__weak __typeof(self) weakSelf = self;

_tableView.refreshFooter = [IHFRefreshFooterView refreshView];

_tableView.refreshFooter.refreshingOperation = ^(){
[weakSelf loadMore];
};
}

方法二

-(void)setupFooterWithMethod2{

__weak __typeof(self) weakSelf = self;

_tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingOperation:^{
[weakSelf loadMore];
}];
}

方法三

-(void)setupFooterWithMethod3{
_tableView.refreshFooter = [IHFRefreshFooterView refreshView];
[_tableView.refreshFooter addTarget:self refreshAction:@selector(loadMore)];
}

方法四


-(void)setupFooterWithMethod4{
_tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

---------------------------------- 占位符刷新 -------------------------------
// 占位符刷新值的是当请求数据是空的时候 会出现 提示文字 和 提示按钮 来！

刷新调用

[self.tableView reloadDataWithEmptyData];

// 样式是IHEmptyDataView.xib --- 可自己更换图片和按钮的样式
更改方法为 
方法1： 更改XIB
方法2： [self.tableView reloadDataWithEmptyDataViewTitle:@"没有数据®" buttonTitle:@"load"];


注意：
点击提示按钮会调用 下拉刷新方法
如果你想自定义调用方法

方法1： 

-(void)ifNeedcustomButtonClickAction1{

// If call the method , it will do the Block method , else it will do the header refresh method!

__weak __typeof(self) weakSelf = self;

_tableView.refreshOperation = ^(){
[weakSelf doCustomAction];
};

}

方法1： 

-(void)ifNeedcustomButtonClickAction2{

[_tableView addTarget:self refreshAction:@selector(doCustomAction)];

}

// 简书 ： http://www.jianshu.com/p/50252f14446b
// 有什么问题可以Issues： cjsykx@163.com
