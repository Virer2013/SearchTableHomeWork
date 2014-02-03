//
//  VIRViewController.m
//  SearchTableHomeWork
//
//  Created by Administrator on 03.02.14.
//  Copyright (c) 2014 Konstantin Kokorin. All rights reserved.
//

#import "VIRViewController.h"
#import "VIRStudent.h"
#import "VIRTableSection.h"

@interface VIRViewController ()

@property (strong, nonatomic) NSMutableArray *namesOfStudentsArray;
@property (strong, nonatomic) NSArray *sectionsArray;
@property (strong, nonatomic) NSOperation* currentOperation;

@end

@implementation VIRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.namesOfStudentsArray = [NSMutableArray array];
    self.sectionsArray = [NSArray array];
    
    for (int i = 0; i < 500; i++) {
        [self.namesOfStudentsArray addObject:[VIRStudent newStudent]];
    }
    
    [self  generateSectionsInBackgroundArraByBirhday:self.namesOfStudentsArray withFilter:self.searchBar.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Help Methods

-(void) generateSectionsInBackgroundArraByBirhday : (NSArray*) array withFilter:(NSString*) filterString {
    
    [self.currentOperation cancel];
    
    __weak VIRViewController* weakSelf = self;
    
    self. currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsFromArrayBirhday:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [self.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    [self.currentOperation start];
    
}

-(void) generateSectionsInBackgroundArraByFirstName : (NSArray*) array withFilter:(NSString*) filterString {
    
    [self.currentOperation cancel];
    
    __weak VIRViewController* weakSelf = self;
    
    self. currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsByFirstNameFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [self.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    [self.currentOperation start];
    
}

-(void) generateSectionsInBackgroundArraByLastName : (NSArray*) array withFilter:(NSString*) filterString {
    
    [self.currentOperation cancel];
    
    __weak VIRViewController* weakSelf = self;
    
    self. currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsByLastNameFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [self.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    [self.currentOperation start];
    
}



-(NSArray*) generateSectionsFromArrayBirhday: (NSArray*) array withFilter:(NSString*) filterString {
    
    NSSortDescriptor* sortDescriptorBirthday =[[NSSortDescriptor alloc]initWithKey:@"birthDay" ascending:YES];
    
    [self.namesOfStudentsArray sortUsingDescriptors:@[sortDescriptorBirthday]];
    
    NSMutableArray* sectionsArray = [[NSMutableArray alloc]init];
    
    NSString* currentLetter = nil;
    
    for (VIRStudent* st in array) {
        
        if ([filterString length] > 0 && [st.firstName rangeOfString:filterString].location && [st.lastName rangeOfString:filterString].location == NSNotFound) {
            continue;
        }
        
        NSString* firstLetter = [st.birthDay substringToIndex:2];
        
        VIRTableSection* section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            
            section = [[VIRTableSection alloc]init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
        }else{
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject:st];
    }
    
    for(VIRTableSection* sec in sectionsArray){
        
        NSSortDescriptor* sortDescriptorBirthday =[[NSSortDescriptor alloc]initWithKey:@"birthDay" ascending:YES];
        
        NSSortDescriptor* sortDescriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* sortDescriptorLastName =[[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
        [sec.itemsArray sortUsingDescriptors:@[sortDescriptorFirstName,sortDescriptorLastName,sortDescriptorBirthday]];
    }
    
    return sectionsArray;
}

-(NSArray*) generateSectionsByFirstNameFromArray: (NSArray*) array withFilter:(NSString*) filterString {
    
    NSSortDescriptor* sortDescriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    
    [self.namesOfStudentsArray sortUsingDescriptors:@[sortDescriptorFirstName]];
    
    NSMutableArray* sectionsArray = [[NSMutableArray alloc]init];
    
    NSString* currentLetter = nil;
    
    for (VIRStudent* st in array) {
        
        if ([filterString length] > 0 && [st.firstName rangeOfString:filterString].location && [st.lastName rangeOfString:filterString].location == NSNotFound) {
            continue;
        }
        
        NSString* firstLetter = [st.firstName substringToIndex:1];
        
        VIRTableSection* section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            
            section = [[VIRTableSection alloc]init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
        }else{
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject:st];
    }
    
    for(VIRTableSection* sec in sectionsArray){
        
        NSSortDescriptor* sortDescriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        
        NSSortDescriptor* sortDescriptorLastName =[[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
        NSSortDescriptor* sortDescriptorBirthday =[[NSSortDescriptor alloc]initWithKey:@"birthDay" ascending:YES];
        
        [sec.itemsArray sortUsingDescriptors:@[sortDescriptorFirstName,sortDescriptorLastName,sortDescriptorBirthday]];
    }
    
    return sectionsArray;
}

-(NSArray*) generateSectionsByLastNameFromArray: (NSArray*) array withFilter:(NSString*) filterString {
    
    NSSortDescriptor* sortDescriptorLastName =[[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    
    [self.namesOfStudentsArray sortUsingDescriptors:@[sortDescriptorLastName]];
    
    NSMutableArray* sectionsArray = [[NSMutableArray alloc]init];
    
    NSString* currentLetter = nil;
    
    for (VIRStudent* st in array) {
        
        if ([filterString length] > 0 && [st.firstName rangeOfString:filterString].location && [st.lastName rangeOfString:filterString].location == NSNotFound) {
            continue;
        }
        
        NSString* firstLetter = [st.lastName substringToIndex:1];
        
        VIRTableSection* section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            
            section = [[VIRTableSection alloc]init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
        }else{
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject:st];
    }
    
    for(VIRTableSection* sec in sectionsArray){
        
        NSSortDescriptor* sortDescriptorFirstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        
        NSSortDescriptor* sortDescriptorLastName =[[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
        NSSortDescriptor* sortDescriptorBirthday =[[NSSortDescriptor alloc]initWithKey:@"birthDay" ascending:YES];
        
        [sec.itemsArray sortUsingDescriptors:@[sortDescriptorLastName,sortDescriptorBirthday,sortDescriptorFirstName,]];
        
    }
    
    return sectionsArray;
}

#pragma mark - UItableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* array = [NSMutableArray array];
    for(VIRTableSection* section in self.sectionsArray){
        
        [array addObject:section.sectionName];
    }
    return array;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionsArray objectAtIndex:section] sectionName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    VIRTableSection* sections = [self.sectionsArray objectAtIndex:section];
    return [sections.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    
    VIRTableSection* sections = [self.sectionsArray objectAtIndex:indexPath.section];
    
    VIRStudent* student = [sections.itemsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
    
    cell.detailTextLabel.text = student.birthDay;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if (self.segmentControl.selectedSegmentIndex == VIRSortBirhday ) {
        
        [self generateSectionsInBackgroundArraByBirhday:self.namesOfStudentsArray withFilter:self.searchBar.text];
        
    }
    
    else if (self.segmentControl.selectedSegmentIndex == VIRSortFirstName){
        
        [self generateSectionsInBackgroundArraByFirstName:self.namesOfStudentsArray withFilter:self.searchBar.text];
    }
    else {
        
        [self generateSectionsInBackgroundArraByLastName:self.namesOfStudentsArray withFilter:self.searchBar.text];
    }
    
}

- (IBAction)sortSegmentControl:(UISegmentedControl *)sender {
    
    if (self.segmentControl.selectedSegmentIndex == VIRSortBirhday ) {
        
        [self generateSectionsInBackgroundArraByBirhday:self.namesOfStudentsArray withFilter:self.searchBar.text];
        
    }
    
    else if (self.segmentControl.selectedSegmentIndex == VIRSortFirstName){
        
        [self generateSectionsInBackgroundArraByFirstName:self.namesOfStudentsArray withFilter:self.searchBar.text];
    }
    else {
        
        [self generateSectionsInBackgroundArraByLastName:self.namesOfStudentsArray withFilter:self.searchBar.text];
    }
}
@end
