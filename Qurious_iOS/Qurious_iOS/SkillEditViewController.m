//
//  SkillEditViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/21/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "SkillEditViewController.h"
#import "Skill.h"
@interface SkillEditViewController ()

@end

@implementation SkillEditViewController
@synthesize detailItem = _detailItem;
@synthesize nameField = _nameField;
@synthesize priceField = _priceField;
@synthesize descField = _descField;
@synthesize forSaleSwitch = _forSaleSwitch;


- (void)setDetailItem:(id)detailItem {
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_descField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_descField.layer setBorderWidth:1.0];
    _descField.layer.cornerRadius = 5;
    _descField.clipsToBounds = YES;
    _nameField.delegate = self;
    _priceField.delegate = self;
    
    if (self.detailItem != NULL) {
        _descField.text = [self.detailItem desc];
        _nameField.text = [self.detailItem name];
        _nameField.enabled = NO;
        _nameField.textColor = [UIColor lightGrayColor];
        _priceField.text = [NSString stringWithFormat:@"%@", [self.detailItem price]];
        [_forSaleSwitch setOn:[self.detailItem isMarketable] animated:YES];
        self.navigationItem.title = @"Edit A Skill";
    }
    else {
        self.navigationItem.title = @"Add A Skill";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString: @"saveSkillEdit"]) {
        if ([_nameField.text isEqualToString: @""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Skill Name"
                                                            message:@"Please enter a valid nonempty skill name. Remember, this cannot be changed!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        NSRange range = [_priceField.text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        
        if(range.location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Price"
                                                            message:@"Please enter a valid numeric price."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    
    return YES;
    
}


#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
