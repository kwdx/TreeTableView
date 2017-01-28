//
//  TreeNodeController.h
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface TreeNodeController : NSObject

/**
 该节点控制下的可视节点个数
 */
@property (assign, nonatomic) NSInteger numberOfVisible;

/**
 该节点控制器下的子节点控制器
 */
@property (strong, nonatomic, readonly) NSArray *childNodeControllers;

/**
 节点控制器对应的节点
 */
@property (strong, nonatomic, readonly) TreeNode *node;

/**
 父节点控制器
 */
@property (weak, nonatomic) TreeNodeController *parentNodeController;

/**
 当前的层级
 */
@property (assign, nonatomic, readonly) NSInteger level;

/**
 当前节点在tableview中的index
 */
@property (assign, nonatomic) NSInteger index;

/**
 子节点的位置
 */
@property (nonatomic, strong, readonly) NSIndexSet *childrenIndexes;

/**
 初始化节点控制器

 @param parentController 父节点控制器
 @param node             对应的节点

 @return <#return value description#>
 */
- (instancetype)initWithParent:(TreeNodeController *)parentController item:(TreeNode *)node;

/**
 插入节点控制器

 @param childControllers <#childControllers description#>
 @param indexSet         <#indexSet description#>
 */
- (void)insertChildControllers:(NSArray *)childControllers atIndexes:(NSIndexSet *)indexSet;

- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex;

- (void)removeChildControllersAtIndexes:(NSIndexSet *)indexes;

/**
 折叠节点
 */
- (void)close;

/**
 根据tableview中的index查找对应的节点控制器

 @param index <#index description#>

 @return <#return value description#>
 */
- (TreeNodeController *)controllerForIndex:(NSInteger)index;

/**
 根据数据对象查找对应的节点控制器

 @param item <#item description#>

 @return <#return value description#>
 */
- (TreeNodeController *)controllerForItem:(id)item;

/**
 获取节点下最后一个节点的index

 @param item <#item description#>

 @return <#return value description#>
 */
- (NSInteger)lastVisibleIndexForItem:(id)item;

@end
