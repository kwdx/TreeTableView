//
//  WDTreeTableView.h
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDTreeTableView, TreeNodeController;

NS_ASSUME_NONNULL_BEGIN

/**
 WDTreeTableView的数据源方法
 */
@protocol WDTreeViewDataSource <NSObject>

/**
 获取父节点下子节点的个数

 @param treeView <#treeView description#>
 @param item     父节点对应的数据对象，为nil时则为跟节点（即获取第一层级的个数）

 @return <#return value description#>
 */
- (NSInteger)treeView:(WDTreeTableView *)treeView numberOfChildrenOfItem:(nullable id)item;

- (UITableViewCell *)treeView:(WDTreeTableView *)treeView cellForItem:(id)item;

/**
 获取父节点下子节点对应的数据对象

 @param treeView <#treeView description#>
 @param index    父节点下子节点的偏移量
 @param item     父节点

 @return <#return value description#>
 */
- (id)treeView:(WDTreeTableView *)treeView child:(NSInteger)index ofItem:(nullable id)item;

@optional

@end

@protocol WDTreeViewDelegate <NSObject>

@optional

- (CGFloat)treeView:(WDTreeTableView *)treeView heightForRowForItem:(id)item;

- (CGFloat)treeView:(WDTreeTableView *)treeView estimatedHeightForRowForItem:(id)item;

- (BOOL)treeView:(WDTreeTableView *)treeView shouldOpenRowForItem:(id)item;

- (BOOL)treeView:(WDTreeTableView *)treeView shouldCloseRowForItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView willOpenRowForItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView willCloseRowForItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView didOpenRowForItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView didCloseRowForItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView didSelectRowForItem:(id)item;
    
- (void)treeView:(WDTreeTableView *)treeView didSelectRowOfLastItem:(id)item;

- (void)treeView:(WDTreeTableView *)treeView didDeselectRowForItem:(id)item;

- (NSString *)treeView:(WDTreeTableView *)treeView titleForDeleteConfirmationButtonForRowForItem:(id)item;

@end

@interface WDTreeTableView : UIView

@property (weak, nonatomic) id<WDTreeViewDataSource> dataSource;
@property (weak, nonatomic) id<WDTreeViewDelegate> delegate;

/*******************************************************/
/****************     初始化TableView    ****************/
/*******************************************************/
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (nullable id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


- (void)reloadData;
- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(UITableViewRowAnimation)animation;

/*******************************************************/
/****************      tableView操作     ****************/
/*******************************************************/
- (void)beginUpdates;
- (void)endUpdates;
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(UITableViewRowAnimation)animation;
//- (void)moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex;
- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(UITableViewRowAnimation)animation;

NS_ASSUME_NONNULL_END

@end
