//
//  ProvinceCell.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Province.h"
#import "WDTreeCell.h"

@interface ProvinceCell : WDTreeCell
@property (weak, nonatomic) Province *province;
@end
