//
//  GSTableViewCell.h
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSButton.h"

// Constants

#define ButtonTitle         @"btnTitle"
#define ButtonTitleColor    @"btnTitleClr"
#define ButtonColor         @"btnClr" // Defaults to White Color

// Interface

@protocol GSSwipeCellDelegate <NSObject>

/**
 * Notifies when ever any of the buttons got clicked with the Button Index (0 - n)
 */
- (void)didClickOnButtonWithIdentifier:(NSInteger)buttonIdentifier;
@end

@interface GSSwipeableCell : UITableViewCell

@property (weak, nonatomic) id<GSSwipeCellDelegate>delegate;

- (void)addUtilityButtons:(NSArray*)utilButtons;
- (void)addUtilityButtons:(NSArray*)utilButtons withWidth:(NSInteger)width;
- (void)closeUtilityButtonsViewWithAnimation:(BOOL)shouldAnimate;

@end
