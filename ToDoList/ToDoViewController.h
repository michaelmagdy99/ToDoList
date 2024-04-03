//
//  ToDoViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DetailsTaskDelegate.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailsTaskDelegate , UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property (nonatomic, strong) NSMutableArray<TaskModel *> *ToDotaskList;

@property (nonatomic, weak)  InProgressViewController *inProgressViewController;
@property (nonatomic, weak)  DoneViewController *doneViewController;

@end

NS_ASSUME_NONNULL_END
