//
//  PIctureNameButtonTableViewCell.h
//  Qurious_iOS
//
//  Created by Abhinav  Khanna on 5/2/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIctureNameButtonTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UIButton *enterSessionButton;

@end
