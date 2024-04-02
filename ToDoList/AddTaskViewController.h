//
//  AddTaskViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "ToDoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController
@property (nonatomic, weak) ToDoViewController *toDoViewController;

@end

NS_ASSUME_NONNULL_END
