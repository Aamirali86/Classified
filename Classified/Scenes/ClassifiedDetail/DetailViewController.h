//
//  DetailViewController.h
//  Classified
//
//  Created by Amir on 08/04/2021.
//

#import <UIKit/UIKit.h>
#import "DetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cell;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *date;

- (instancetype)initWithCoder:(NSCoder *)coder withVM: (DetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
