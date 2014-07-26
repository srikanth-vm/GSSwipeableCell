//
//  SampleTableViewCell.h
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSSwipeableCells/GSTableViewCell/GSSwipeableCell.h"

@interface SampleTableViewCell : GSSwipeableCell
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UILabel *wins;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@end
