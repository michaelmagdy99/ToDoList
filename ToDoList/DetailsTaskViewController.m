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
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end

@implementation DetailsTaskViewController{
    NSUserDefaults *userDefault;
    NSMutableArray *arrTodo ;
    NSMutableArray *arrInProgress ;
    NSMutableArray *arrDone ;
    BOOL isEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    arrTodo = [NSMutableArray new];
    arrDone = [NSMutableArray new];
    arrInProgress = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    self.taskNameTV.text = self.task.taskName;
    self.tasDescTv.text = self.task.taskDescription;
    self.TaskdateTV.text = self.task.taskDate;
    self.priotoriySelectEdit.selectedSegmentIndex = self.task.taskPriority;
    self.editSelector.selectedSegmentIndex = self.task.taskStatus;
    
    isEdit = NO;
    self.taskNameTV.enabled = NO;
    self.tasDescTv.enabled = NO;
    self.priotoriySelectEdit.enabled = NO;
    self.editSelector.enabled = NO;
    
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDate *tododata = [userDefault objectForKey:@"TaskList"];
    arrTodo = [NSKeyedUnarchiver unarchiveObjectWithData:tododata];
    
    
    NSData *inprogressData = [userDefault objectForKey:@"InProgressTaskList"];
    //arrInProgress = [NSMutableArray new];
    arrInProgress = [NSKeyedUnarchiver unarchiveObjectWithData:inprogressData];
    arrInProgress = [NSMutableArray new];

    
    NSData *doneData = [userDefault objectForKey:@"DoneTaskList"];
    //arrDone = [NSMutableArray new];
    arrDone = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
    arrDone = [NSMutableArray new];

}

- (IBAction)editAction:(id)sender {
    isEdit =! isEdit;

    if(isEdit){
        self.taskNameTV.enabled = YES;
        self.tasDescTv.enabled = YES;
        self.priotoriySelectEdit.enabled = YES;
        self.editSelector.enabled = YES;
        
        [self.editButton setTitle:@"save" forState:UIControlStateNormal];

    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are You sure Edit Task?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        
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
                    // in progress
                    self.task.taskStatus = 0;
                    [arrInProgress addObject:self.task];
                    [arrTodo removeObject:self.task];
                    break;
                    
                case 1:
                    // Done
                    self.task.taskStatus = 1;
                    [arrDone addObject:self.task];
                    [arrTodo removeObject:self.task];
                    [arrInProgress removeObject:self.task];
                    break;
                default:
                    break;
            }
            
            
            NSData *toDoData = [NSKeyedArchiver archivedDataWithRootObject:arrTodo];
            [self->userDefault setObject:toDoData forKey:@"TaskList"];
            
            NSData *inProgressData = [NSKeyedArchiver archivedDataWithRootObject:arrInProgress];
            [self->userDefault setObject:inProgressData forKey:@"InProgressTaskList"];
            
            NSData *doneData = [NSKeyedArchiver archivedDataWithRootObject:arrDone];
            [self->userDefault setObject:doneData forKey:@"DoneTaskList"];
                    
            if ([self.delegate respondsToSelector:@selector(didEditTask:)]) {
                [self.delegate didEditTask:self.task];
                
            }else{
                printf("=========");
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert addAction:no];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:nil];
       
    }
    
}

@end
