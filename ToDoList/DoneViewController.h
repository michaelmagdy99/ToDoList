//
//  ViewController.h
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DetailsTaskDelegate.h"

@interface DoneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailsTaskDelegate>


@property (nonatomic, strong) NSMutableArray<TaskModel *> *doneList;

@end

