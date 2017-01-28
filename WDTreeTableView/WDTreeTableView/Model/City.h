//
//  City.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeObj.h"

@interface City : TreeObj

@property (copy, nonatomic) NSString *name;

+ (instancetype)cityWithDict:(NSDictionary *)dict;

@end
