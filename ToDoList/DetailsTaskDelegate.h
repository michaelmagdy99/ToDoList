//
//  DetailsTaskDelegate.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsTaskDelegate <NSObject>

- (void)didEditTask:(TaskModel *)task;

@end

NS_ASSUME_NONNULL_END
