//
//  SkillViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/4/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "SkillViewController.h"
#import "Person.h"
#import "Skill.h"
#import "SkillEditViewController.h"
#import "QApiRequests.h"

@interface SkillViewController () {
    NSMutableArray * _skills;
}

@end


@implementation SkillViewController
@synthesize detailItem = _detailItem;

- (void)awakeFromNib
{
    [super awakeFromNib];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    _skills = [_detailItem skills];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _skills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"skillCell"
                             forIndexPath:indexPath];
    Skill * skill = _skills[indexPath.row];
    cell.textLabel.text = skill.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

void addSkillCallback(id arg){
    NSLog(@"JSON: %@", arg);
    printf("%s", "Saved a skill!\n");
}

- (IBAction)save:(UIStoryboardSegue *)segue{
    
    if ([[segue identifier] isEqualToString:@"saveSkillEdit"]) {
        SkillEditViewController *skillEditController = [segue sourceViewController];

        int skillID;
        if (skillEditController.detailItem == NULL) {
            skillID = 0;
        }
        else {
            skillID = [skillEditController.detailItem skillID];
        }
        NSString *name = skillEditController.nameField.text;
        NSString *price = skillEditController.priceField.text;
        if ([price isEqualToString:@""]) price = @"0";
        [QApiRequests editSkill: skillID andName: name andPrice: price andDesc:skillEditController.descField.text andForSale:skillEditController.forSaleSwitch.on andCallback:addSkillCallback ];
    }
    
}
- (IBAction)cancel:(UIStoryboardSegue *)sender{
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editSkill"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Skill * skill = _skills[indexPath.row];
        NSArray *navigationControllers = [[segue destinationViewController] viewControllers];
        SkillEditViewController *editViewController = [navigationControllers objectAtIndex:0];
        [editViewController setDetailItem:skill];
    }
    else if ([[segue identifier] isEqualToString:@"addSkill"]) {

    }

}

@end
