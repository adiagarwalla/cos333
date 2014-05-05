//
//  DetailViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) id detailItem;
//@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) IBOutlet UIButton *enterSession;
//@property (strong, nonatomic) IBOutlet UILabel *bioLabel;

- (IBAction)cancel:(UIStoryboardSegue *)segue;
-(IBAction) sessionButtonClicked;
@end
