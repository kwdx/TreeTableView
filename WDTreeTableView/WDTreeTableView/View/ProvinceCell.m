//
//  ProvinceCell.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "ProvinceCell.h"

@interface ProvinceCell ()
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;

@end

@implementation ProvinceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProvince:(Province *)province {
    _province = province;
    self.provinceLabel.text = province.name;
}

- (void)setDataModel:(id)model
{
    [self setProvince:(Province *)model];
}

@end
