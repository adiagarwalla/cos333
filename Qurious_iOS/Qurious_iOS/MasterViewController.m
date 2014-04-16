//
//  MasterViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "MasterViewController.h"
#import "Person.h"
#import "DetailViewController.h"
#import "QApiRequests.h"
#import "Skill.h"
#import "SWRevealViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController

static NSMutableArray *_objects;
static UITableView *view;
static Person * me;
- (void)awakeFromNib
{
    [super awakeFromNib];
}



void mastercallback(id arg) {
    
    // do nothing valuable
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
    
    if (arg != NULL) {
        _objects = [[NSMutableArray alloc] init];
        
        NSDictionary * results = arg;
        for (NSDictionary *jsonobject in results) {
            NSDictionary *fields = jsonobject[@"profile"][0][@"fields"];
            Person *friend = [[Person alloc] init];
            friend.firstName = fields[@"profile_first"];
            friend.lastName = fields[@"profile_last"];
            friend.email = fields[@"user_email"];
            friend.bio = fields[@"user_bio"];
            friend.userID = [fields[@"user"] intValue];
            friend.username = fields[@"profile_name"];
            NSDictionary *skills = jsonobject[@"skills"];
            NSMutableArray * allmyskills = [[NSMutableArray alloc] init];
            for (NSDictionary * skill in skills) {
                Skill * mySkill = [[Skill alloc] init];
                mySkill.desc = skill[@"fields"][@"name"];
                mySkill.price = skill[@"fields"][@"price"];
                if ([skill[@"fields"][@"is_marketable"] intValue] == 1) mySkill.isMarketable = YES;
                else mySkill.isMarketable = NO;
                [allmyskills insertObject:mySkill atIndex:0];
            }
            friend.skills = allmyskills; // not releasing old array uhhhh
            [_objects insertObject:friend atIndex:0];
        }
        [view reloadData];
        
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // test the server requests right here
    // THIS IS SUPPOSED TO JUST SHOW YOU HOW THIS WORKS!!!
    //[QApiRequests getProfiles:2 andCallback:&callback];
    
    view = (UITableView *)self.view;
    
    [QApiRequests getAllProfiles:&mastercallback];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [view reloadData];
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
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"Cell"
                             forIndexPath:indexPath];
    Person *friend = _objects[indexPath.row];
    if ([friend.firstName isEqualToString: @""] && [friend.lastName isEqualToString: @""]) {
        cell.textLabel.text = friend.username;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Person *friend = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:friend];
    }
    if ([[segue identifier] isEqualToString:@"showProfile"]) {
        Person * me;
        for (Person * person in _objects) {
            if (person.userID == [self.userID intValue]) {
                NSLog(@"Found me!");
                me = person;
                break;
            }
        }
        [[segue destinationViewController] setDetailItem:me];
    }
}

@end
