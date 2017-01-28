//
//  Country.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "Country.h"
#import "Province.h"

@implementation Country

+ (instancetype)countryWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.name = dict[@"name"];
        
        // 3.字典数据 -> 模型数据
        NSMutableArray *muArr = [NSMutableArray array];
        NSArray *arr = dict[@"provinces"];
        for (NSDictionary *dict in arr) {
            Province *country = [Province provinceWithDict:dict];
            [muArr addObject:country];
        }
        
        self.provinces = [muArr copy];
    }
    return self;
}

- (NSInteger)childrenCount
{
    return self.provinces.count;
}

- (id)childAtIndex:(NSInteger)index
{
    return self.provinces[index];
}

@end
