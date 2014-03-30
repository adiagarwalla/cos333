//
//  ProfileViewController.m
//  qurious
//
//  Created by Abhinav  Khanna on 3/30/14.
//  Copyright (c) 2014 Abhinav Khanna. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navItem;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Skill #1" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage* image = [UIImage imageNamed:@"img1.png"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(34.0f, 250.0f, 75.0f, 75.0f);
    [self.scrollView addSubview:button];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Skill #1" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage* image2 = [UIImage imageNamed:@"img5.png"];
    [button2 setBackgroundImage:image2 forState:UIControlStateNormal];
    button2.frame = CGRectMake(34.0f, 340.0f, 75.0f, 75.0f);
    [self.scrollView addSubview:button2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
