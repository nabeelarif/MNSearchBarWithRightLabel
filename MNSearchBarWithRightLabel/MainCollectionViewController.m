//
//  MainCollectionViewController.m
//  MNSearchBarWithRightLabel
//
//  Created by Nabeel Arif on 10/18/15.
//  Copyright © 2015 Nabeel. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "SearchCollectionViewController.h"
#import "UISearchBar+RightLabel.h"

@interface MainCollectionViewController ()<UISearchResultsUpdating>

@property (nonatomic,strong) NSMutableArray *arrayCountryList;
@property (nonatomic,strong) NSMutableArray *arrraySearchResults;
@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierHeader = @"CellHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    
    // Do any additional setup after loading the view.
    
    // Create the search results controller and store a reference to it.
    SearchCollectionViewController *resultsController = (SearchCollectionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    [self.searchController.searchBar configureRightLabel];
    
    // Use the current view controller to update the search results.
    self.searchController.searchResultsUpdater = self;
    
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
    
    [self loadCountryArray];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayCountryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UILabel *label = (UILabel*)[cell viewWithTag:30];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 30;
        [cell addSubview:label];
    }
    label.text = [_arrayCountryList objectAtIndex:indexPath.row];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin = CGPointMake(16,20);
    label.frame = frame;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader
                                                                                     forIndexPath:indexPath];
        self.searchController.searchBar.tag = 30;
        if ([header viewWithTag:30]==nil) {
            [header addSubview:self.searchController.searchBar];
        }
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width-20, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width-10, 44.0);
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UISearchResultsUpdating Delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    
    SearchCollectionViewController *resController = (SearchCollectionViewController*)_searchController.searchResultsController;
    if (searchText && searchText.length>0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
        resController.filteredResults = [_arrayCountryList filteredArrayUsingPredicate:predicate];
        [self.searchController.searchBar setRightText:[NSString stringWithFormat:@"%lu Results",(unsigned long)resController.filteredResults.count]];
    }else{
        resController.filteredResults = @[];
        [self.searchController.searchBar setRightText:@"0 Results"];
    }
    [resController.collectionView reloadData];
}
@end
