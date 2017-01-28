//
//  WDTreeNodeDataController.h
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/29.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TreeNode, TreeNodeController;

@class WDTreeNodeDataController;

@protocol WDTreeNodeDataControllerDataSource <NSObject>

/**
 获取节点下面的子节点个数

 @param controller 树控制器
 @param item       节点对应的数据模型

 @return <#return value description#>
 */
- (NSInteger)treeNodeDataController:(WDTreeNodeDataController *)controller numberOfChildrenForItem:(id)item;

/**
 获取节点下面的子节点对应的数据模型

 @param controller 树控制器
 @param childIndex 子节点位置
 @param item       节点

 @return <#return value description#>
 */
- (id)treeNodeDataController:(WDTreeNodeDataController *)controller child:(NSInteger)childIndex ofItem:(id)item;

@end

@interface WDTreeNodeDataController : NSObject


@property (nonatomic, weak) id<WDTreeNodeDataControllerDataSource> dataSource;

/**
 当前总显示个数
 */
@property (nonatomic, readonly) NSInteger numberOfVisibleRowsForItems;


/**
 根据index获取对应的节点TreeNode

 @param index 偏移量

 @return 节点
 */
- (TreeNode *)treeNodeForIndex:(NSInteger)index;

/**
 根据index获取对应的节点控制器

 @param index <#index description#>

 @return <#return value description#>
 */
- (TreeNodeController *)nodeControllerForIndex:(NSInteger)index;

/**
 item对应的层级

 @param item <#item description#>

 @return <#return value description#>
 */
- (NSInteger)levelForItem:(id)item;

/**
 item的父级

 @param item <#item description#>

 @return <#return value description#>
 */
- (id)parentForItem:(id)item;

/**
 获取item中index的子节点

 @param parent <#parent description#>
 @param index  <#index description#>

 @return <#return value description#>
 */
- (id)childInParent:(id)parent atIndex:(NSInteger)index;

/**
 item对应的偏移量

 @param item <#item description#>

 @return <#return value description#>
 */
- (NSInteger)indexForItem:(id)item;

/**
 获取节点下最后一个节点的index

 @param item <#item description#>

 @return <#return value description#>
 */
- (NSInteger)lastVisibleDescendantIndexForItem:(id)item;


/**
 展开节点

 @param item           <#item description#>
 @param updates        更新操作
 */
- (void)openRowForItem:(id)item updates:(void (^)(NSIndexSet *))updates;

/**
 折叠节点

 @param item             <#item description#>
 @param updates          更新操作
 */
- (void)closeRowForItem:(id)item updates:(void(^)(NSIndexSet *))updates;

/**
 在父节点中插入

 @param indexes <#indexes description#>
 @param item    <#item description#>
 */
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item;

/**
 将一个item从一个节点下移动到另一个节点

 @param index     <#index description#>
 @param parent    <#parent description#>
 @param newIndex  <#newIndex description#>
 @param newParent <#newParent description#>
 @param updates   <#updates description#>
 */
- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void(^)(NSIndexSet *deletions, NSIndexSet *additions))updates;

/**
 删除节点

 @param indexes <#indexes description#>
 @param item    <#item description#>
 @param updates <#updates description#>
 */
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item updates:(void(^)(NSIndexSet *))updates;

@end
