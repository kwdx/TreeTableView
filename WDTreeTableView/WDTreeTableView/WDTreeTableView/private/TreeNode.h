//
//  TreeNode.h
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/28.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode : NSObject

/**
 是否有子节点
 */
@property (assign, nonatomic) BOOL expanded;

/**
 节点对应的数据对象
 */
@property (weak, nonatomic) id item;

- (instancetype)initWithItem:(id)item;

@end
