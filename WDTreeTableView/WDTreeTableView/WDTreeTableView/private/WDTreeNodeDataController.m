//
//  WDTreeNodeDataController.m
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/29.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "WDTreeNodeDataController.h"
#import "TreeNode.h"
#import "TreeNodeController.h"

@interface WDTreeNodeDataController ()

@property (nonatomic, strong) TreeNodeController *rootNodeController;

@end

@implementation WDTreeNodeDataController
#pragma mark - 懒加载
- (TreeNodeController *)rootNodeController
{
    if (!_rootNodeController) {
        _rootNodeController = [[TreeNodeController alloc] initWithParent:nil item:[[TreeNode alloc] initWithItem:nil]];
        _rootNodeController.node.expanded = YES;
        
        NSInteger numberOfChildren = [self.dataSource treeNodeDataController:self numberOfChildrenForItem:nil];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
        NSArray *childControllers = [self controllersForNodesWithIndexes:indexSet inParentController:_rootNodeController];
        
        [_rootNodeController insertChildControllers:childControllers atIndexes:indexSet];
    }
    
    return _rootNodeController;
}

- (NSArray *)controllersForNodesWithIndexes:(NSIndexSet *)indexSet inParentController:(TreeNodeController *)parentController
{
    NSMutableArray *currentControllers = [NSMutableArray array];
    
    // 遍历创建子节点控制器
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        TreeNodeController *controller;
        TreeNodeController *oldControllerForCurrentIndex = nil;
        
        // 获取当前parentController下idx位置的数据对象
        id item = [self.dataSource treeNodeDataController:self child:idx ofItem:parentController.node.item];
        
        for (TreeNodeController *controller in parentController.childNodeControllers) {
            if ([controller.node.item isEqual:item]) {
                oldControllerForCurrentIndex = controller;
                break;
            }
        }
        
        if (oldControllerForCurrentIndex != nil) {
            controller = oldControllerForCurrentIndex;
        } else
        {
            controller = [[TreeNodeController alloc] initWithParent:parentController item:[[TreeNode alloc] initWithItem:item]];
        }
        
        [currentControllers addObject:controller];
    }];
    
    return [currentControllers copy];
}

- (NSInteger)numberOfVisibleRowsForItems
{
    return self.rootNodeController.numberOfVisible;
}

- (TreeNode *)treeNodeForIndex:(NSInteger)index
{
    return [self nodeControllerForIndex:index].node;
}

- (TreeNodeController *)nodeControllerForIndex:(NSInteger)index
{
    return [self.rootNodeController controllerForIndex:index];
}

- (NSInteger)levelForItem:(id)item
{
    return [self.rootNodeController controllerForItem:item].level;
}

- (id)parentForItem:(id)item
{
    
    TreeNodeController *controller = [self.rootNodeController controllerForItem:item];
    return controller.parentNodeController.node.item;
}

- (id)childInParent:(id)parent atIndex:(NSInteger)index
{
    TreeNodeController *controller = [self.rootNodeController controllerForItem:parent].childNodeControllers[index];
    return controller.node.item;
}

- (NSInteger)indexForItem:(id)item
{
    return 0;
}

- (NSInteger)lastVisibleDescendantIndexForItem:(id)item
{
    return [self.rootNodeController lastVisibleIndexForItem:item];
}

#pragma mark - 展开关闭
- (void)openRowForItem:(id)item updates:(void (^)(NSIndexSet *))updates
{
    NSParameterAssert(updates);
    
    TreeNodeController *controller = [self.rootNodeController controllerForItem:item];
    controller.node.expanded = true;
    
    NSMutableArray *oldChildItems = [NSMutableArray array];
    for (TreeNodeController *nodeController in controller.childNodeControllers) {
        [oldChildItems addObject:nodeController.node.item];
    }
    
    NSInteger numberOfChildren = [self.dataSource treeNodeDataController:self numberOfChildrenForItem:item];
    NSIndexSet *allIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
    
    NSArray *currentChildControllers = [self controllersForNodesWithIndexes:allIndexes inParentController:controller];
    
    NSMutableArray *childControllersToInsert = [NSMutableArray array];
    NSMutableIndexSet *indexesForInsertions = [NSMutableIndexSet indexSet];
    NSMutableArray *childControllersToRemove = [NSMutableArray array];
    NSMutableIndexSet *indexesForDeletions = [NSMutableIndexSet indexSet];
    
    for (TreeNodeController *loopNodeController in currentChildControllers) {
        if (![controller.childNodeControllers containsObject:loopNodeController]
            && ![oldChildItems containsObject:controller.node.item]) {
            [childControllersToInsert addObject:loopNodeController];
            NSInteger index = [currentChildControllers indexOfObject:loopNodeController];
            NSAssert(index != NSNotFound, nil);
            [indexesForInsertions addIndex:index];
        }
    }
    
    for (TreeNodeController *loopNodeController in controller.childNodeControllers) {
        if (![currentChildControllers containsObject:loopNodeController]
            && ![childControllersToInsert containsObject:loopNodeController]) {
            [childControllersToRemove addObject:loopNodeController];
            NSInteger index = [controller.childNodeControllers indexOfObject:loopNodeController];
            NSAssert(index != NSNotFound, nil);
            [indexesForDeletions addIndex:index];
        }
    }
    
    [controller removeChildControllersAtIndexes:indexesForDeletions];
    [controller insertChildControllers:childControllersToInsert atIndexes:indexesForInsertions];

    updates(controller.childrenIndexes);
}

- (void)closeRowForItem:(id)item updates:(void (^)(NSIndexSet *))updates
{
    NSParameterAssert(updates);
    
    TreeNodeController *parentController = [self.rootNodeController controllerForItem:item];
    
    NSIndexSet *deletions = parentController.childrenIndexes;
    [parentController close];
    
    updates(deletions);
}

#pragma mark - 插入移动删除
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item
{
    TreeNodeController *parentController = [self.rootNodeController controllerForItem:item];
    NSArray *newControllers = [self controllersForNodesWithIndexes:indexes inParentController:parentController];
    [parentController insertChildControllers:newControllers atIndexes:indexes];
}

- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void (^)(NSIndexSet *, NSIndexSet *))updates
{
    NSParameterAssert(updates);
    
    NSMutableIndexSet *removedIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
    
    TreeNodeController *parentController = [self.rootNodeController controllerForItem:parent];
    
    // 同一颗子树
    if (parent == newParent) {
        [parentController moveChildControllerAtIndex:index toIndex:newIndex];
    } else {
        
        TreeNodeController *childController = parentController.childNodeControllers[index];
        
        [removedIndexes addIndex:childController.index];
        // 需要把该节点的子节点也一并移动
        [removedIndexes addIndexes:childController.childrenIndexes];
        [parentController removeChildControllersAtIndexes:[NSIndexSet indexSetWithIndex:index]];

        TreeNodeController *newParentController = [self.rootNodeController controllerForItem:parent];
        [newParentController insertChildControllers:@[childController] atIndexes:[NSIndexSet indexSetWithIndex:newIndex]];
        
        [addedIndexes addIndex:childController.index];
        [addedIndexes addIndexes:childController.childrenIndexes];
    }
    
    updates(removedIndexes, addedIndexes);
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item updates:(void (^)(NSIndexSet *))updates
{
    TreeNodeController *parentController = [self.rootNodeController controllerForItem:item];
    
    NSMutableIndexSet *indexesToRemoval = [NSMutableIndexSet indexSet];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        TreeNodeController *controller = parentController.childNodeControllers[idx];
        [indexesToRemoval addIndex:controller.index];
        [indexesToRemoval addIndexes:controller.childrenIndexes];
    }];
    
    [parentController removeChildControllersAtIndexes:indexes];
    
    updates(indexesToRemoval);
}

@end
