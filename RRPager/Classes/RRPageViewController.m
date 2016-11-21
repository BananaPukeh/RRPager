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

@implementation RRPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the datasource and delegate to self, catch this in your subclass
    self.dataSource = self;
    self.delegate = self;
    
    [self setupPageController];
}


#pragma mark - PageViewController

- (void)setupPageController{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    self.pageController.view.frame = self.view.bounds;
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
    
    NSMutableArray <NSNumber *> *indexes = [NSMutableArray new];
    for (UIViewController *vc in pageViewController.viewControllers) {
        NSUInteger index = [self.pages indexOfObject:vc];
        [indexes addObject:@(index)];
    }
    
    NSUInteger index = [self.pages indexOfObject:pageViewController.viewControllers.firstObject];
    
    NSLog(@"willTransition: %lu",(long unsigned)index);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    NSUInteger newIndex = [self.pages indexOfObject: pageViewController.viewControllers.firstObject];
    
    NSLog(@"didFinishAnimating: current: %lu", (long unsigned)newIndex);
    
    [self setCurrentIndex:newIndex];
}


@end
