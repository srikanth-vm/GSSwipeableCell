//
//  GSTableViewCell.m
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//

#import "GSSwipeableCell.h"

// Private Constants

#define ButtonViewWidth         200
#define MinButtonViewHeight     20
#define SwipeAnimationDuration  0.5

typedef NS_ENUM(NSUInteger, GSSwipeableCellState) {
    GSSwipeableCellState_Closed = 0,
    GSSwipeableCellState_Opening,
    GSSwipeableCellState_Open
};

@interface GSSwipeableCell()

@property (assign, nonatomic) NSInteger buttonWidth;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) NSArray *buttons;
@property (assign, nonatomic) GSSwipeableCellState swipeableCellState;

@end

@implementation GSSwipeableCell

/**
 * Public Method
 * Accepts array of dictionaries {ButtonTitle, ButtonTitleColor, ButtonColor}
 * and Int value for the Buttons Width. 
 * Height will be calculated on number of buttons and cell height
 */
- (void)addUtilityButtons:(NSArray*)utilButtons
{
    self.buttonWidth = ButtonViewWidth;
    [self initialiseButtonViewWithButtons:utilButtons];
}

-(void)addUtilityButtons:(NSArray *)utilButtons withWidth:(NSInteger)width
{
    self.buttonWidth = width;
    [self initialiseButtonViewWithButtons:utilButtons];
}

- (void)initialiseButtonViewWithButtons:(NSArray*)utilButtons
{
    if ([self canAddButtons:utilButtons]) {
        self.buttons = utilButtons;
        [self setUpButtonView];
        self.swipeableCellState = GSSwipeableCellState_Closed;
    } else {
        NSLog(@"Buttons are not set up properly.");
        abort();
    }
}

- (void)awakeFromNib
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void)prepareForReuse
{
    // Close any open drawers.
    if (self.swipeableCellState == GSSwipeableCellState_Open) {
        [self openUtilityButtonsViewWithAnimation:NO];
    } else {
        [self closeUtilityButtonsViewWithAnimation:NO];
    }
}

- (BOOL)canAddButtons:(NSArray*)utilButtons
{
    // Check if array is not empty
    if (utilButtons && utilButtons.count > 0) {
        CGFloat cellHeight = CGRectGetHeight(self.bounds);
        int totalButtonsCount = utilButtons.count;
        // Check if Button height is atleast 20.
        if (cellHeight/totalButtonsCount > MinButtonViewHeight) {
            return YES;
        } // (Have a More Button Perhaps ?)
        return NO;
    }
    return NO;
}

#pragma mark - Init Views

- (void)setUpButtonView
{
    if (self.buttonView == nil) {
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - self.buttonWidth, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        self.buttonView = buttonView;
        [self setUpButtons];
        [self addSubview:self.buttonView];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self sendSubviewToBack:self.buttonView];
        [self addGesturesToCell];
        [self setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self addObservers];
    }
}

- (void)setUpButtons
{
    __block int loopCounter = 0;
    int totalNumberOfButtons = self.buttons.count;
    for (NSDictionary *buttonInfo in self.buttons) {
        
        // Configure Button
        GSButton *editButton = [GSButton buttonWithType:UIButtonTypeCustom];
        [editButton setButtonIdentifier:loopCounter];
        [editButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        CGRect buttonFrame = CGRectMake(0, CGRectGetHeight(self.bounds)/totalNumberOfButtons * loopCounter, self.buttonWidth, CGRectGetHeight(self.bounds)/totalNumberOfButtons);
        [editButton setFrame:buttonFrame];
        
        // Customise Button
        UIColor *buttonTitleColor;
        if (buttonInfo[ButtonTitleColor])
            buttonTitleColor = buttonInfo[ButtonTitleColor];
        else
            buttonTitleColor = [UIColor whiteColor];
        [editButton setTitle:buttonInfo[ButtonTitle] forState:UIControlStateNormal];
        [editButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        [editButton setBackgroundColor:buttonInfo[ButtonColor]];
        
        // Add Button to ButtonView
        [self.buttonView addSubview:editButton];
        loopCounter++;
    }
}

- (void)addGesturesToCell
{
    UISwipeGestureRecognizer *swipeLeftGesture, *swipeRightGesture;
    swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(userSwipedLeft:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeRightGesture  = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(userSwipedRight:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeLeftGesture];
    [self addGestureRecognizer:swipeRightGesture];
}

#pragma mark - User Interactions

- (IBAction)userSwipedLeft:(UISwipeGestureRecognizer *)sender
{
    CGPoint swipedPoint = [sender locationInView:self.contentView];
    NSLog(@"Swiped : X : %f", swipedPoint.x);
    [self openUtilityButtonsViewWithAnimation:YES];
}

- (IBAction)userSwipedRight:(UISwipeGestureRecognizer *)sender
{
    [self closeUtilityButtonsViewWithAnimation:YES];
}

- (IBAction)buttonClicked:(GSButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnButtonWithIdentifier:)]) {
        [self.delegate didClickOnButtonWithIdentifier:sender.buttonIdentifier];
    }
}

#pragma mark - View Transitions

- (void)openUtilityButtonsViewWithAnimation:(BOOL)shouldAnimate
{
    CGRect frame = self.contentView.frame;
    frame.origin.x -= self.buttonWidth;
    self.swipeableCellState = GSSwipeableCellState_Opening;
    if (shouldAnimate) {
        [UIView animateWithDuration:SwipeAnimationDuration animations:^{
            [self.contentView setFrame:frame];
        }];
    } else {
        [self.contentView setFrame:frame];
    }
    [self closeOtherOpenUtilityButtonView];
}

/**
 * Public Method.
 * Closes Utility Button View
 * @param BOOL shouldAnimate
 */
- (void)closeUtilityButtonsViewWithAnimation:(BOOL)shouldAnimate
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = 0;
    if (shouldAnimate) {
        [UIView animateWithDuration:SwipeAnimationDuration animations:^{
            [self.contentView setFrame:frame];
        }];
    } else {
        [self.contentView setFrame:frame];
    }
}

#pragma mark - Notifications

- (void)addObservers
{
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"GSCloseUtilNotification"];
    }
    @catch (NSException *exception) {}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUtilityButtonsView:) name:@"GSCloseUtilNotification" object:nil];
}

- (void)closeUtilityButtonsView:(NSNotification*)notification
{
    if (self.swipeableCellState == GSSwipeableCellState_Open) {
        [self closeUtilityButtonsViewWithAnimation:YES];
    }
    self.swipeableCellState = GSSwipeableCellState_Closed;
}

- (void)closeOtherOpenUtilityButtonView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GSCloseUtilNotification"
                                                        object:nil];
    [self performSelector:@selector(setSwipeableCellStateAsOpen) withObject:nil afterDelay:0.5];
}

- (void)setSwipeableCellStateAsOpen
{
    self.swipeableCellState = GSSwipeableCellState_Open;
}

@end
