//
//  Country.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeObj.h"

@class Province;

@interface Country : TreeObj

@property (nonatomic, copy) NSString *name;
@property (copy, nonatomic) NSArray<Province *> *provinces;

+ (instancetype)countryWithDict:(NSDictionary *)dict;


@end
