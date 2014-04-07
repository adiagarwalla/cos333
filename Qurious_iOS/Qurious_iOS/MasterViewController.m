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

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

void callback(id arg) {
    
    // do nothing valuable
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
//    NSDictionary * results = arg;
//    for (NSDictionary *person in results) {
//        Person *friend = [[Person alloc] init];
//        friend.firstName = person[@"firstName"];
//        friend.lastName = person[@"lastName"];
//        friend.email = person[@"email"];
//        friend.bio = person[@"bio"];
//    }
    
//    Person *friend = [[Person alloc] init];
//    friend.firstName = @"Aditya";
//    friend.lastName = @"Agarwalla";
//    friend.email = @"aa4@princeton.edu";
//    friend.bio = @"I code";
//    NSMutableArray *skills = [NSMutableArray arrayWithObjects:@"Coding in Java", @"Coding in Python", @"Eating", @"Sleeping", @"Pooping", @"Going to class", nil];
//    friend.skills = skills;
//    UIImage *profPic = [UIImage imageNamed:@"dogesmall.jpg"];
//    friend.profPic = profPic;
//    [_objects insertObject:friend atIndex:0];
//    
//    
//    UITableView *view = (UITableView *)self.view;
//    [view reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // test the server requests right here
    // THIS IS SUPPOSED TO JUST SHOW YOU HOW THIS WORKS!!!
    //[QApiRequests getProfiles:2 andCallback:&callback];
    //_objects = [[NSMutableArray alloc] init];
    //[QApiRequests getProfiles:2 andCallback:&callback]; // edit this when you get all profiles!!!
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITableView *view = (UITableView *)self.view;
    [view reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    Person *friend = [[Person alloc] init];
    friend.firstName = @"Aditya";
    friend.lastName = @"Agarwalla";
    friend.email = @"aa4@princeton.edu";
    friend.bio = @"I code";
    Skill *skill = [[Skill alloc] init];
    skill.desc = @"testing";
    skill.price = [NSNumber numberWithDouble: 10.09];
    skill.isMarketable = YES;
    
    NSMutableArray *skills = [NSMutableArray arrayWithObjects:skill, skill, skill, nil];
    friend.skills = skills;
    UIImage *profPic = [UIImage imageNamed:@"dogesmall.jpg"];
    friend.profPic = profPic;
    [_objects insertObject:friend atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES; // set to no later
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Person *friend = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:friend];
    }
}

@end
