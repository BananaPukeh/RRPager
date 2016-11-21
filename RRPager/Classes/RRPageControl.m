//
//  RRPageControl.m
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import "RRPageControl.h"

@interface RRPageControl () <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

/**
 Contains the tab views
 */
@property (nonatomic, retain) NSMutableArray <UIView *> *tabViews;

@end

@implementation RRPageControl

#pragma mark - Initializers

- (instancetype)init{
    self = [super init];
    
    [self defaultSetup];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    [self defaultSetup];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self defaultSetup];
    
    return self;
}

- (void)defaultSetup{
    self.tabWidth = 50;
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
    
    /*
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50]];
     */
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    // TODO: remove this and fix autolayout
    self.scrollView.frame = self.bounds;
}

#pragma mark - Public 

- (void)reloadData{
    // Rebuild scrollview
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSUInteger numberTabs = [self.dataSource pageControlNumberOfTabs:self];
    self.tabViews = [NSMutableArray new];
    
    CGFloat x = 0;
    CGFloat height = self.bounds.size.height;
    
    
    self.scrollView.contentSize = CGSizeMake(numberTabs * self.tabWidth, height);
    
    for (int index = 0; index < numberTabs; index++) {
        UIView *tabView = [self.dataSource pageControl:self viewForTabAtIndex:index];
        tabView.frame = CGRectMake(x, 0, self.tabWidth, height);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabTabbed:)];
        [tabView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:tabView];
        [self.tabViews addObject:tabView];
        x+= self.tabWidth;
    }
}

- (void)selectTabAtIndex:(NSUInteger)index{
    
}



#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


#pragma mark - UITapGestureRecognizer

- (void)tabTabbed:(UITapGestureRecognizer *)recognizer{
    NSUInteger index =  [self.tabViews indexOfObject:recognizer.view];
    [self.delegate pageControl:self didSelectTabAtIndex:index];
}

@end
