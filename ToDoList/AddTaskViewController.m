//
//  AddTaskViewController.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//
//  AddTaskViewController.m

#import "AddTaskViewController.h"
#import "TaskModel.h"
#import "ToDoViewController.h"

@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySelector;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)saveTask:(id)sender {
    TaskModel *newTask = [[TaskModel alloc] init];
    newTask.taskName = self.taskName.text;
    newTask.taskDescription = self.taskDesc.text;
    
    // Get currentdate
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];

    
    // Set date
    newTask.taskDate = dateString;
    
    // Set priority
    switch (self.prioritySelector.selectedSegmentIndex) {
        case 0:
            newTask.taskPriority = 0;
            break;
        case 1:
            newTask.taskPriority = 1;
            break;
        case 2:
            newTask.taskPriority = 2;
            break;
        default:
            break;
    }
    
    newTask.taskStatus = 0 ;
    
    [self.toDoViewController.ToDotaskList addObject:newTask];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

