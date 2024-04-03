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
#import <UserNotifications/UserNotifications.h>

@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySelector;

@end

@implementation AddTaskViewController{
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userDefault = [NSUserDefaults standardUserDefaults];
        
}

- (void)viewWillAppear:(BOOL)animated{
    defaultTasks = [userDefault objectForKey:@"TaskList"];
        if (defaultTasks != nil) {
            self.toDoViewController.ToDotaskList = [NSKeyedUnarchiver unarchiveObjectWithData:defaultTasks];
            } else {
                self.toDoViewController.ToDotaskList = [NSMutableArray new];
            }
    

    // Request authorization for notifications
       UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
       [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                 if (!granted) {
                                     NSLog(@"Notification authorization denied");
                                 }
                             }];

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
    
    
    //
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString *dtString = dateString;
    NSDate *date = [dateFormatter dateFromString:dtString];

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar] ;
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    components.minute -= 30;
    NSDate *fireDate = [calendar dateFromComponents:components];
    
    
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
    
    [self scheduleReminderForTask:newTask];
    
    newTask.taskStatus = -1 ;
    
    [self.toDoViewController.ToDotaskList addObject:newTask];

    defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.toDoViewController.ToDotaskList];
        [userDefault setObject:defaultTasks forKey:@"TaskList"];
        BOOL synchronizeResult = [userDefault synchronize];
        
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scheduleReminderForTask:(TaskModel *)task {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = task.taskName;
    content.body = task.taskDescription;
    content.sound = [UNNotificationSound defaultSound];
    
    // Calculate the date one minute from the current time
    NSDate *currentDate = [NSDate date];
    NSDate *taskDate = [currentDate dateByAddingTimeInterval:60]; // Add 60 seconds for one minute
    
    // Create a date formatter to convert the taskDate to a string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *taskDateString = [dateFormatter stringFromDate:taskDate];
    
    // Print the scheduled date for debugging
    NSLog(@"Scheduled Date: %@", taskDateString);
    
    // Create the trigger based on the calculated taskDate
    NSTimeInterval timeInterval = [taskDate timeIntervalSinceNow];
    if (timeInterval > 0) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
        
        // Create the notification request
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:task.taskName content:content trigger:trigger];
        
        // Add the notification request to the notification center
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error scheduling notification: %@", error);
            } else {
                NSLog(@"Notification scheduled successfully.");
            }
        }];
    }
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionAlert);
}
@end


