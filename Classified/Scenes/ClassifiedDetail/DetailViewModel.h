//
//  DetailViewModel.h
//  Classified
//
//  Created by Amir on 08/04/2021.
//

#import <Foundation/Foundation.h>

@class Classified;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewModel : NSObject

-(NSString *) getName;
-(NSString *) getPrice;
-(NSString *) getDate;
-(NSData *) getImageData;

- (instancetype)initWithData:(NSData *)data withItem: (Classified *)classified;

@end

NS_ASSUME_NONNULL_END
