//
//  RRPageViewController.h
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import <UIKit/UIKit.h>

@class RRPageViewController;


/**
 DataSource protocol
 */
@protocol RRPageViewControllerDataSource <NSObject>

//@required
//
//- (NSUInteger)pageControllerNumberOfPages:(RRPageViewController *)controller;
//
//- (UIViewController *)pageController:(RRPageViewController *)controller controllerForIndex:(NSInteger)index;

@end


/**
 Delegate protocol
 */
@protocol RRPageViewControllerDelegate <NSObject>

@optional

- (void)pageController:(RRPageViewController *)controller didScrollToPage:(NSUInteger)index;

@end


/**
 Paging controller
 */
@interface RRPageViewController : UIViewController <RRPageViewControllerDataSource, RRPageViewControllerDelegate>


/**
 Our paging datasource supplier
 */
@property (nonatomic, assign) id <RRPageViewControllerDataSource> dataSource;

/**
 Our paging delegate
 */
@property (nonatomic, assign) id <RRPageViewControllerDelegate> delegate;


/**
 Our page content controllers
 */
@property (nonatomic, readonly) NSArray <UIViewController *> *pages;

/**
 The currently selected index
 */
@property (nonatomic, readonly) NSUInteger currentIndex;


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


@end
