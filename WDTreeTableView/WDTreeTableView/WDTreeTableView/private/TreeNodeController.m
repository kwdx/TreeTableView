//
//  TreeNodeController.m
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "TreeNodeController.h"

@interface TreeNodeController ()

@property (nonatomic, strong) NSMutableArray *mutableChildController;

@end

@implementation TreeNodeController

- (instancetype)initWithParent:(TreeNodeController *)parentController item:(TreeNode *)node {
    if (self = [super init]) {
        [self invalidate];
        if (parentController) {
            _level = parentController.level + 1;
        } else
            _level = 1;
        _parentNodeController = parentController;
        _node = node;
        _mutableChildController = [NSMutableArray array];
    }
    
    return self;
}

- (void)insertChildControllers:(NSArray *)childControllers atIndexes:(NSIndexSet *)indexSet
{
    [self invalidateTreeNodesAfterChildAtIndex:[indexSet firstIndex] - 1];
    if (indexSet.count == 0) {
        return;
    }
    [self.mutableChildController insertObjects:childControllers atIndexes:indexSet];
}

- (void)close
{
    [self privateCollapse];
}

- (void)privateCollapse
{
    self.node.expanded = false;
    [self invalidate];
    
    [self.parentNodeController invalidateTreeNodesAfterChildAtIndex:[self.parentNodeController.childNodeControllers indexOfObject:self]];
}


- (void)removeChildControllersAtIndexes:(NSIndexSet *)indexSet
{
    [self invalidateTreeNodesAfterChildAtIndex:[indexSet firstIndex] - 1];
    if (indexSet.count == 0) {
        return;
    }
    [self.mutableChildController removeObjectsAtIndexes:indexSet];
}

- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    if (index == newIndex) {
        return;
    }
    id controller = self.mutableChildController[index];
    [self.mutableChildController removeObjectAtIndex:index];
    [self.mutableChildController insertObject:controller atIndex:index];
    [self invalidateTreeNodesAfterChildAtIndex:MIN(index, newIndex)-1];
}



- (NSInteger)numberOfVisible
{
    if (_numberOfVisible == NSIntegerMin) {
        if (self.node.expanded) {
            NSInteger numberOfVisibleDescendants = [self.childNodeControllers count];
            for (TreeNodeController *controller in self.childNodeControllers) {
                numberOfVisibleDescendants += controller.numberOfVisible;
            }
            _numberOfVisible = numberOfVisibleDescendants;
        } else {
            _numberOfVisible = 0;
        }
    }
    return _numberOfVisible;
}

- (NSArray *)childNodeControllers
{
    return self.mutableChildController;
}

/**
 重置属性
 */
- (void)invalidate
{
    _numberOfVisible = NSIntegerMin;
    _index = NSIntegerMin;
}

- (void)invalidateTreeNodesAfterChildAtIndex:(NSInteger)index
{
    NSInteger selfIndex = [self.parentNodeController.childNodeControllers indexOfObject:self];
    [self.parentNodeController invalidateTreeNodesAfterChildAtIndex:selfIndex];
    
    [self invalidate];
    [self invalidateChildrensNodesAfterChildAtIndex:index];
}

- (void)invalidateChildrensNodesAfterChildAtIndex:(NSInteger)index
{
    for (NSInteger i = index + 1; i < self.childNodeControllers.count; i++) {
        TreeNodeController *controller = self.childNodeControllers[i];
        [controller invalidate];
        [controller invalidateChildrensNodesAfterChildAtIndex:-1];
    }
}

- (TreeNodeController *)controllerForIndex:(NSInteger)index
{
    if (self.index == index) {
        return self;
    }
    
    if (!self.node.expanded) {
        return nil;
    }
    
    for (TreeNodeController *controller in self.childNodeControllers) {
        TreeNodeController *result = [controller controllerForIndex:index];
        if (result) {
            return result;
        }
    }
    
    return nil;
}

- (TreeNodeController *)controllerForItem:(id)item
{
    if (item == self.node.item) {
        return self;
    }
    
    for (TreeNodeController *controller in self.childNodeControllers) {
        TreeNodeController *result = [controller controllerForItem:item];
        if (result) {
            return result;
        }
    }
    
    return nil;
}

- (NSInteger)index
{
    if (_index != NSIntegerMin) {
        return _index;
    }
    if (!self.parentNodeController) {
        _index = -1;
        
    } else if (!self.parentNodeController.node.expanded) {
        _index = NSNotFound;
        
    } else {
        NSInteger indexInParent = [self.parentNodeController.childNodeControllers indexOfObject:self];
        if (indexInParent != 0) {
            TreeNodeController *controller = self.parentNodeController.childNodeControllers[indexInParent-1];
            _index =  [controller lastVisibleIndex] + 1;
            
        } else {
            _index = self.parentNodeController.index + 1;
        }
    }
    return _index;
}

- (NSInteger)lastVisibleIndex
{
    return self.index + self.numberOfVisible;
}

- (NSInteger)lastVisibleIndexForItem:(id)item
{
    if (self.node.item == item) {
        return [self lastVisibleIndex];
    }
    
    for (TreeNodeController *nodeController in self.childNodeControllers) {
        NSInteger lastIndex = [nodeController lastVisibleIndexForItem:item];
        if (lastIndex != NSNotFound) {
            return lastIndex;
        }
    }
    
    return NSNotFound;
}

- (NSIndexSet *)childrenIndexes
{
    NSInteger numberOfVisible = self.numberOfVisible;
    NSInteger startIndex = self.index + 1;
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSInteger i = startIndex; i < startIndex + numberOfVisible; i++) {
        [indexSet addIndex:i];
    }
    return [indexSet copy];
}

@end
