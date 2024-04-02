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

@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarContacts;
@property (strong, nonatomic) NSMutableArray *filteredTasks;

@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.toDoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"toDoCell"];
    
    self.ToDotaskList = [[NSMutableArray alloc] init];
    
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
    TaskModel *taskModel = [TaskModel new];
    taskModel = self.ToDotaskList[indexPath.row];
    
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
 
        [self.ToDotaskList removeObjectAtIndex:indexPath.row];
         
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
