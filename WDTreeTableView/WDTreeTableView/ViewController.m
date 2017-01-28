//
//  ViewController.m
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "ViewController.h"
#import "Country.h"
#import "Province.h"
#import "City.h"
#import "CountryCell.h"
#import "ProvinceCell.h"
#import "CityCell.h"
#import "TreeObj.h"
#import "WDTreeCell.h"

#import "WDTreeTableView.h"


@interface ViewController () <WDTreeViewDataSource, WDTreeViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        
        // 1.获取资源文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        
        // 2.转换成数组
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        
        // 3.字典数据 -> 模型数据
        NSMutableArray *muArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            Country *country = [Country countryWithDict:dict];
            [muArr addObject:country];
        }
        
        // 4.深拷贝
        _dataArr = [muArr copy];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WDTreeTableView *treeView = [[WDTreeTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    treeView.dataSource = self;
    treeView.delegate = self;
    [treeView registerNib:[UINib nibWithNibName:@"CountryCell" bundle:nil] forCellReuseIdentifier:@"Country"];
    [treeView registerNib:[UINib nibWithNibName:@"ProvinceCell" bundle:nil] forCellReuseIdentifier:@"Province"];
    [treeView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:@"City"];
    [self.view addSubview:treeView];
    
}

#pragma mark - WDTreeViewDataSource
- (NSInteger)treeView:(WDTreeTableView *)treeView numberOfChildrenOfItem:(id)item
{
    if (!item) {
        return self.dataArr.count;
    } else
    {
        TreeObj *obj = (TreeObj *)item;
        return obj.childrenCount;
    }
    return 0;
}

- (id)treeView:(WDTreeTableView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return self.dataArr[index];
    }
    TreeObj *obj = (TreeObj *)item;
    return [obj childAtIndex:index];
}

- (UITableViewCell *)treeView:(WDTreeTableView *)treeView cellForItem:(id)item {
    NSString *identifier = [NSString stringWithUTF8String:object_getClassName(item)];
    WDTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:identifier];
    [cell setDataModel:item];
    
    return cell;
}

#pragma mark - WDTreeViewDelegate
- (void)treeView:(WDTreeTableView *)treeView didOpenRowForItem:(id)item
{
    NSLog(@"已经打开节点");
}
    
- (void)treeView:(WDTreeTableView *)treeView didCloseRowForItem:(id)item
{
    NSLog(@"已经关闭关闭节点");
}

- (void)treeView:(WDTreeTableView *)treeView didSelectRowForItem:(id)item
{
    NSLog(@"点击了节点");
}
    
- (void)treeView:(WDTreeTableView *)treeView didSelectRowOfLastItem:(id)item
{
    NSLog(@"点击了叶子节点");
}
 
- (void)treeView:(WDTreeTableView *)treeView willOpenRowForItem:(id)item
{
    NSLog(@"即将打开节点");
}

- (void)treeView:(WDTreeTableView *)treeView willCloseRowForItem:(id)item
{
    NSLog(@"即将关闭节点");
}

- (BOOL)treeView:(WDTreeTableView *)treeView shouldOpenRowForItem:(id)item
{
    NSLog(@"是否允许打开节点");
    return YES;
}

- (BOOL)treeView:(WDTreeTableView *)treeView shouldCloseRowForItem:(id)item
{
    NSLog(@"是否允许关闭节点");
    return YES;
}
    
- (CGFloat)treeView:(WDTreeTableView *)treeView heightForRowForItem:(id)item
{
    return 50;
}
    
@end
