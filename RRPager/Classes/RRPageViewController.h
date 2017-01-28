//
//  RRPageViewController.h
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import <UIKit/UIKit.h>
#import "RRPageControl.h"

@class RRPageViewController;


/**
 DataSource protocol
 */
@protocol RRPageViewControllerDataSource <NSObject>

@end


/**
 Delegate protocol
 */
@protocol RRPageViewControllerDelegate <NSObject>

@optional

- (void)pageController:(RRPageViewController * _Nonnull)controller didScrollToPage:(NSUInteger)index;

@end


/**
 Paging controller
 */
@interface RRPageViewController : UIViewController <RRPageViewControllerDataSource, RRPageViewControllerDelegate, RRPageControlDataSource, RRPageControlDelegate>

/**
 Our paging datasource supplier
 */
@property (nonnull, nonatomic, assign) id <RRPageViewControllerDataSource> dataSource;

/**
 Our paging delegate
 */
@property (nullable, nonatomic, assign) id <RRPageViewControllerDelegate> delegate;

/**
 Our page content controllers
 */
@property (nonnull, nonatomic, readonly) NSArray <UIViewController *> *pages;

/**
 The currently selected index
 */
@property (nonatomic, readonly) NSUInteger currentIndex;

/**
 Indicates if we're scrolling to a page
 */
@property (nonatomic) BOOL isScrolling;

/**
 The pagecontrol for our tabs
 */
@property (nonnull, nonatomic, retain) IBOutlet RRPageControl *pageControl;


#pragma mark - PageControl

/**
 Height for the page control
 */
@property (nonatomic) CGFloat pageControlHeight;


#pragma mark - Data


/**
 Set the page controllers for our pageController
 This will cause a `-reloadData` trigger
 
 @param controllers The controller to add
 */
- (void)setPageControllers:(nonnull NSArray <UIViewController *> *)controllers;


/**
 Reload our page controller
 */
- (void)reloadData;

/**
 Scroll to a page
 
 @param index The index to scroll to
 @param animated Should we scroll animated?
 */
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;


#pragma mark - Layout

/**
 The background color of the pagecontroller
 */
@property (nonatomic, retain) UIColor *pageBackgroundColor;


@end
