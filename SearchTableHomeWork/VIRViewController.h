//
//  VIRViewController.h
//  SearchTableHomeWork
//
//  Created by Administrator on 03.02.14.
//  Copyright (c) 2014 Konstantin Kokorin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VIRSortSegment) {
    VIRSortBirhday,
    VIRSortFirstName,
    VIRSortLastName
};

@interface VIRViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;


- (IBAction)sortSegmentControl:(UISegmentedControl *)sender;
@end
