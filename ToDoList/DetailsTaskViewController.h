//
//  DetailsTaskViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "ToDoViewController.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"
#import "DetailsTaskDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTaskViewController : UIViewController

@property TaskModel *task;
@property (nonatomic, weak)  ToDoViewController *toDoViewController;
@property (nonatomic, weak)  InProgressViewController *inProgressViewController;
@property (nonatomic, weak)  DoneViewController *doneViewController;


@property (nonatomic, weak) id <DetailsTaskDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
