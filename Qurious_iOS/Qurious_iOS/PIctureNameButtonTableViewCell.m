//
//  PIctureNameButtonTableViewCell.m
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 5/2/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "PIctureNameButtonTableViewCell.h"

@implementation PIctureNameButtonTableViewCell
@synthesize picture = _picture;
@synthesize name = _name;
@synthesize email = _email;
@synthesize enterSessionButton = _enterSessionButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
