//
//  ProfileViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/14/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "ProfileViewController.h"
#import "Person.h"
#import "EditViewController.h"
#import "SkillViewController.h"
#import "Skill.h"
#import "QApiRequests.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize detailItem = _detailItem;
@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize bioLabel = _bioLabel;
@synthesize imageView = _imageView;



- (void)configureView {
    if (self.detailItem &&
        [self.detailItem isKindOfClass:[Person class]]) {
        NSString *name = [NSString stringWithFormat:@"%@ %@",
                          [self.detailItem firstName],
                          [self.detailItem lastName]];
        self.nameLabel.text = name;
        self.emailLabel.text = [self.detailItem email];
        self.bioLabel.text = [self.detailItem bio];
        self.imageView.image = [self.detailItem profPic];
    }
    
}



#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editDetail"]) {
        NSArray *navigationControllers = [[segue destinationViewController] viewControllers];
        EditViewController *editViewController = [navigationControllers objectAtIndex:0];
        [editViewController setDetailItem:self.detailItem];
    }
    if ([[segue identifier] isEqualToString:@"editSkills"]) {
        NSArray *navigationControllers = [[segue destinationViewController] viewControllers];
        SkillViewController *skillViewController = [navigationControllers objectAtIndex:0];
        [skillViewController setDetailItem:self.detailItem];
    }
    
}

void saveCallback (id arg) {
    NSLog(@"JSON: %@", arg);
    printf("%s", "Saved a profile");
}


void saveSkillCallback (id arg) {
    NSLog(@"JSON: %@", arg);
    printf("%s", "Saved a skill");
}

- (IBAction)save:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"saveInput"]) {
        EditViewController *editController = [segue sourceViewController];
        [self.detailItem setFirstName:editController.firstNameField.text];
        [self.detailItem setLastName:editController.lastNameField.text];
        [self.detailItem setEmail:editController.emailField.text];
        [self.detailItem setBio:editController.bioField.text];
        [self.detailItem setProfPic:editController.selectedImage.image];
        
        [QApiRequests editProfile: [self.detailItem firstName] andLastName: [self.detailItem lastName] andBio:[self.detailItem bio] andEmail:[self.detailItem email] andProfile:[NSString stringWithFormat:@"%@ %@", [self.detailItem firstName], [self.detailItem lastName]] andCallback: saveCallback];
        
        [self configureView];
    }
    if ([[segue identifier] isEqualToString:@"saveSkillEdit"]) {
        SkillViewController *skillController = [segue sourceViewController];
        [self.detailItem setSkills: skillController.skills];
        
        
        for (Skill *skill in skillController.skills) {
            if (skill.skillID == 0)
                [QApiRequests editSkill:skill.skillID andPrice:skill.price andDesc:skill.desc andForSale: skill.isMarketable andCallback: saveSkillCallback];
        }
        
        [self configureView];
        [self loadButtons];
    }
    
}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
    
}


-(void) loadButtons {
    for(UIView *view in self.scrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view  removeFromSuperview];
        }
    }
    
    NSArray *buttonImg = @[@"img1.png", @"img2.png", @"img3.png", @"img4.png", @"img5.png", @"img6.png"];
    NSMutableArray *skills = [self.detailItem skills];
    int xposition = 20.0f;
    int yposition = 0;
    int count = 0;
    int xdisplacement;
    for (Skill *skill in skills) {
        if (count%3 == 0) xdisplacement = 0;
        else if (count%3 == 1) xdisplacement = 100.f;
        else xdisplacement = 200.f;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:skill.desc forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.numberOfLines = 4;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIImage* image = [UIImage imageNamed:buttonImg[count%6]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        button.frame = CGRectMake(xposition + xdisplacement, yposition, 75.0f, 75.0f);
        if (count%3 == 2) yposition += 100.f;
        count++;
        [self.scrollView addSubview:button];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self loadButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
