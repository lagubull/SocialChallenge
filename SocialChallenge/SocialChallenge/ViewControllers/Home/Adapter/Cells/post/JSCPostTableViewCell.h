//
//  JSCPostTableViewCell.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import <UIKit/UIKit.h>

@class JSCPost;

@protocol JSCPostTableViewCellDelegate <NSObject>

/**
 User pressed on the favorites button.
 
 @parameter post - post cell is showing.
 */
- (void)didPressFavoritesButton:(JSCPost *)post;

/**
 User pressed on the comments button.
 
 @parameter post - post cell is showing.
 */
- (void)didPressCommentsButton:(JSCPost *)post;

@end

@interface JSCPostTableViewCell : UITableViewCell

/**
 Identifies the cell type.
 */
+ (NSString *)reuseIdentifier;

/**
 Sets up the Cell with post data.
 
 @param post -
 */
- (void)updateWithPost:(JSCPost *)post;

/**
 Delegate of the protocol JSCPostTableViewCellDelegate.
 */
@property (nonatomic, weak) id<JSCPostTableViewCellDelegate> delegate;

@end
