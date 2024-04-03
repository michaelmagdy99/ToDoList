//
//  ViewController.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import "DoneViewController.h"
#import "TaskModel.h"
#import "DetailsTaskViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController{
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
     [self.doneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"doneCell"];

}


- (void)viewWillAppear:(BOOL)animated{
    
    
     userDefault = [NSUserDefaults standardUserDefaults];
         
     defaultTasks = [userDefault objectForKey:@"DoneTaskList"];
         if (defaultTasks != nil) {
             self.doneList = [NSKeyedUnarchiver unarchiveObjectWithData:defaultTasks];
             } else {
                 self.doneList = [[NSMutableArray alloc] init];
             }
    
    
    [self.doneTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doneList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    TaskModel *taskModel = [TaskModel new];
    taskModel = self.doneList[indexPath.row];
    
    cell.textLabel.text = taskModel.taskName;
    
    switch (taskModel.taskPriority) {
          case 0:
              cell.imageView.image = [UIImage imageNamed:@"1"];
              break;
          case 1:
              cell.imageView.image = [UIImage imageNamed:@"2"];
              break;
          case 2:
              cell.imageView.image = [UIImage imageNamed:@"3"];
              break;
          default:
              break;
      }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are You sure delete Task?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.doneList removeObjectAtIndex:indexPath.row];
            
            defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.doneList];
            [userDefault setObject:defaultTasks forKey:@"DoneTaskList"];
            BOOL synchronizeResult = [userDefault synchronize];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }];
        
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert addAction:no];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:nil];
       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskModel *selectTask;
    
    selectTask = self.doneList[indexPath.row];
        
    DetailsTaskViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTaskViewController"];
    
    detailViewController.task = selectTask;
    detailViewController.delegate = self;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)didEditTask:(TaskModel *)task {
    NSUInteger index = [self.doneList indexOfObject:task];
    defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.doneList];
    [userDefault setObject:defaultTasks forKey:@"DoneTaskList"];
    [userDefault synchronize];
    
    [self.doneTableView reloadData];
}

@end
