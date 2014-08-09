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

#pragma mark - UITableViewCell Overrides

- (void)awakeFromNib
{
    // Set Selection style to none if not set in derived classes.
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

#pragma mark - Public Methods

/**
 * ButtonView Initialiser.
 */
- (void)addUtilityButtons:(NSArray*)utilButtons
{
    self.buttonWidth = ButtonViewWidth;
    [self initialiseButtonViewWithButtons:utilButtons];
}

/**
 * Alternate Initialiser with width
 */
-(void)addUtilityButtons:(NSArray *)utilButtons withWidth:(NSInteger)width
{
    self.buttonWidth = width;
    [self initialiseButtonViewWithButtons:utilButtons];
}

/**
 *  Opens a utility drawer
 *
 *  @param animationFlag YES/NO
 */
-(void)openUtilityDrawerAnimated:(BOOL)animationFlag
{
    [self openUtilityButtonsViewWithAnimation:animationFlag];
}

/**
 * Forecfully close open drawers with or without animation.
 */
- (void)closeButtonsViewWithAnimation:(BOOL)shouldAnimate
{
    [self closeUtilityButtonsViewWithAnimation:shouldAnimate];
}

#pragma mark - Init

/**
 * Check for inputs.
 */
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

/**
 * Check if buttons can be laid out in Cell's frame.
 */
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

#pragma mark - Init Button Views

/**
 * Layout the ButtonView beneath Cell's ContentView
 */
- (void)setUpButtonView
{
    if (self.buttonView == nil) {
        // Calculate ButtonView frame
        CGFloat originX = CGRectGetWidth(self.bounds) - self.buttonWidth;
        CGFloat buttonViewWidth = CGRectGetWidth(self.bounds);
        CGFloat buttonViewHeight = CGRectGetHeight(self.bounds);
        CGRect buttonViewRect = CGRectMake(originX, 0, buttonViewWidth, buttonViewHeight);
        
        // Initialise ButtonView
        UIView *buttonView = [[UIView alloc] initWithFrame:buttonViewRect];
        [buttonView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
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

/**
 * Layout buttons and set up actions.
 */
- (void)setUpButtons
{
    __block int loopCounter = 0;
    int totalNumberOfButtons = self.buttons.count;
    for (NSDictionary *buttonInfo in self.buttons) {
        
        // Initialise Button
        GSButton *editButton = [GSButton buttonWithType:UIButtonTypeCustom];
        [editButton setButtonIdentifier:loopCounter];
        [editButton addTarget:self
                       action:@selector(buttonClicked:)
             forControlEvents:UIControlEventTouchDown];
        
        // Update Button's frame
        CGFloat originY = CGRectGetHeight(self.bounds)/totalNumberOfButtons * loopCounter;
        CGFloat buttonWidth = self.buttonWidth;
        CGFloat buttonHeight = CGRectGetHeight(self.bounds)/totalNumberOfButtons;
        CGRect buttonFrame = CGRectMake(0, originY, buttonWidth, buttonHeight);
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

/**
 * Add Gestures and its actions.
 */
- (void)addGesturesToCell
{
    UISwipeGestureRecognizer *swipeLeftGesture, *swipeRightGesture;
//    UIPanGestureRecognizer *panGesture;
    swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(userSwipedLeft:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeRightGesture  = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(userSwipedRight:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
//    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                         action:@selector(userDraggedCell:)];
//    [self addGestureRecognizer:panGesture];
    [self addGestureRecognizer:swipeLeftGesture];
    [self addGestureRecognizer:swipeRightGesture];
}

#pragma mark - User Interactions

- (IBAction)userDraggedCell:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.contentView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.contentView];
}

- (IBAction)userSwipedLeft:(UISwipeGestureRecognizer *)sender
{
    [self openUtilityButtonsViewWithAnimation:YES];
}

- (IBAction)userSwipedRight:(UISwipeGestureRecognizer *)sender
{
    [self closeUtilityButtonsViewWithAnimation:YES];
}

- (IBAction)buttonClicked:(GSButton*)sender
{
    if (self.GSSwipeCelldelegate && [self.GSSwipeCelldelegate respondsToSelector:@selector(didClickOnButtonWithIdentifier:onCell:)]) {
        [self.GSSwipeCelldelegate didClickOnButtonWithIdentifier:sender.buttonIdentifier onCell:self];
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
