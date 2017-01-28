//
//  Province.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "Province.h"
#import "City.h"

@implementation Province

+ (instancetype)provinceWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //        [self setValuesForKeysWithDictionary:dict];
        
        self.name = dict[@"name"];
        
        // 3.字典数据 -> 模型数据
        NSMutableArray *muArr = [NSMutableArray array];
        NSArray *arr = dict[@"citys"];
        for (NSDictionary *dict in arr) {
            City *country = [City cityWithDict:dict];
            [muArr addObject:country];
        }
        
        self.citys = [muArr copy];
    }
    return self;
}

- (NSInteger)childrenCount
{
    return self.citys.count;
}

- (id)childAtIndex:(NSInteger)index
{
    return self.citys[index];
}

@end
