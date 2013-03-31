//
//  PCSecondViewController.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCSecondViewController.h"
#import "PCCellContacts.h"

@interface PCSecondViewController ()
{
    NSMutableArray *active;
    NSMutableArray *priority;
    
    NSArray *objects;
}

@end

@implementation PCSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    active = [NSMutableArray array];
    priority = [NSMutableArray array];
    
    objects = [NSArray array];
    
    [_tableView registerClass:[PCCellContacts class] forCellReuseIdentifier:@"Cell"];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"]];
    NSDictionary *contacts = [[NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableLeaves error:nil] objectForKey:@"contacts"];
    
    for (NSArray *arr in contacts)
    {
        if ([[arr valueForKey:@"active"] boolValue])
        {
            if ([[arr valueForKey:@"priority"] boolValue])
            {
                [priority addObject:arr];
            }
            
            [active addObject:arr];
        }
    }
    
    objects = active;
    
}

#pragma mark -
#pragma mark UITableView Datasource & Delegate

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCCellContacts *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [[objects objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[[objects objectAtIndex:indexPath.row] objectForKey:@"number"] stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%i", [[[objects objectAtIndex:indexPath.row] objectForKey:@"number"] intValue]]]];
}

#pragma mark -
#pragma mark Methods

- (IBAction)contactsPriorityChanged:(id)sender
{
    UISegmentedControl *sC = sender;
    
    switch (sC.selectedSegmentIndex)
    {
        case 0:
            objects = active;
            break;
        case 1:
            objects = priority;
            break;
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
