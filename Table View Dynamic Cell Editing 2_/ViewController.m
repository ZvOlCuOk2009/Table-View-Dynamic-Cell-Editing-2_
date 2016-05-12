//
//  ViewController.m
//  Table View Dynamic Cell Editing 2_
//
//  Created by Mac on 17.12.15.
//  Copyright © 2015 Tsvigun Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "TSAuto.h"
#import "TSParking.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *parkings;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    
    rect.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.navigationItem.title = @"Auto";
    
    self.parkings = [NSMutableArray array];
    
    for (int i = 0; i < (arc4random() % 5) + 10; i++) {
        
        TSParking *parking = [[TSParking alloc] init];
        parking.nameParking = [NSString stringWithFormat:@"Parking number %d", i];
        
        NSMutableArray *arrayParkings = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < (arc4random() % 10) + 15; j++) {
            
            [arrayParkings addObject:[TSAuto randomAuto]];
        }
        parking.avto = arrayParkings;
        [self.parkings addObject:parking];
    }
    [tableView reloadData];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem = addItem;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)actionEdit:(UIBarButtonItem *)sender {
    
    BOOL editing = self.tableView.editing;

    [self.tableView setEditing:!editing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemDone;
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                        target:self
                                                                                        action:@selector(actionEdit:)];
        [self.navigationItem setRightBarButtonItem:doneItem animated:YES];
    }
}

-(void)actionAdd:(UIBarButtonItem *)sender {
    
    TSParking *parking = [[TSParking alloc] init];
    
    parking.nameParking = [NSString stringWithFormat:@"Parking number %ld", [self.parkings count] + 1];
    parking.avto = @[[TSAuto randomAuto], [TSAuto randomAuto]];
    
    NSInteger newParkingIndex = 0;
    
    [self.parkings insertObject:parking atIndex:newParkingIndex];
    
    [self.tableView beginUpdates];
        
    NSIndexSet *insertSection = [NSIndexSet indexSetWithIndex:newParkingIndex];
    
    UITableViewRowAnimation animation = UITableViewRowAnimationFade;
    
    if ([self.parkings count] > 1) {
        
        animation = [self.parkings count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    };
    
    [self.tableView insertSections:insertSection withRowAnimation:animation];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    CGFloat timeInterval = 0.3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.parkings.count; //количество секций в таблице
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TSParking *parking = [self.parkings objectAtIndex:section];
    
    return [parking.avto count] + 1; //количество рядов в секцие
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.parkings objectAtIndex:section] nameParking];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        static NSString *addStudentIdentifier = @"addStudentIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addStudentIdentifier];
            
            cell.textLabel.text = [NSString stringWithFormat:@"To put the Auto on parking"];
            cell.backgroundColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor blueColor];
        }
        return cell;
        
    } else {
    
    static NSString *identifierStudent = @"identifierStudent";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStudent];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierStudent];
        
        cell.backgroundColor = [UIColor blackColor];
    }
    
    TSParking *parking = [self.parkings objectAtIndex:indexPath.section];
    
    TSAuto *avto = [parking.avto objectAtIndex:indexPath.row - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", avto.model, avto.color];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", avto.age];
        
        
    if (avto.age > 2005) {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    } else if (avto.age <= 2005 && avto.age >= 1995) {
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    } else
        cell.detailTextLabel.textColor = [UIColor redColor];
        
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? NO : YES; // запрещает перемещение ячеек
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    TSParking *sourceParking = [self.parkings objectAtIndex:sourceIndexPath.section];
    
    TSAuto *avto = [sourceParking.avto objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray *arrayParkings = [NSMutableArray arrayWithArray:sourceParking.avto];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [arrayParkings exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        
        sourceParking.avto = arrayParkings;
        
    } else {
        
        [arrayParkings removeObject:avto];
        
        sourceParking.avto = arrayParkings;
        
        TSParking *destinationParking = [self.parkings objectAtIndex:destinationIndexPath.section];
        
        arrayParkings = [NSMutableArray arrayWithArray:destinationParking.avto];
            
        [arrayParkings insertObject:avto atIndex:destinationIndexPath.row - 1];
            
        destinationParking.avto = arrayParkings;
    }
}; // перемещение ячеек между группами

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TSParking *sourceParking = [self.parkings objectAtIndex:indexPath.section];
        
        TSAuto *sourceAvto = [sourceParking.avto objectAtIndex:indexPath.row - 1];
        
        NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:sourceParking.avto];
        
        [sourceArray removeObject:sourceAvto];
        
        sourceParking.avto = sourceArray;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView endUpdates];
    }
    
    NSLog(@"deleted");
} //удаляет ячкйку


#pragma mark - UITableViewDelegate

// ********************************* анимация ячейки ******************************


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.frame = CGRectMake(0 - CGRectGetWidth(cell.frame), CGRectGetMinY(cell.frame),
                            CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         cell.frame = CGRectMake(0, CGRectGetMinY(cell.frame),
                                                 CGRectGetWidth(cell.frame),
                                                 CGRectGetHeight(cell.frame));
                         
                         cell.backgroundColor = [UIColor blackColor];
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0; // == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete; // убирает красный кружок в режиме редактирования
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        TSParking *parking = [self.parkings objectAtIndex:indexPath.section];
        
        NSMutableArray *arrayParkings = nil;
        
        if (parking.avto) {
            
            arrayParkings = [NSMutableArray arrayWithArray:parking.avto];
        
        } else {
            
            arrayParkings = [NSMutableArray array];
        }
        
        NSInteger newStudentIndex = 0;
        
        [arrayParkings insertObject:[TSAuto randomAuto] atIndex:newStudentIndex];
        
        parking.avto = arrayParkings;
        
        [self.tableView beginUpdates];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        CGFloat timeInterval = 0.3;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Liquidate";
}

@end
