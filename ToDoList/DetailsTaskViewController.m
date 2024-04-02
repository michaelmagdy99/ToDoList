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

@implementation DetailsTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskNameTV.text = _task.taskName;
    self.tasDescTv.text = _task.taskDescription;
    self.TaskdateTV.text = _task.taskDate;
    self.priotoriySelectEdit.selectedSegmentIndex = self.task.taskPriority;
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
        case 0:
            self.task.taskStatus = 0; //inprogress
            break;
        case 1:
            self.task.taskPriority = 1; //done
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
