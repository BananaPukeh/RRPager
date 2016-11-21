//
//  RRPageViewController.m
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import "RRPageViewController.h"

@interface RRPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, retain) UIPageViewController *pageController;

@end

@implementation RRPageViewController{
    CGFloat internalPageControlHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the datasource and delegate to self, catch this in your subclass
    self.dataSource = self;
    self.delegate = self;
    
    // Setup default pageControl if none is specified through Interface Builder
    internalPageControlHeight = 0;
    if (!self.pageControl){
        self.pageControl = [RRPageControl new];
        self.pageControl.dataSource = self;
        self.pageControl.delegate = self;
        
        [self.view addSubview:self.pageControl];
        internalPageControlHeight = 50;
        self.pageControl.backgroundColor = [UIColor redColor];
    }
    
    [self setupPageController];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.pageController.view.frame = internalPageControlHeight == 0 ? self.view.bounds : CGRectMake(0, internalPageControlHeight, self.view.bounds.size.width, self.view.bounds.size.height-internalPageControlHeight);
    self.pageControl.frame = CGRectMake(0, 0, self.pageController.view.bounds.size.width, internalPageControlHeight);
}


#pragma mark - PageViewController

- (void)setupPageController{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self.view addSubview:self.pageController.view];
}

- (void)setPageControllers:(NSArray<UIViewController *> *)controllers{
    _pages = controllers;
    [self reloadData];
}

- (void)reloadData{
    NSArray *pages = self.pages;
    if (!self.pages || self.pages.count == 0){
        pages = @[[UIViewController new]];
    }
        
        
    [self.pageController setViewControllers:@[pages.firstObject]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
                                     
                                 }];
    
    [self.pageControl reloadData];
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated{
    if (index >= self.pages.count || index < 0){
        NSLog(@"ERROR: scrollToIndex:animated: index:(%lu) is out of bounds:(%lu)", (long unsigned)index, (long unsigned)self.pages.count-1);
        return;
    }
    else if (self.isScrolling){
        NSLog(@"WARN: scrollToIndex:animated: We're already scrolling, terminating request..");
        return;
    }
    
    // Lock other scroll events
    _isScrolling = YES;
    
    UIViewController *controller = self.pages[index];
    
    
    UIPageViewControllerNavigationDirection direction = self.currentIndex > index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    
    [self.pageController setViewControllers:@[controller]
                                  direction:direction
                                   animated:animated
                                 completion:^(BOOL finished) {
                                     // TODO: Make callback
                                     NSLog(@"scrollToIndex: completed");
                                     
                                     _isScrolling = NO;
                                     [self setCurrentIndex:index];
                                     
                                 }];
}


#pragma mark - Properties

- (void)setCurrentIndex:(NSUInteger)newIndex{
    NSLog(@"Index changed %lu => %lu", (long unsigned)self.currentIndex, (long unsigned)newIndex);
    _currentIndex = newIndex;
}


#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index == 0){
        // This is already the first object
        return nil;
    }
    else{
        return self.pages[index-1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index+1 == self.pages.count){
        // This is already the last object
        return nil;
    }
    else{
        return self.pages[index+1];
    }
}


#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSUInteger index = [self.pages indexOfObject:pageViewController.viewControllers.firstObject];
    
    NSLog(@"willTransition: %lu",(long unsigned)index);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    NSUInteger newIndex = [self.pages indexOfObject: pageViewController.viewControllers.firstObject];
    
    NSLog(@"didFinishAnimating: current: %lu", (long unsigned)newIndex);
    
    [self setCurrentIndex:newIndex];
}


#pragma mark - RRPageControl DataSource

- (NSUInteger)pageControlNumberOfTabs:(RRPageControl *)control{
    return self.pages.count;
}

- (UIView *)pageControl:(RRPageControl *)control viewForTabAtIndex:(NSUInteger)index{
    UIView *view = [UIView new];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, control.tabWidth, control.bounds.size.height)];
    lbl.text = @(index).stringValue;
    lbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbl];
    
    return view;
}


#pragma mark - RRPageControl Delegate

- (void)pageControl:(RRPageControl *)control didSelectTabAtIndex:(NSUInteger)index{
    [self scrollToIndex:index animated:YES];
}

@end
