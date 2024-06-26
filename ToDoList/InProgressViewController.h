//
//  InProgressViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DetailsTaskDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailsTaskDelegate>

@property (weak, nonatomic) IBOutlet UITableView *InProgressTableView;

@property (nonatomic, strong) NSMutableArray<TaskModel *> *InProgressList;


@end

NS_ASSUME_NONNULL_END
