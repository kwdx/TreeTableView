//
//  CountryCell.h
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "WDTreeCell.h"

@interface CountryCell : WDTreeCell

@property (weak, nonatomic) Country *country;

@end
