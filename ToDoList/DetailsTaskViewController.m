//
//  DetailsTaskViewController.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import "DetailsTaskViewController.h"

@interface DetailsTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTV;
@property (weak, nonatomic) IBOutlet UITextField *tasDescTv;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priotoriySelectEdit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editSelector;
@property (weak, nonatomic) IBOutlet UILabel *TaskdateTV;

@end

@implementation DetailsTaskViewController {
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    
    self.taskNameTV.text = self.task.taskName;
    self.tasDescTv.text = self.task.taskDescription;
    self.TaskdateTV.text = self.task.taskDate;
    self.priotoriySelectEdit.selectedSegmentIndex = self.task.taskPriority;
    self.editSelector.selectedSegmentIndex = self.task.taskStatus;
    
}

- (IBAction)editAction:(id)sender {

    self.task.taskName = self.taskNameTV.text;
    self.task.taskDescription = self.tasDescTv.text;
        
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    self.task.taskDate = dateString;
        
    switch (self.priotoriySelectEdit.selectedSegmentIndex) {
        case 0:
            self.task.taskPriority = 0;
            break;
        case 1:
            self.task.taskPriority = 1;
            break;
            case 2:
            self.task.taskPriority = 2;
            break;
        default:
            break;
    }
        
    switch (self.editSelector.selectedSegmentIndex) {
        case 0: {
            if (self.task.taskStatus == -1) {
                
                if ([self.toDoViewController.ToDotaskList containsObject:self.task]) {
                    [self.toDoViewController.ToDotaskList removeObject:self.task];
                    NSData *todoTasksData = [NSKeyedArchiver archivedDataWithRootObject:self.toDoViewController.ToDotaskList];
                        [userDefault setObject:todoTasksData forKey:@"TaskList"];
                        [userDefault synchronize];
                        [self.toDoViewController.toDoTableView reloadData];
                    
                    }
                
                self.task.taskStatus = 0;
                
                    if (![self.inProgressViewController.InProgressList containsObject:self.task]) {
                        [self.inProgressViewController.InProgressList addObject:self.task];
                        NSData *inProgressTasksData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressViewController.InProgressList];
                        [userDefault setObject:inProgressTasksData forKey:@"InProgressTaskList"];
                        [userDefault synchronize];
                        [self.inProgressViewController.InProgressTableView reloadData];
                    }
                }
                 
                break;
            }
        case 1:
                // Done
                self.task.taskStatus = 1;
                
            break;
            default:
                break;
        }

        if ([self.delegate respondsToSelector:@selector(didEditTask:)]) {
            [self.delegate didEditTask:self.task];
        }
    
        [self.navigationController popViewControllerAnimated:YES];
}

@end
