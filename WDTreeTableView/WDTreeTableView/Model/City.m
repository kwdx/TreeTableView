//
//  City.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "City.h"

@implementation City

+ (instancetype)cityWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {        
        self.name = dict[@"name"];
    }
    return self;
}

@end
