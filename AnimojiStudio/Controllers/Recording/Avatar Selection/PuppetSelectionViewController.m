//
//  PuppetSelectionViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "PuppetSelectionViewController.h"

#import "AVTAnimoji.h"

#import "PuppetCollectionViewCell.h"

NSString * const kPuppetCellIdentifier = @"PuppetCell";

@interface PuppetSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray <NSString *> *puppetNames;

@end

@implementation PuppetSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Choose Character";
    self.puppetNames = [ASAnimoji puppetNames];
    
    [self build];
}

- (void)build
{
    self.flowLayout = [self _makeFlowLayout];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    
    self.collectionView.alwaysBounceVertical = !self.usesHorizontalLayout;
    self.collectionView.alwaysBounceHorizontal = self.usesHorizontalLayout;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView setOpaque:YES];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = nil;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView.frame = self.view.bounds;
    
    [self.collectionView registerClass:[PuppetCollectionViewCell class] forCellWithReuseIdentifier:kPuppetCellIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (UICollectionViewFlowLayout *)_makeFlowLayout
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    layout.scrollDirection = (self.usesHorizontalLayout) ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    
    CGFloat itemSize;
    CGFloat padding;
    
    if (self.usesHorizontalLayout) {
        NSAssert(self.referenceHeight > 0, @"refereceHeight must be greater than zero when usesHorizontalLayout == YES");
        padding = 4;
        itemSize = self.referenceHeight - padding * 2;
    } else {
        padding = 28;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat puppetsPerLine = 3;
        
        itemSize = (screenWidth / puppetsPerLine) - (padding * puppetsPerLine) + (padding * 2);
    }
    
    layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    
    return layout;
}

- (void)setPuppetNames:(NSArray<NSString *> *)puppetNames
{
    _puppetNames = [puppetNames copy];
    
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.collectionView.indexPathsForSelectedItems.count) {
        [self.collectionView deselectItemAtIndexPath:self.collectionView.indexPathsForSelectedItems.firstObject animated:NO];
    }

    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)selectPuppetWithName:(NSString *)puppetName
{
    if (!self.usesHorizontalLayout) return;
    
    if (![self.puppetNames containsObject:puppetName]) return;
    NSUInteger idx = [self.puppetNames indexOfObject:puppetName];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.puppetNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PuppetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPuppetCellIdentifier forIndexPath:indexPath];
    
    cell.puppetName = self.puppetNames[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.puppetNames[indexPath.item];
    
    [self.delegate puppetSelectionViewController:self didSelectPuppetWithName:name];
}

@end
