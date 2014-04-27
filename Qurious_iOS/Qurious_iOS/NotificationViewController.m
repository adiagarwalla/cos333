//
//  NotificationViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/23/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "NotificationViewController.h"
#import "SWRevealViewController.h"
#import "QApiRequests.h"
#import "Person.h"
#import "Notification.h"
#import "ViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize detailItem = _detailItem;

static NSMutableArray * _notifications;
static UITableView * view;
static int _userID;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

void getNotificationsCallback(id arg){
    NSLog(@"Get notifications JSON: %@", arg);
    printf("%s", "Fetching notifications");
    _notifications = [[NSMutableArray alloc]init];
    for (NSDictionary * notification in (NSArray *)arg) {
        Notification * myNotification = [[Notification alloc] init];
        NSString* tmp = notification[@"fields"][@"attachedjson"];
        myNotification.session_token = [tmp substringWithRange:NSMakeRange(16, [tmp length] - 18)];
        myNotification.from = notification[@"f"];
        myNotification.message = notification[@"fields"][@"message"];
        [_notifications insertObject:myNotification atIndex:0];
    }
    [view reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change button color
    //_sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    view = (UITableView *)self.view;
    //_notifications = [self.detailItem notifications];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger myID = [defaults integerForKey:@"myID"];
    _userID = myID;
    NSLog(@"Get user id: %d", _userID);
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *session_token = [defaults objectForKey:@"sessiontoken"];
    [QApiRequests getNotification:_userID andCallback: &getNotificationsCallback];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Notification * notification = _notifications[indexPath.row];
    cell.textLabel.text = notification.message;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Notification * notification = _notifications[indexPath.row];
    NSString* kSession = notification.session_token;
    [ViewController setSessionToken: kSession];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SessionOver"]) {
        ViewController *sessionController = [segue sourceViewController];
        [sessionController.session disconnect];
    }
    
}

@end
