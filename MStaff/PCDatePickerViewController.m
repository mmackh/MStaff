//
//  PCDatePickerViewController.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/21/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCDatePickerViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "PCWhenIWorkDateHelper.h"

@interface PCDatePickerViewController ()

@end

@implementation PCDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [_datePicker setDate:[_delegate datePickerInitWithDate]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self captureAndInsertParentViewControllerScreenshot];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self.view.subviews objectAtIndex:0] removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [_delegate datePickerDidCancel];
}

- (IBAction)save:(id)sender
{
    [_delegate datePickerDidPickStartDate:[[PCWhenIWorkDateHelper dateFormatterWithFormat:@"yyyy-MM-dd"] stringFromDate:_datePicker.date] EndDate:[[PCWhenIWorkDateHelper dateFormatterWithFormat:@"yyyy-MM-dd"] stringFromDate:[PCWhenIWorkDateHelper offsetDateByDays:1 FromDate:_datePicker.date]] RawDate:_datePicker.date];
}

- (void)captureAndInsertParentViewControllerScreenshot
{
    UIView *parentView = self.presentingViewController.view;
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = parentViewImage;
    [self.view insertSubview:imageView atIndex:0];
}

@end
