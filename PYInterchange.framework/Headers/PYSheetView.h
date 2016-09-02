//
//  PYSheetView.h
//  PYInterchange
//
//  Created by wlpiaoyi on 16/5/17.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PYSheetView;

@protocol PYSheetViewDelegate <NSObject>

@required
-(NSUInteger) numberOfRowInSheetView:(nonnull PYSheetView *) sheetView;
-(CGFloat)  sheetView:(nonnull PYSheetView *) sheetView heightOfRowIndex:(NSInteger) rowIndex;
-(nonnull UIView *)  cellOfsheetView:(nonnull PYSheetView *) sheetView;
@optional
-(void) sheetView:(nonnull PYSheetView *) sheetView cell:(nonnull UIView *) cell cellOfRowIndex:(NSInteger) rowIndex;
-(void) sheetView:(nonnull PYSheetView *) sheetView didSelectRowAtRowIndex:(NSInteger) rowIndex;
-(void) sheetView:(nonnull PYSheetView *) sheetView didDidChangeCell:(nonnull UIView *) cell;
@end

@interface PYSheetView : UIView
@property (nonatomic, assign, nullable) id<PYSheetViewDelegate> delegate;
- (void)selectRowAtIndexRow:(NSInteger ) indexRow animated:(BOOL)animated;
-(void) reloadData;
@end
