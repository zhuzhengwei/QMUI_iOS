//
//  UICollectionView+QMUI.m
//  qmui
//
//  Created by ZhoonChen on 15/7/20.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "UICollectionView+QMUI.h"

@implementation UICollectionView (QMUI)

- (void)qmui_clearsSelection {
    NSArray *selectedItemIndexPaths = [self indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedItemIndexPaths) {
        [self deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (void)qmui_reloadDataKeepingSelection {
    NSArray *selectedIndexPaths = [self indexPathsForSelectedItems];
    [self reloadData];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

/// 递归找到view在哪个cell里，不存在则返回nil
- (UICollectionViewCell *)parentCellForView:(UIView *)view {
    if (!view.superview) {
        return nil;
    }
    
    if ([view.superview isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)view.superview;
    }
    
    return [self parentCellForView:view.superview];
}

- (NSIndexPath *)qmui_indexPathForItemAtView:(id)sender {
    if (sender && [sender isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)sender;
        UICollectionViewCell *parentCell = [self parentCellForView:view];
        if (parentCell) {
            return [self indexPathForCell:parentCell];
        }
    }
    
    return nil;
}

- (BOOL)qmui_itemVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleItemIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<NSIndexPath *> *)qmui_indexPathsForVisibleItems {
    NSArray<NSIndexPath *> *visibleItems = [self indexPathsForVisibleItems];
    NSSortDescriptor *sectionSorter = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSSortDescriptor *rowSorter = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
    visibleItems = [visibleItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sectionSorter,rowSorter, nil]];
    return visibleItems;
}

- (NSIndexPath *)qmui_indexPathForFirstVisibleCell {
    NSArray *visibleIndexPaths = [self qmui_indexPathsForVisibleItems];
    if (!visibleIndexPaths || visibleIndexPaths.count <= 0) {
        return nil;
    }
    
    return visibleIndexPaths.firstObject;
}

@end
