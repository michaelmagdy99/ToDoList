//
//  InProgressViewController.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import "InProgressViewController.h"
#import "TaskModel.h"
#import "DetailsTaskViewController.h"

@interface InProgressViewController ()

@end

@implementation InProgressViewController
{
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.InProgressList = [[NSMutableArray alloc] init];

    [self.InProgressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"inProgressCell"];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    userDefault = [NSUserDefaults standardUserDefaults];

    defaultTasks = [userDefault objectForKey:@"InProgressTaskList"];
    self.InProgressList = [NSKeyedUnarchiver unarchiveObjectWithData:defaultTasks];
    if(defaultTasks != nil){
        printf("%lu" , (unsigned long)self.InProgressList.count);
        [self.InProgressTableView reloadData];
    }else{
        self.InProgressList =[NSMutableArray new];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.InProgressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
    TaskModel *taskModel = [TaskModel new];
    taskModel = self.InProgressList[indexPath.row];
    
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
            
            [self.InProgressList removeObjectAtIndex:indexPath.row];
            
            self->defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.InProgressList];
            [self->userDefault setObject:self->defaultTasks forKey:@"InProgressTaskList"];
            
            BOOL synchronizeResult = [self->userDefault synchronize];
            
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
    
    selectTask = self.InProgressList[indexPath.row];
    
    DetailsTaskViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTaskViewController"];
    
    detailViewController.task = selectTask;
    detailViewController.delegate = self;
    
    
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)didEditTask:(TaskModel *)task {
    NSUInteger index = [self.InProgressList indexOfObject:task];
    
    if (task.taskStatus == 0) {
        [self.InProgressList addObject:task];
    }else{
        [self.InProgressList removeObjectAtIndex:index];
    }
    
    defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.InProgressList];
    [userDefault setObject:defaultTasks forKey:@"InProgressTaskList"];
    [userDefault synchronize];
    
    [self.InProgressTableView reloadData];
}




@end
