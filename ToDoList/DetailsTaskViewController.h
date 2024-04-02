//
//  DetailsTaskViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "ToDoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTaskViewController : UIViewController
@property TaskModel *task;

@property (nonatomic, weak)  ToDoViewController*toDoViewController;

@end

NS_ASSUME_NONNULL_END
