//
//  Province.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeObj.h"

@class City;

@interface Province : TreeObj

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray<City *> *citys;

+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
