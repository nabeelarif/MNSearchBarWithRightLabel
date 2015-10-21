//
//  ViewController.m
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/14/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import "MainTableViewController.h"
#import "SearchResultsTableViewController.h"

@interface MainTableViewController () <UISearchResultsUpdating>

@property (nonatomic,strong) NSMutableArray *arrayCountryList;
@property (nonatomic,strong) NSMutableArray *arrraySearchResults;
@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create the search results controller and store a reference to it.
    SearchResultsTableViewController *resultsController = [[SearchResultsTableViewController alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    
    // Use the current view controller to update the search results.
    self.searchController.searchResultsUpdater = self;
    
    // Install the search bar as the table header.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;


    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadCountryArray];
}
// http://stackoverflow.com/questions/502764/iphone-obtaining-a-list-of-countries-in-an-nsarray
-(void)loadCountryArray{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    for (NSString *countryCode in countryArray) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [sortedCountryArray addObject:displayNameString];
        
    }
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    _arrayCountryList = sortedCountryArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCountryList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
    }
    cell.textLabel.text = [_arrayCountryList objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchResultsUpdating Delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    
    SearchResultsTableViewController *resController = (SearchResultsTableViewController*)_searchController.searchResultsController;
    if (searchText && searchText.length>0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
        resController.filteredResults = [_arrayCountryList filteredArrayUsingPredicate:predicate];
    }else{
        resController.filteredResults = @[];
    }
    [resController.tableView reloadData];
}

@end
