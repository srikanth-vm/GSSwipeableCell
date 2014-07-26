//
//  GSTableViewCell.h
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
- (void)didClickOnButtonWithIdentifier:(NSInteger)buttonIdentifier onCell:(id)cell;
@end

// Class

@interface GSSwipeableCell : UITableViewCell

@property (weak, nonatomic) id<GSSwipeCellDelegate>delegate;

/**
 * Accepts array of dictionaries {ButtonTitle, ButtonTitleColor, ButtonColor}
 * Height will be calculated on number of buttons and cell height
 */
- (void)addUtilityButtons:(NSArray*)utilButtons;

/**
 * Alternate Initialiser.
 * Accepts Width, which will be set as Button's Container View Width.
 */
- (void)addUtilityButtons:(NSArray*)utilButtons withWidth:(NSInteger)width;

/**
 * Close forefully open drawers.
 */
- (void)closeButtonsViewWithAnimation:(BOOL)shouldAnimate;

@end
