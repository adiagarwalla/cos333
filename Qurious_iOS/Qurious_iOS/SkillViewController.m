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

}

@end


@implementation SkillViewController
@synthesize detailItem = _detailItem;

static NSMutableArray * _skills;
static UITableView * view;
static int _userID;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

void getSkillsCallback(id arg) {
    NSLog(@"JSON: %@", arg);
    printf("%s", "Fetching skills");
    _skills = [[NSMutableArray alloc]init]; // very poor garbage collection
    for (NSDictionary * skill in (NSArray *)arg) {
        Skill * mySkill = [[Skill alloc] init];
        mySkill.name = skill[@"fields"][@"name"];
        mySkill.desc = skill[@"fields"][@"desc"];
        mySkill.price = skill[@"fields"][@"price"];
        mySkill.skillID = [skill[@"pk"] intValue];
        if ([skill[@"fields"][@"is_marketable"] intValue] == 1) mySkill.isMarketable = YES;
        else mySkill.isMarketable = NO;
        [_skills insertObject:mySkill atIndex:0];
    }
    [view reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    view = (UITableView *)self.view;
    _skills = [self.detailItem skills];
    _userID = [self.detailItem userID];
	// Do any additional setup after loading the view, typically from a nib.

    
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
    return YES;
}

void deleteCallback(id arg){
    NSLog(@"JSON: %@", arg);
    printf("%s", "Deleted a skill!\n");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _skills = [_skills mutableCopy];
        int skillID = [[_skills objectAtIndex:indexPath.row] skillID];
        [_skills removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [QApiRequests deleteSkill: skillID andCallback: &deleteCallback];
    }
}


void addSkillCallback(id arg){
    NSLog(@"JSON: %@", arg);
    printf("%s", "Saved a skill!\n");

    [QApiRequests getAllSkills: _userID andCallback: &getSkillsCallback];
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
