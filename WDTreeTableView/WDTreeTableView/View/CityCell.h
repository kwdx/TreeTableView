//
//  CityCell.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "WDTreeCell.h"

@interface CityCell : WDTreeCell
@property (weak, nonatomic) City *city;
@end
