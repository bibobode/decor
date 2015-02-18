//
//  FirstViewController.m
//  PerfTest
//
//  Created by Fawaz Tahir on 1/12/15.
//  Copyright (c) 2015 Fawaz Tahir. All rights reserved.
//

#import "FirstViewController.h"
#import "D.h"

#define delay(x) seconds+= 0.9; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ x; });

static CGFloat seconds = 0.9;
static NSString * const kCellIdentifier = @"cell";

@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIView *section2;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;

@end

@implementation FirstViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.cell = [[UITableViewCell alloc] init];
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *card = self.cell.contentView;
    card.tag = 1000;
    card.layoutType = LayoutTypeDecor;
    [card.style.padding setAll:pixel(10)];
    card.style.height = autosize;
    
    UIView *section1 = [[UIView alloc] init];
    section1.tag = 6;
    section1.style.height = autosize;
    [card addSubview:section1];
    
    UIImageView *picture = [[UIImageView alloc] init];
    picture.image = [UIImage imageNamed:@"image.png"];
    CGFloat picSize = 50.0f;
    CGFloat padding = 5.0f;
    picture.style.height = pixel(picSize);
    picture.style.width = pixel(picSize);
    picture.style.margin.left = pixel(padding);
    [section1 addSubview:picture];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"Alda Lastname";
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
    label.style.margin.left = pixel(10);
    label.style.width = [percent(100) subtract:pixel(padding)];
    label.style.height = autosize;
    [section1 addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"2 mins ago";
    label2.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
    label2.style.lineBreak = 1;
    label2.style.margin.top = pixel(3);
    label2.style.margin.left = pixel(10);
    label2.style.height = autosize;
    [section1 addSubview:label2];
    
    UITextView *text = [[UITextView alloc] init];
    text.backgroundColor = [UIColor clearColor];
    text.text = @"Hey Guys,\n\nI'm trying to plan the team building outing and came up with a list of possible events with the rest of the planning committee (see attached note). Please reply with your top two favorite ideas (rank them 1 and 2) and I'll try to narrow down an event. Try to get back to me by the end of tomorrow if possible. Thanks!";
    text.editable = NO;
    text.style.lineBreak = 2;
    text.style.margin.top = pixel(5);
    text.style.height = autosize;
    text.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [section1 addSubview:text];

    section2 = [[UIView alloc] init];
    section2.tag = 9;
    section2.style.height = autosize;
    section2.style.margin.top = pixel(10);
    section2.style.lineBreak = 1;
    section2.clipsToBounds = YES;
    [card addSubview:section2];
    
    UILabel *comment1 = [self addComment:@"Fawaz Tahir" text:@"#1 - 1, #2 - 7, #3 - 4, #5 - 6" lineBreak:0];
    [self addComment:@"Mike Someone" text:@"Can we buy me candy instead....." lineBreak:2];
    [self addComment:@"John Else" text:@"Big wall of text huehuehueheuhe ehue ehueheueheuheu eheueheuue." lineBreak:2];
//
    UILabel *floater = [[UILabel alloc] init];
    floater.text = @"FEATURED";
    floater.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    floater.textAlignment = NSTextAlignmentRight;
    floater.textColor = [UIColor darkGrayColor];
    floater.style.position = absolute;
    floater.style.top = zero;
    floater.style.right = zero;
    floater.style.width = autosize;
    floater.style.height = autosize;
    [section1 addSubview:floater];
    
    
    // Animation code
    delay(picture.style.margin.left = pixel(50));
    delay(picture.style.margin.left = zero);
    delay(picture.style.width = pixel(100));
    delay(picture.style.height = pixel(100));
    delay(picture.style.width = pixel(25));
    delay(picture.style.width = pixel(50));
    delay(picture.style.height = pixel(50));
    delay();
    delay(text.text = @"Hey Guys,");
    delay();
    delay(text.text = @"Hey Guys,\n\nI'm trying to plan the team building outing and came up with a list of possible events with the rest of the planning committee (see attached note).");
    delay();
    delay(text.text = @"Hey Guys,\n\nI'm trying to plan the team building outing and came up with a list of possible events with the rest of the planning committee (see attached note). Please reply with your top two favorite ideas (rank them 1 and 2) and I'll try to narrow down an event.");
    delay();
    delay(text.text = @"Hey Guys,\n\nI'm trying to plan the team building outing and came up with a list of possible events with the rest of the planning committee (see attached note). Please reply with your top two favorite ideas (rank them 1 and 2) and I'll try to narrow down an event. Try to get back to me by the end of tomorrow if possible. Thanks!");
    delay();
    delay(comment1.text = @"Fawaz");
    delay();
    delay(comment1.text = @"Really Long Named Guy Named Fawaz");
    delay();
    delay(comment1.text = @"Fawaz Tahir");
    delay();
    delay(section2.style.height = zero);
    delay();
    delay(section2.style.height = autosize);
    delay();
    delay();
    delay(label.style.margin.top = pixel(20));
    delay();
    delay();
    delay(label.style.margin.left = pixel(30));
    delay();
    delay();
    delay(label.style.margin.top = zero);
    delay();
    delay();
    delay(label.style.margin.left = pixel(10));
    delay();
    delay([card.style.padding setAll:pixel(50)]);
    delay();
    delay([card.style.padding setAll:pixel(10)]);
}

- (UILabel *)addComment:(NSString *)name text:(NSString *)text lineBreak:(NSUInteger)lineBreak
{
    UILabel *label4 = [[UILabel alloc] init];
    label4.style.lineBreak = lineBreak;
    label4.text = name;
    label4.font = [UIFont fontWithName:@"Helvetica Bold" size:13.0f];
    label4.style.margin.left = pixel(10);
    label4.style.width = autosize;
    label4.style.height = pixel(20);
    [section2 addSubview:label4];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = text;
    label3.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
    label3.style.margin.left = pixel(10);
    label3.style.width = percent(100);
    label3.style.height = autosize;
    [section2 addSubview:label3];
    return label4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        return self.cell.contentView.frame.size.height;
    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        return self.cell;
    }
    return [[UITableViewCell alloc] init];
}

@end
