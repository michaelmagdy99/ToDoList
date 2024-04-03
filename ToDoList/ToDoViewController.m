//
//  ToDoViewController.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import "ToDoViewController.h"
#import "TaskModel.h"
#import "DetailsTaskViewController.h"
#import "AddTaskViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface ToDoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *noData;

@property (nonatomic, strong) UILabel *emptyListLabel;


@end

@implementation ToDoViewController{
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noData.hidden = YES;
    
    [self.toDoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"toDoCell"];
    
    
    
    self.emptyListLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        self.emptyListLabel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        self.emptyListLabel.textAlignment = NSTextAlignmentCenter;
        self.emptyListLabel.text = @"No tasks to display";
        self.emptyListLabel.hidden = YES;
    
    [self.view addSubview:self.emptyListLabel];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self textFieldDidChange:searchText];
    return YES;
}



- (void)textFieldDidChange:(NSString *)searchText {
    self.noData.hidden = YES;

    if (searchText.length == 0) {
        self.ToDotaskList = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:@"TaskList"]]];
    } else {
        NSMutableArray *filteredTasks = [NSMutableArray array];
        for (TaskModel *task in [self.ToDotaskList copy]) {
            if ([task.taskName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [filteredTasks addObject:task];
            }
        }
        
        if (filteredTasks.count == 0) {
            self.noData.hidden = NO;
        } else {
            self.noData.hidden = YES;
        }
        
        self.ToDotaskList = filteredTasks;
    }
    
    [self.toDoTableView reloadData];
}





- (void)didEditTask:(TaskModel *)task {
    NSUInteger index = [self.ToDotaskList indexOfObject:task];
    
    if (task.taskStatus == -1) {
        [self.ToDotaskList replaceObjectAtIndex:index withObject:task];
    }else{
        [self.ToDotaskList removeObjectAtIndex:index];
    }
    
    defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.ToDotaskList];
    [userDefault setObject:defaultTasks forKey:@"TaskList"];
    [userDefault synchronize];
    [self.toDoTableView reloadData];
}



- (IBAction)addTask:(id)sender {
   
    AddTaskViewController *addTaskV = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    
    addTaskV.toDoViewController = self;
        
    [self.navigationController pushViewController:addTaskV animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.ToDotaskList = [[NSMutableArray alloc] init];

    userDefault = [NSUserDefaults standardUserDefaults];
    defaultTasks = [userDefault objectForKey:@"TaskList"];
        self.ToDotaskList = [NSKeyedUnarchiver unarchiveObjectWithData:defaultTasks];
            
    
    _searchTF.delegate = self;
    _searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    printf("%lu", (unsigned long)self.ToDotaskList.count);
    
    self.emptyListLabel.hidden = (self.ToDotaskList.count > 0);

    
    [self.toDoTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ToDotaskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    TaskModel *taskModel = self.ToDotaskList[indexPath.row];
    
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
            
            [self.ToDotaskList removeObjectAtIndex:indexPath.row];
            
            defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.ToDotaskList];
            [userDefault setObject:defaultTasks forKey:@"TaskList"];
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
    
    selectTask = self.ToDotaskList[indexPath.row];
    
    DetailsTaskViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTaskViewController"];
    
    detailViewController.task = selectTask;
    detailViewController.indexxx = indexPath.row;
    
    detailViewController.delegate = self;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (IBAction)filterPriority:(UISegmentedControl *)sender {
    
    NSInteger selectedPriority = sender.selectedSegmentIndex;
        
        self.ToDotaskList = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:@"TaskList"]]];
        
        NSMutableArray *filteredTasks = [NSMutableArray array];
        for (TaskModel *task in self.ToDotaskList) {
            if (task.taskPriority == selectedPriority) {
                [filteredTasks addObject:task];
            }
        }
        
        self.ToDotaskList = filteredTasks;
        
        [self.toDoTableView reloadData];
}


@end
