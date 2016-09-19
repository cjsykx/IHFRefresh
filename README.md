# IHFRefresh


这是一个刷新控件，带有占位符刷新！

用法关键:
1.刷新:可以对TableView 和 CollectionView 进行刷新，一开始设置头部或者尾部并且刷新的方法，在刷新结束后调用[endRefresh] 进行结束
2:占位符:
调用 - (void)reloadDataWithEmptyData; 可以对 TableView 和 CollectionView 的数据加载， 如果数据源为空，则会根据IHEmptyDataView的样式出现对用户进行提醒。
可以调用 - (void)reloadDataWithEmptyDataViewTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle; 更改Title和Button的title对用户提示。
Button 默认做Headerview的加载，但是如果你要实现你的方法,可以使用  
```
_tableView.refreshOperation = ^(){
[weakSelf doCustomAction];
};
```
****
刷新 
****


****1 . 下拉刷新****

方法一: 使用block(一句话)

```
- (void)setupHeaderWithMethod1 {
__weak __typeof(self) weakSelf = self;
_tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingOperation:^{
// refresh action
[weakSelf reloadTableViewData:nil];
}];
}
```

方法二：使用Block(将上述的一句话分开)

```
- (void)setupHeaderWithMethod2 {

__weak __typeof(self) weakSelf = self;
_tableView.refreshHeader = [IHFRefreshHeaderView refreshView];
_tableView.refreshHeader.refreshingOperation = ^(){
// refresh action
[weakSelf reloadTableViewData:nil];
};
}
```
方法三：使用Perform action(一句话)

```
- (void)setupHeaderWithMethod3 {

_tableView.refreshHeader = [IHFRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(reloadTableViewData:)];
}
```

方法四: 使用Perform action(分开一句话)
```
- (void)setupHeaderWithMethod4 {

_tableView.refreshHeader = [IHFRefreshHeaderView refreshView];
[_tableView.refreshHeader addTarget:self refreshAction:@selector(reloadTableViewData:)];
}
```

> 1.可以使用 autoRefreshWhenViewDidAppear ， 在初次加载页面时进行一次下拉刷新
>2.可以调用beginRefreshing 进行一次刷新


****2 上拉刷新（一般是加载更多）****

方法一
```
- (void)setupFooterWithMethod1 {

__weak __typeof(self) weakSelf = self;

_tableView.refreshFooter = [IHFRefreshFooterView refreshView];

_tableView.refreshFooter.refreshingOperation = ^(){
[weakSelf loadMore];
};
}
```
方法二
```
- (void)setupFooterWithMethod2 {

__weak __typeof(self) weakSelf = self;

_tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingOperation:^{
[weakSelf loadMore];
}];
}
```
方法三
```
-(void)setupFooterWithMethod3{
_tableView.refreshFooter = [IHFRefreshFooterView refreshView];
[_tableView.refreshFooter addTarget:self refreshAction:@selector(loadMore)];
}
```
方法四

```
- (void)setupFooterWithMethod4 {
_tableView.refreshFooter = [IHFRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
```

> 注意:无论是上拉还是下拉刷新，在做完刷新操作后，都要调用endRefresh进行结束

****
占位符刷新
****

>  占位符刷新值的是当请求数据是空的时候 会出现 提示文字 和 提示按钮 来提示用户！

刷新调用
```
[self.tableView reloadDataWithEmptyData];
```
// 样式是IHEmptyDataView.xib --- 可自己更换图片和按钮的样式
更改方法为 
方法1： 更改XIB （不推荐）
方法2： 
```
//使用该方法来刷新数据源
[self.tableView reloadDataWithEmptyDataViewTitle:@"没有数据®" buttonTitle:@"load"];
```

注意：
点击提示按钮会调用 下拉刷新方法
如果你想自定义调用方法

方法1： 
```
- (void)ifNeedcustomButtonClickAction1 {

// If call the method , it will do the Block method , else it will do the header refresh method!
__weak __typeof(self) weakSelf = self;

_tableView.refreshOperation = ^(){
[weakSelf doCustomAction];
};
}
```
方法2： 
```
-(void)ifNeedcustomButtonClickAction2{
[_tableView addTarget:self refreshAction:@selector(doCustomAction)];
}
```
// 简书 ： http://www.jianshu.com/p/50252f14446b
// 有什么问题可以Issues： cjsykx@163.com
