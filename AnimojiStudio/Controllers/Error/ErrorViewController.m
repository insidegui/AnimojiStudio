//
//  ViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ErrorViewController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self build];
    [self update];
}

- (void)build
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
    [self.view addGestureRecognizer:tap];
    
    self.messageLabel = [UILabel new];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.messageLabel];
    
    [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:22].active = YES;
    [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-22].active = YES;
    [self.messageLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)setMessage:(NSString *)message
{
    _message = [message copy];
    
    [self update];
}

- (void)update
{
    self.messageLabel.text = self.message;
}

- (IBAction)userTapped:(id)sender
{
    [[UIApplication sharedApplication] sendAction:NSSelectorFromString(@"suspend") to:[UIApplication sharedApplication] from:self forEvent:nil];
}

@end
