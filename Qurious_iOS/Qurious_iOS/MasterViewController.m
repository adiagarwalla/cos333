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
@synthesize searchObjects = _searchObjects;

static NSMutableArray *_objects;
static UITableView *view;
//static Person * me;
- (void)awakeFromNib
{
    [super awakeFromNib];
}



void mastercallback(id arg) {
    
    // do nothing valuable
    NSLog(@"Pulling all profiles JSON: %@", arg);
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSInteger myID = [defaults integerForKey:@"myID"];
    if ([arg isKindOfClass: [NSArray class]]) {
        _objects = [[NSMutableArray alloc] init];
        
        //NSDictionary * results = arg;
        for (NSDictionary *jsonobject in arg) {
            NSDictionary *fields = jsonobject[@"profile"][0][@"fields"];
            Person *friend = [[Person alloc] init];
            friend.firstName = fields[@"profile_first"];
            friend.lastName = fields[@"profile_last"];
            if (![fields[@"profile_pic"]  isEqual: @""]) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qurious.info:8080/%@", fields[@"profile_pic"]]];
                friend.profPic = url;
            }
            friend.email = fields[@"user_email"];
            friend.bio = fields[@"user_bio"];
            friend.userID = [fields[@"user"] intValue];
//            if (friend.userID == myID) {
//                me = friend;
//            }
            friend.username = fields[@"profile_name"];
            NSDictionary *skills = jsonobject[@"skills"];
            NSMutableArray * allmyskills = [[NSMutableArray alloc] init];
            for (NSDictionary * skill in skills) {
                Skill * mySkill = [[Skill alloc] init];
                mySkill.name = skill[@"fields"][@"name"];
                mySkill.desc = skill[@"fields"][@"desc"];
                mySkill.price = skill[@"fields"][@"price"];
                mySkill.skillID = [skill[@"pk"] intValue];
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
    _searchObjects = [[NSMutableArray alloc] init];
    // Change button color
    //_sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    self.navigationController.navigationBar.hidden = NO;
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
    
    view = (UITableView *)self.view;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    //UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    //self.tableView.contentInset = inset;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    for (Person* p in [_objects reverseObjectEnumerator]) {
        NSString * skillString;
        skillString = [[p.skills valueForKey:@"name"] componentsJoinedByString: @" "];
        if ([p.firstName rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound && [p.lastName rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound && [p.username rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound && [skillString rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound) {
            // do nothing in this case
            if ([_searchObjects containsObject:p]) {
                [_searchObjects removeObject:p];
            }
        } else {
            if (![_searchObjects containsObject:p]) {
                [_searchObjects insertObject:p atIndex:0];
            }
        }
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [QApiRequests getAllProfiles:&mastercallback];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchObjects.count;
        
    } else {
        return _objects.count;
    }
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:@"Cell"
//                             forIndexPath:indexPath];
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Person *friend = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [_searchObjects objectAtIndex:indexPath.row];
    } else {
        friend = [_objects objectAtIndex:indexPath.row];
    }
    
    if ([friend.firstName isEqualToString: @""] && [friend.lastName isEqualToString: @""]) {
        cell.textLabel.text = friend.username;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
    }
    cell.detailTextLabel.text = friend.bio;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:friend.profPic];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Update the UI
//            cell.imageView.image = [UIImage imageWithData:imageData];
//        });
//    });
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row%2 == 0) {
//        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
//        cell.backgroundColor = altCellColor;
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


//- (Person*) findPersonForName:(NSString*)name {
//    for (Person* p in _objects) {
//        if ([p.firstName isEqualToString:name] || [p.lastName isEqualToString:name] || [p.username isEqualToString:name]) {
//            return p;
//        }
//    };
//        
//    return nil;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        Person *friend;
        if (self.searchDisplayController.active) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        friend = [_searchObjects objectAtIndex: indexPath.row];

        }
        else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            friend = [_objects objectAtIndex: indexPath.row];

        }
        [[segue destinationViewController] setDetailItem:friend];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

@end
