//
//  GSViewController.h
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleTableViewCell.h"

@interface GSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GSSwipeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface DriverVO : NSObject

@property (strong, nonatomic) NSString *driverName;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *wins;
@property (strong, nonatomic) NSString *imageName;

@end
