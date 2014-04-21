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
    [self.navigationItem setHidesBackButton:YES animated:NO];
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
                             dequeueReusableCellWithIdentifier:@"Cell"
                             forIndexPath:indexPath];
    Skill * skill = _skills[indexPath.row];
    cell.textLabel.text = skill.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (IBAction)save:(UIStoryboardSegue *)sender{
    
}
- (IBAction)cancel:(UIStoryboardSegue *)sender{
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addSkill"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Skill * skill = _skills[indexPath.row];
        [[segue destinationViewController] setDetailItem:skill];
    }

}

@end
