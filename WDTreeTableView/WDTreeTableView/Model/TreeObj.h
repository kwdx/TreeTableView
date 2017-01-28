//
//  TreeObj.h
//  WDTreeTableView
//
//  Created by duoduo on 2016/10/31.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeObj : NSObject

- (NSInteger)childrenCount;
- (id)childAtIndex:(NSInteger)index;

@end
