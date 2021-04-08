//
//  DetailViewController.m
//  Classified
//
//  Created by Amir on 08/04/2021.
//

#import "DetailViewController.h"
#import "DetailViewModel.h"

@interface DetailViewController ()

@property DetailViewModel* viewModel;

@end

@implementation DetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder withVM: (DetailViewModel *)viewModel {
    self.viewModel = viewModel;
    return [super initWithCoder:coder];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void) setupView {
    self.name.text = [self.viewModel getName];
    self.price.text = [self.viewModel getPrice];
    self.date.text = [self.viewModel getDate];
    self.adImage.image = [UIImage imageWithData:[self.viewModel getImageData]];
}

@end
