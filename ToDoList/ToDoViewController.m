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

@interface ToDoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *noData;

@end

@implementation ToDoViewController{
    NSUserDefaults *userDefault;
    NSData *defaultTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noData.hidden = YES;

    [self.toDoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"toDoCell"];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    defaultTasks = [userDefault objectForKey:@"TaskList"];
        if (defaultTasks != nil) {
            self.ToDotaskList = [NSKeyedUnarchiver unarchiveObjectWithData:defaultTasks];
            } else {
                self.ToDotaskList = [[NSMutableArray alloc] init];
            }
    
    _searchTF.delegate = self;
    _searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self textFieldDidChange:searchText];
    return YES;
}



- (void)textFieldDidChange:(NSString *)searchText {
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
    } else {
        [self.ToDotaskList removeObjectAtIndex:index];
    }
    
    NSData *defaultTasks = [NSKeyedArchiver archivedDataWithRootObject:self.ToDotaskList];
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
