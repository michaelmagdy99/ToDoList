//
//  TaskModel.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

// TaskModel.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject

@property NSString *taskName;
@property NSString *taskDescription;
@property NSString *taskDate;
@property int taskPriority;
@property int taskStatus;

@end

NS_ASSUME_NONNULL_END

