//
//  SkillViewController.h
//  Qurious_iOS
//
//  Created by Helen Yu on 4/4/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) id detailItem;
- (IBAction)save:(UIStoryboardSegue *)sender;
- (IBAction)cancel:(UIStoryboardSegue *)sender;
@end
