//
//  RRPageControl.h
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import <UIKit/UIKit.h>

@class RRPageControl;

@protocol RRPageControlDataSource <NSObject>

@required

/**
 Number of tabs in our PageControl
 
 @param control The PageControl
 @return Number of tabs
 */
- (NSUInteger)pageControlNumberOfTabs:(RRPageControl * _Nonnull)control;

/**
 View for a tab index
 
 @param control The PageControl
 @param index Index for the view
 @param bounds  The bounds that the view gets
 @return UIView for given index
 */
- (nonnull UIView *)pageControl:(RRPageControl * _Nonnull)control viewForTabAtIndex:(NSUInteger)index bounds:(CGRect)bounds;


@optional

/**
 Overrides the `self.tabWidth` property and specify tabwidths individually
 
 @param control The PageControl
 @param index Index for the tab
 @return Width for the tab
 */
- (CGFloat)pageControl:(RRPageControl * _Nonnull)control widthForTabAtIndex:(NSUInteger)index;


@end


@protocol RRPageControlDelegate <NSObject>

@optional

/**
 Called when a tab has been selected
 
 @param control The PageControl
 @param index The selected index
 */
- (void)pageControl:(RRPageControl * _Nonnull)control didSelectTabAtIndex:(NSUInteger)index;

@end


@interface RRPageControl : UIView

/**
 DataSource provider for the PageControl
 */
@property (nonnull, nonatomic, assign) id<RRPageControlDataSource> dataSource;

/**
 Delegate callbacks for the PageControl
 */
@property (nullable, nonatomic, assign) id<RRPageControlDelegate> delegate;

/**
 Paging indicator
 */
@property (nonnull, nonatomic, retain, readonly) UIView *indicator;

/**
 The selected tab index
 */
@property (nonatomic, readonly) NSUInteger selectedIndex;

/**
 The width for the tabs
 Default: 50
 */
@property (nonatomic) NSUInteger tabWidth;

/**
 Reloads the dataSource
 */
- (void)reloadData;

/**
 Select a tab animated
 
 @param index The tabIndex to select
 */
- (void)selectTabAtIndex:(NSUInteger)index;

/**
 Select a tab
 
 @param index The tabIndex to select
 @param animated Should we select animated?
 */
- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 Update the progress for the selected index
 
 @param progress Value between -1 and 1
 */
- (void)scrollProgress:(CGFloat)progress;

@end
