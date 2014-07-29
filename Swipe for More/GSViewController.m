//
//  GSViewController.m
//  Swipe for More
//
//  Created by Srikanth V M on 7/25/14.
//  Copyright (c) 2014 Good Sp33d. All rights reserved.
//

#import "GSViewController.h"

typedef NS_ENUM(NSUInteger, ButtonIdentifier){
    AddButton = 0,
    EditButton,
    DeleteButton
};

@interface GSViewController () {
    NSMutableArray *tableData;
}

@end

@implementation GSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialiseTableData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SampleTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)initialiseTableData
{
    tableData = [[NSMutableArray alloc] init];
    DriverVO *kimi = [[DriverVO alloc] init];
    kimi.driverName = @"Kimi Raikonnen";
    kimi.points = @"19";
    kimi.wins = @"0";
    kimi.imageName = @"kimi";
    
    DriverVO  *alonso = [[DriverVO alloc] init];
    alonso.driverName = @"Fernando Alonso";
    alonso.points = @"97";
    alonso.wins = @"0";
    alonso.imageName = @"alonso";
    
    DriverVO *nico = [[DriverVO alloc] init];
    nico.driverName = @"Nico Roseberg";
    nico.points = @"190";
    nico.wins = @"4";
    nico.imageName = @"nico";
    
    DriverVO *vettel = [[DriverVO alloc] init];
    vettel.driverName = @"Sebastian Vettel";
    vettel.points = @"82";
    vettel.wins = @"0";
    vettel.imageName = @"vettel";
    
    DriverVO *hamilton = [[DriverVO alloc] init];
    hamilton.driverName = @"Lewis Hamilton";
    hamilton.points = @"176";
    hamilton.wins = @"5";
    hamilton.imageName = @"hamilton";
    
    [tableData addObject:alonso];
    [tableData addObject:kimi];
    [tableData addObject:vettel];
    [tableData addObject:nico];
    [tableData addObject:hamilton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleTableViewCell *cell = (SampleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell addUtilityButtons:[self utilButtons]];
    [cell setGSSwipeCelldelegate:self];
    DriverVO *aDriver = tableData[indexPath.row];
    cell.driverName.text = aDriver.driverName;
    cell.picture.image = [UIImage imageNamed:aDriver.imageName];
    cell.wins.text = aDriver.wins;
    cell.points.text = aDriver.points;
    cell.tag = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSArray*)utilButtons
{
    NSDictionary *addButton = @{ButtonTitle: @"Add",
                                ButtonColor: [UIColor yellowColor],
                                ButtonTitleColor: [UIColor blackColor]};
    NSDictionary *editButton = @{ButtonTitle: @"Edit",
                                 ButtonColor: [UIColor redColor]};
    NSDictionary *deleteButton = @{ButtonTitle: @"Delete",
                                   ButtonColor: [UIColor blackColor]};
    return @[addButton,
             editButton,
             deleteButton
             ];
}

-(void)didClickOnButtonWithIdentifier:(NSInteger)buttonIdentifier onCell:(id)cell
{
    SampleTableViewCell *tableViewCell = (SampleTableViewCell*)cell;
    switch (buttonIdentifier) {
        case AddButton:
            NSLog(@"Add Button Got Clicked on Cell : %d", tableViewCell.tag);
            break;
        case EditButton:
            NSLog(@"Edit Button Got Clicked on Cell : %d", tableViewCell.tag);
            break;
        case DeleteButton:
            NSLog(@"Delete Button Got Clicked on Cell : %d", tableViewCell.tag);
            break;
    }
}

@end

@implementation DriverVO
@end
