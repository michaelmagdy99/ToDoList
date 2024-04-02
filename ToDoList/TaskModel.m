//
//  TaskModel.m
//  ToDoList
//
//  Created by Michael Magdy on 02/04/2024.
//

#import "TaskModel.h"

@implementation TaskModel

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.taskName = [decoder decodeObjectForKey:@"taskName"];
        self.taskDescription = [decoder decodeObjectForKey:@"taskDescription"];
        self.taskDate = [decoder decodeObjectForKey:@"taskDate"];
        self.taskPriority = [decoder decodeIntForKey:@"taskPriority"];
        self.taskStatus = [decoder decodeIntForKey:@"taskStatus"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.taskName forKey:@"taskName"];
    [encoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [encoder encodeObject:self.taskDate forKey:@"taskDate"];
    [encoder encodeInt:self.taskPriority forKey:@"taskPriority"];
    [encoder encodeInt:self.taskStatus forKey:@"taskStatus"];
}


@end
