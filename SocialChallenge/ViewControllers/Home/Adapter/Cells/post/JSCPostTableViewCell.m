//
//  JSCPostTableViewCell.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import "JSCPostTableViewCell.h"

#import "JSCPost.h"
#import "JSCMediaManager.h"

/**
 Constant to indicate the distance to the lower margin
 */
static const CGFloat JSCBottomConstraint = 8.0f;

/**
 Constant to inidicate the margin between components and sides
 */
static const CGFloat JSCMarginConstraint = 10.0f;

@interface JSCPostTableViewCell ()

/**
 Post shown in the cell.
*/
@property (nonatomic, strong) JSCPost *post;

/**
 View on which the content is located, we need it to be on top of the edit options.
 */
@property (nonatomic, strong) UIView *baseContentView;

/**
 Content of the post.
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 Image for the author of the post.
 */
@property (nonatomic, strong) UIImageView *avatar;

/*
 Name of the author.
 */
@property (nonatomic, strong) UILabel *authorLabel;

/**
 Button for favorites.
 */
@property (nonatomic, strong) UIButton *favoritesButton;

/**
 Shows the number of times post was made favourtie.
 */
@property (nonatomic, strong) UILabel *favoritesCountLabel;

/**
 Button for comments.
 */
@property (nonatomic, strong) UIButton *commentsButton;

/**
 Shows the number of comments.
 */
@property (nonatomic, strong) UILabel *commentsCountLabel;

@end

@implementation JSCPostTableViewCell

#pragma mark - Identifier

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:self.baseContentView];
        
        [self.baseContentView addSubview:self.contentLabel];
        [self.baseContentView addSubview:self.avatar];
        [self.baseContentView addSubview:self.authorLabel];
        [self.baseContentView addSubview:self.favoritesButton];
        [self.baseContentView addSubview:self.favoritesCountLabel];
        [self.baseContentView addSubview:self.commentsButton];
        [self.baseContentView addSubview:self.commentsCountLabel];
        
        [self updateConstraints];
    }
    
    return self;
}

#pragma mark - Subviews

- (UIView *)baseContentView
{
    if (!_baseContentView)
    {
        _baseContentView = [UIView newAutoLayoutView];
        
        _baseContentView.backgroundColor = [UIColor whiteColor];
        
        _baseContentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        _baseContentView.layer.shadowOpacity = 1.0f;
        _baseContentView.layer.shadowRadius = 5.0f;
        _baseContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    
    return _baseContentView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel newAutoLayoutView];
        
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _contentLabel;
    
}

- (UIImageView *)avatar
{
    if (!_avatar)
    {
        _avatar = [UIImageView newAutoLayoutView];
        
        _avatar.contentMode = UIViewContentModeScaleToFill;
        _avatar.clipsToBounds = YES;
    }
    
    return _avatar;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel)
    {
        _authorLabel = [UILabel newAutoLayoutView];
        
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.textColor = [UIColor blackColor];
        _authorLabel.font = [UIFont systemFontOfSize:9.0f];
    }
    
    return _authorLabel;
}

- (UIButton *)favoritesButton
{
    if (!_favoritesButton)
    {
        _favoritesButton = [UIButton newAutoLayoutView];
        
        [_favoritesButton setImage:[UIImage imageNamed:@"favoritesIcon"]
                           forState:UIControlStateNormal];
        
        [_favoritesButton addTarget:self
                              action:@selector(favoritesButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _favoritesButton;
}

- (UILabel *)favoritesCountLabel
{
    if (!_favoritesCountLabel)
    {
        _favoritesCountLabel = [UILabel newAutoLayoutView];
        
        _favoritesCountLabel.backgroundColor = [UIColor clearColor];
        _favoritesCountLabel.textColor = [UIColor blackColor];
        _favoritesCountLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    
    return _favoritesCountLabel;
}

- (UIButton *)commentsButton
{
    if (!_commentsButton)
    {
        _commentsButton = [UIButton newAutoLayoutView];
        
        [_commentsButton setImage:[UIImage imageNamed:@"commentsIcon"]
                           forState:UIControlStateNormal];
        
        [_commentsButton addTarget:self
                              action:@selector(commentsButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentsButton;
}

- (UILabel *)commentsCountLabel
{
    if (!_commentsCountLabel)
    {
        _commentsCountLabel = [UILabel newAutoLayoutView];
        
        _commentsCountLabel.backgroundColor = [UIColor clearColor];
        _commentsCountLabel.textColor = [UIColor blackColor];
        _commentsCountLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    
    return _commentsCountLabel;
}

#pragma mark - PrepareForReuse

- (void)prepareForReuse
{
    self.avatar.image = nil;
}

#pragma mark - Layout

- (void)layoutByApplyingConstraints
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [self.baseContentView autoPinEdgesToSuperviewMargins];
    
    /*------------------*/
    
    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                        withInset:JSCMarginConstraint];
    
    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                        withInset:JSCMarginConstraint];
    
    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                        withInset:58.0f];
    
    /*------------------*/
    
    [self.avatar autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                  withInset:15.0f];

    [self.avatar autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                  withInset:JSCMarginConstraint];
    
    [self.avatar autoSetDimensionsToSize:CGSizeMake(25.0f,
                                                    25.0f)];
    
    /*------------------*/
    
    [self.authorLabel autoPinEdge:ALEdgeTop
                      toEdge:ALEdgeTop
                      ofView:self.avatar
                  withOffset:JSCBottomConstraint];
    
    [self.authorLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeRight
                           ofView:self.avatar
                       withOffset:6.0f];
    
    /*------------------*/

    [self.commentsCountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                withInset:JSCMarginConstraint];
    
    [self.commentsCountLabel autoPinEdge:ALEdgeTop
                           toEdge:ALEdgeTop
                           ofView:self.avatar
                       withOffset:JSCBottomConstraint];
    
    /*------------------*/

    [self.commentsButton autoPinEdge:ALEdgeRight
                              toEdge:ALEdgeLeft
                              ofView:self.commentsCountLabel
                          withOffset:-5.0f];
    
    [self.commentsButton autoPinEdge:ALEdgeTop
                                    toEdge:ALEdgeTop
                                    ofView:self.avatar
                                withOffset:JSCBottomConstraint];
    
    /*------------------*/
    
    [self.favoritesCountLabel autoPinEdge:ALEdgeRight
                                 toEdge:ALEdgeLeft
                                 ofView:self.commentsButton
                             withOffset:-JSCMarginConstraint];
    
    [self.favoritesCountLabel autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeTop
                                ofView:self.avatar
                            withOffset:JSCBottomConstraint];
    
    /*------------------*/
    
    [self.favoritesButton autoPinEdge:ALEdgeRight
                                toEdge:ALEdgeLeft
                                ofView:self.favoritesCountLabel
                            withOffset:-5.0f];
    
    [self.favoritesButton autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeTop
                                ofView:self.avatar
                            withOffset:JSCBottomConstraint];

    /*------------------*/
    
    [super updateConstraints];
}


#pragma mark - ButtonActions

- (void)favoritesButtonPressed
{
    [self.delegate didPressFavoritesButton:self.post];
}

- (void)commentsButtonPressed
{
    [self.delegate didPressCommentsButton:self.post];
}

#pragma mark - UpdateWithPost

- (void)updateWithPost:(JSCPost *)post
{
    self.post = post;
    
    self.contentLabel.text = post.content;
    
    __weak typeof (self) weakSelf = self;
    
    [JSCMediaManager retrieveMediaForPost:post
                        retrievalRequired:nil
                                  Success:^(id result)
     {
         weakSelf.avatar.image = result;
     }
                                  failure:^(NSError *error)
     {
         NSLog(@"ERROR: %@",error);
     }];
    
    self.authorLabel.text = post.userName;
    
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%@", post.likeCount];
    
    self.commentsCountLabel.text = [NSString stringWithFormat:@"%@", post.commentCount];
}

@end
