//
//  CityCell.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "CityCell.h"

@interface CityCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation CityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCity:(City *)city {
    _city = city;
    self.cityLabel.text = city.name;
}

- (void)setDataModel:(id)model
{
    [self setCity:(City *)model];
}

@end
