//
//  DetailViewModel.m
//  Classified
//
//  Created by Amir on 08/04/2021.
//

#import "DetailViewModel.h"
#import "Classified-Swift.h"

@interface DetailViewModel()

@property (nonatomic) Classified *classified;
@property (nonatomic) NSData *data;
@property (nonatomic) NSDateFormatter *inputFormatter;
@property (nonatomic) NSDateFormatter *outputFormatter;

@end

@implementation DetailViewModel

- (instancetype)initWithData:(NSData *)data withItem: (Classified *)classified {
    self.inputFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss.SSSSSS";
    self.outputFormatter.dateFormat = @"yyyy-MM-dd";
    self.data = data;
    self.classified = classified;
    
    return [super init];
}

-(NSString *) getName {
    return self.classified.name;
}

-(NSString *) getPrice {
    return self.classified.price;
}

-(NSString *) getDate {
    NSDate *date = [self.inputFormatter dateFromString:_classified.created_at];
    return [self.outputFormatter stringFromDate:date];
}

-(NSData *) getImageData {
    return self.data;
}

@end
