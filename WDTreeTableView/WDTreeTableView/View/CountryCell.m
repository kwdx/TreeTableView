//
//  CountryCell.m
//  WDMultTableView
//
//  Created by duoduo on 2016/10/27.
//  Copyright © 2016年 CorJi. All rights reserved.
//

#import "CountryCell.h"

@interface CountryCell ()

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@end

@implementation CountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCountry:(Country *)country {
    _country = country;
    
    self.countryLabel.text = country.name;
}

- (void)setDataModel:(id)model
{
    [self setCountry:(Country *)model];
}

@end
