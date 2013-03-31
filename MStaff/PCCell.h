//
//  PCCell.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCell : UITableViewCell

@property (strong, nonatomic) UIView* lightOverlay;

- (void)setActive:(BOOL)active;

@end
