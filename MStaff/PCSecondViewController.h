//
//  PCSecondViewController.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ContactsMode)
{
    ContactsModeAll = 1,
    ContactsModePriority = 2
};

@interface PCSecondViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)contactsPriorityChanged:(id)sender;

@end
