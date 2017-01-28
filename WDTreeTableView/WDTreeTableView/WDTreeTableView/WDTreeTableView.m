//
//  WDTreeTableView.m
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "WDTreeTableView.h"
#import "TreeNodeController.h"
#import "WDTreeNodeDataController.h"

@interface WDTreeTableView () <UITableViewDataSource, UITableViewDelegate, WDTreeNodeDataControllerDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WDTreeNodeDataController *dataController;

@end

@implementation WDTreeTableView

- (void)setupTreeStructure
{
    self.dataController = [[WDTreeNodeDataController alloc] init];
    self.dataController.dataSource = self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        CGRect tableViewF = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self tableViewInitWithFrame:tableViewF style:style];
        [self setupTreeStructure];
    }
    
    return self;
}

- (void)tableViewInitWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    UITableView *tableView =  [[UITableView alloc] initWithFrame:frame style:style];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - 注册
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}


#pragma mark - 刷新数据
- (void)reloadData
{
    [self setupTreeStructure];
    [self.tableView reloadData];
}

- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexes = [NSMutableArray array];
    for (id item in items) {
        NSIndexPath *indexPath = [self indexPathForItem:item];
        [indexes addObject:indexPath];
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:animation];
}

#pragma mark - TableView操作
- (void)beginUpdates
{
    [self.tableView beginUpdates];
}
- (void)endUpdates
{
    [self.tableView endUpdates];
}

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(UITableViewRowAnimation)animation
{
    if (parent && ![self isCellForItemExpanded:parent]) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [weakSelf insertItemAtIndex:idx inParent:parent withAnimation:animation];
    }];
}

- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(UITableViewRowAnimation)animation
{
    if (parent && ![self isCellForItemExpanded:parent]) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [weakSelf removeItemAtIndex:idx inParent:parent withAnimation:animation];
    }];
}

- (void)insertItemAtIndex:(NSInteger)index inParent:(id)parent withAnimation:(UITableViewRowAnimation)animation
{
    NSInteger idx = [self.dataController indexForItem:parent];
    if (idx == NSNotFound) {
        return;
    }
    idx += index + 1;
    
    [self.dataController insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent];
        
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)removeItemAtIndex:(NSInteger)index inParent:(id)parent withAnimation:(UITableViewRowAnimation)animation
{
    id child = [self.dataController childInParent:parent atIndex:index];
    NSInteger idx = [self.dataController lastVisibleDescendantIndexForItem:child];
    if (idx == NSNotFound) {
        return;
    }
    
    [self.dataController removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent updates:^(NSIndexSet *removedIndexes) {
        [self.tableView deleteRowsAtIndexPaths:IndexesToIndexPaths(removedIndexes) withRowAnimation:animation];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataController.numberOfVisibleRowsForItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource) {
        TreeNode *node = [self.dataController treeNodeForIndex:indexPath.row];
        return [self.dataSource treeView:self cellForItem:node.item];
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode *treeNode = [self.dataController treeNodeForIndex:indexPath.row];

    if ([self.delegate respondsToSelector:@selector(treeView:didSelectRowForItem:)]) {
        [self.delegate treeView:self didSelectRowForItem:treeNode.item];
    }
    
    // 先判断是否为叶子节点
    if ([self treeNodeDataController:self.dataController numberOfChildrenForItem:treeNode.item] == 0) {
        if ([self.delegate respondsToSelector:@selector(treeView:didSelectRowOfLastItem:)]) {
            [self.delegate treeView:self didSelectRowOfLastItem:treeNode.item];
        }
        return;
    }

    if (treeNode.expanded) {
        if ([self.delegate respondsToSelector:@selector(treeView:shouldCloseRowForItem:)]) {
            if ([self.delegate treeView:self shouldCloseRowForItem:treeNode.item]) {
                [self closeCellForTreeNode:treeNode];
            }
        } else {
            [self closeCellForTreeNode:treeNode];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(treeView:shouldOpenRowForItem:)]) {
            if ([self.delegate treeView:self shouldOpenRowForItem:treeNode.item]) {
                [self openCellForTreeNode:treeNode];
            }
        } else {
            [self openCellForTreeNode:treeNode];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode *treeNode = [self.dataController treeNodeForIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(treeView:heightForRowForItem:)]) {
        return [self.delegate treeView:self heightForRowForItem:treeNode.item];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode *treeNode = [self.dataController treeNodeForIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(treeView:estimatedHeightForRowForItem:)]) {
        return [self.delegate treeView:self estimatedHeightForRowForItem:treeNode.item];
    }
    return 44;
}

#pragma mark - WDTreeNodeDataControllerDataSource
- (NSInteger)treeNodeDataController:(WDTreeNodeDataController *)controller numberOfChildrenForItem:(id)item
{
    if (self.dataSource) {
        return [self.dataSource treeView:self numberOfChildrenOfItem:item];
    }
    return 0;
}

- (id)treeNodeDataController:(WDTreeNodeDataController *)controller child:(NSInteger)childIndex ofItem:(id)item
{
    if (self.dataSource) {
        return [self.dataSource treeView:self child:childIndex ofItem:item];
    }
    return nil;
}

#pragma mark - WDTreeNodeDataController方法
- (NSIndexPath *)indexPathForItem:(id)item
{
    return [NSIndexPath indexPathForRow:[self.dataController indexForItem:item] inSection:0];
}

- (BOOL)isCellForItemExpanded:(id)item
{
    NSIndexPath *indexPath = [self indexPathForItem:item];
    return [self.dataController treeNodeForIndex:indexPath.row].expanded;
}

- (BOOL)isCellExpanded:(UITableViewCell *)cell
{
    id item = [self itemForCell:cell];
    return [self isCellForItemExpanded:item];
}

- (UITableViewCell *)cellForItem:(id)item
{
    NSIndexPath *indexPath = [self indexPathForItem:item];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (NSArray *)visibleCells
{
    return [self.tableView visibleCells];
}

- (id)itemForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return  [self.dataController treeNodeForIndex:indexPath.row].item;
}

#pragma mark - 展开关闭
- (void)openCellForTreeNode:(TreeNode *)node
{
    
    if ([self.delegate respondsToSelector:@selector(treeView:willOpenRowForItem:)]) {
        [self.delegate treeView:self willOpenRowForItem:node.item];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(treeView:didOpenRowForItem:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate treeView:self didOpenRowForItem:node.item];
            });
        }
    }];
    [self openCellForTreeNode:node withRowAnimation:UITableViewRowAnimationTop];
    
    [CATransaction commit];
}

- (void)openCellForTreeNode:(TreeNode *)node withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    [self.tableView beginUpdates];
    
    [self.dataController openRowForItem:node.item updates:^(NSIndexSet *insertions) {
        [self.tableView insertRowsAtIndexPaths:IndexesToIndexPaths(insertions) withRowAnimation:rowAnimation];
    }];
    
    
    [self.tableView endUpdates];
}

- (void)closeCellForTreeNode:(TreeNode *)node
{
    if ([self.delegate respondsToSelector:@selector(treeView:willCloseRowForItem:)]) {
        [self.delegate treeView:self willCloseRowForItem:node.item];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(treeView:didCloseRowForItem:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate treeView:self didCloseRowForItem:node.item];
            });
        }
    }];
    [self closeCellForTreeNode:node withRowAnimation:UITableViewRowAnimationBottom];
    
    [CATransaction commit];
}

- (void)closeCellForTreeNode:(TreeNode *)node withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    [self.tableView beginUpdates];
    
    [self.dataController closeRowForItem:node.item updates:^(NSIndexSet *insertions) {
        [self.tableView deleteRowsAtIndexPaths:IndexesToIndexPaths(insertions) withRowAnimation:rowAnimation];
    }];
    
    
    [self.tableView endUpdates];
}

static NSArray *IndexesToIndexPaths(NSIndexSet *indexes)
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    return [indexPaths copy];
}


@end
