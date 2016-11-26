//
//  RRPageViewController.m
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import "RRPageViewController.h"

@interface RRPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

/**
 The PageController that contains the content controllers
 */
@property (nonatomic, retain) UIPageViewController *pageController;


/**
 View that contains the RRPageControl if not created manually
 */
@property (nonatomic, retain) UIView *pageControlWrapper;

@end

@implementation RRPageViewController{
    
    // Bools
    BOOL sendScrollProgress;
    
    // Constraints
    NSLayoutConstraint *constraintPageControlHeight;
    NSLayoutConstraint *constraintPageControlWrapperTop;
}

@synthesize pageControlHeight = _pageControlHeight;
@synthesize pageBackgroundColor = _pageBackgroundColor;

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the datasource and delegate to self, catch this in your subclass
    self.dataSource = self;
    self.delegate = self;
    
    [self setupPageController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.pageControl reloadData];
    
}


#pragma mark - PageViewController

- (void)setupPageController{
    
    // Page controller
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    sendScrollProgress = YES;
    
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]){
            ((UIScrollView *)view).delegate = self;
        }
        
    }
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self.view addSubview:self.pageController.view];
    
    // Page control wrapper
    self.pageControlWrapper = [UIView new];
    [self.view addSubview:self.pageControlWrapper];
    
    self.pageControlWrapper.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Page control constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControlWrapper attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControlWrapper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    constraintPageControlWrapperTop = [NSLayoutConstraint constraintWithItem:self.pageControlWrapper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:constraintPageControlWrapperTop];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControlWrapper attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    // Height
    constraintPageControlHeight = [NSLayoutConstraint constraintWithItem:self.pageControlWrapper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.pageControlHeight];
    [self.pageControlWrapper addConstraint:constraintPageControlHeight];
    
    // Page controller constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    // Setup default pageControl if none is specified through Interface Builder
    if (!self.pageControl){
        self.pageControl = [RRPageControl new];
        self.pageControl.dataSource = self;
        self.pageControl.delegate = self;
        self.pageControl.backgroundColor = [UIColor whiteColor];
        [self.pageControlWrapper addSubview:self.pageControl];
        
        // Shadow
        self.pageControl.layer.shadowColor = [UIColor blackColor].CGColor;
        self.pageControl.layer.shadowOffset = CGSizeMake(0, 3);
        self.pageControl.layer.shadowRadius = 1.5;
        self.pageControl.layer.shadowOpacity = .1;
        
        // Page control constraints
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.pageControlWrapper addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.pageControlWrapper attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [self.pageControlWrapper addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pageControlWrapper attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self.pageControlWrapper addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageControlWrapper attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.pageControlWrapper addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageControlWrapper attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
}

- (void)setPageControllers:(NSArray<UIViewController *> *)controllers{
    if (!controllers || controllers.count == 0){
        _pages = @[[UIViewController new]];
    }
    else{
        _pages = controllers;
    }
    
    [self reloadData];
}

- (void)reloadData{
    NSArray *pages = self.pages;
    
    if (self.isScrolling) {
        NSLog(@"-reloadData, already scrolling!");
        return;
    }
    [self.pageController setViewControllers:@[pages.firstObject]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
                                     // Reset this
                                     self.isScrolling = NO;
                                     sendScrollProgress = YES;
                                 }];
    self.currentIndex = 0;
    [self.pageControl reloadData];
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated{
    if (index >= self.pages.count || (NSInteger)index < 0){
        NSLog(@"ERROR: scrollToIndex:animated: index:(%lu) is out of bounds:(%lu)", (long unsigned)index, (long unsigned)self.pages.count-1);
        return;
    }
    else if (self.currentIndex == index){
        //NSLog(@"WARN: scrollToIndex:animated: Already at index %lu, terminating scroll", (long unsigned)index);
        return;
    }
    else if (self.isScrolling){
        //NSLog(@"WARN: scrollToIndex:animated: We're already scrolling, terminating request..");
        return;
    }
    
    // Lock other scroll events
    [self setIsScrolling:YES];
    // Dont send scroll progress
    sendScrollProgress = NO;
    
    // Animate the page control
    [self.pageControl selectTabAtIndex:index animated:animated];
    
    UIViewController *controller = self.pages[index];
    
    UIPageViewControllerNavigationDirection direction = self.currentIndex > index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    
    __weak RRPageViewController *weakSelf = self;
    //NSLog(@"-scrollToIndex:(%lu) animated:(%@), currentIndex:(%lu)", (unsigned long)index, animated ? @"YES" : @"NO", (unsigned long)self.currentIndex);
    
    [self.pageController setViewControllers:@[controller]
                                  direction:direction
                                   animated:animated
                                 completion:^(BOOL finished) {
                                     
                                     //  NSLog(@"scrollToIndex: completed");
                                     
                                     [weakSelf setCurrentIndex:index];
                                     [self setIsScrolling:NO];
                                     sendScrollProgress = YES;
                                     
                                 }];
}


#pragma mark - Properties

- (void)setCurrentIndex:(NSUInteger)newIndex{
    if (newIndex > NSIntegerMax) return; // Invalid data..
    
    NSLog(@"Index changed %lu => %lu", (long unsigned)self.currentIndex, (long unsigned)newIndex);
    _currentIndex = newIndex;
    
    [self.pageControl selectTabAtIndex:newIndex animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:didScrollToPage:)]){
        [self.delegate pageController:self didScrollToPage:newIndex];
    }
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight{
    _pageControlHeight = pageControlHeight;
    
    // Update contstraints
    constraintPageControlHeight.constant = pageControlHeight;
}

- (CGFloat)pageControlHeight{
    if (!_pageControlHeight){
        _pageControlHeight = 60;
    }
    return _pageControlHeight;
}

- (void)setIsScrolling:(BOOL)isScrolling{
    _isScrolling = isScrolling;
}


#pragma mark - Layout

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // Not sure if this is the correct way to do
    constraintPageControlWrapperTop.constant = self.topLayoutGuide.length;
}

- (UIColor *)pageBackgroundColor{
    if (_pageBackgroundColor){
        [self setPageBackgroundColor:[UIColor clearColor]];
    }
    return _pageBackgroundColor;
}

- (void)setPageBackgroundColor:(UIColor *)pageBackgroundColor{
    
    _pageBackgroundColor = pageBackgroundColor;
    
    self.pageController.view.backgroundColor = _pageBackgroundColor;
}


#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (![self.pages containsObject:viewController]) return nil; // Invalid data
    
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index == 0){
        // This is already the first object
        return nil;
    }
    else{
        if (self.pages[index-1]){
            return self.pages[index-1];
        }
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (![self.pages containsObject:viewController]) return nil; // Invalid data
    
    NSUInteger index = [self.pages indexOfObject:viewController];
    if (index+1 == self.pages.count){
        // This is already the last object
        return nil;
    }
    else{
        if (self.pages[index+1]){
            return self.pages[index+1];
        }
        return nil;
    }
}


#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSUInteger index = [self.pages indexOfObject:pendingViewControllers.firstObject];
    
    //    [self.pageControl peekTabAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    NSUInteger newIndex = [self.pages indexOfObject: pageViewController.viewControllers.firstObject];
    if(newIndex > NSIntegerMax){
        // Invalid maxIndex..
        return;
    }
    [self setCurrentIndex:newIndex];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Only send progress when we should
    if (sendScrollProgress){
        CGFloat origin = self.view.bounds.size.width;
        [self.pageControl scrollProgress:(scrollView.contentOffset.x/origin)-1];
    }
}


#pragma mark - RRPageControl DataSource

- (NSUInteger)pageControlNumberOfTabs:(RRPageControl *)control{
    return self.pages.count;
}

- (UIView *)pageControl:(RRPageControl *)control viewForTabAtIndex:(NSUInteger)index bounds:(CGRect)bounds{
    UIView *view = [UIView new];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:bounds];
    lbl.text = @(index).stringValue;
    lbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbl];
    
    return view;
}

- (CGFloat)pageControl:(RRPageControl *)control widthForTabAtIndex:(NSUInteger)index{
    return 50;
}


#pragma mark - RRPageControl Delegate

- (void)pageControl:(RRPageControl *)control didSelectTabAtIndex:(NSUInteger)index{
    [self scrollToIndex:index animated:YES];
}



@end
