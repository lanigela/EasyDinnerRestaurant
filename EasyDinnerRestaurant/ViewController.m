//
//  ViewController.m
//  EasyDinnerRestaurant
//
//  Created by ZhouMeng on 14-10-1.
//  Copyright (c) 2014年 DreamChou. All rights reserved.
//

#import "ViewController.h"
#import "CustomerListTableView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CustomerListTableView *CustomerList;

@end

@implementation ViewController


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.CustomerList.delegate = self;
    [self PullLineInfoFromServer];
    self.selectedrow = -1;
}

- (void) UpdateInfo
{
    [self PullLineInfoFromServer];
}

- (void) PullLineInfoFromServer
{
    PFQuery *query = [PFQuery queryWithClassName:@"LineInfo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.names = [NSMutableArray array];
            self.phone = [NSMutableArray array];
            self.customertype = [NSMutableArray array];
            self.deviceToken = [NSMutableArray array];
            
            for (PFObject* obj in objects) {
                [self.names addObject:obj[@"name"]];
                [self.phone addObject:obj[@"phone"]];
                [self.customertype addObject:obj[@"type"]];
                [self.deviceToken addObject:obj[@"deviceToken"]];
            }
            [self.CustomerList reloadData];
        }
        else{
            //NSLog(error);
            NSLog(@"Retriving data from LineInfo failed.");
        }
    }];

}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedrow =  indexPath.row;
}

- (IBAction)CheckInCustomer:(id)sender {
    
    if (self.selectedrow >= 0) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"LineInfo"];
        [query whereKey:@"deviceToken" equalTo:self.deviceToken[self.selectedrow]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // Do something with the found objects
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        [PFCloud callFunction:@"CheckInCustomer" withParameters:@{@"deviceToken":self.deviceToken[self.selectedrow]}];
        [self PullLineInfoFromServer];
        self.selectedrow = -1;
    }
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType      = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text         = [self.names objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
