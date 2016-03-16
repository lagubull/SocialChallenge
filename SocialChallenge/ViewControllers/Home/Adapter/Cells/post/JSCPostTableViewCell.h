//
//  JSCPostTableViewCell.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import <UIKit/UIKit.h>

@class JSCPost;

/**
 Actions from the cell.
 */
@protocol JSCPostTableViewCellDelegate <NSObject>

/**
 User pressed on the favorites button.
 
 @param post - post cell is showing.
 */
- (void)didPressFavoritesButton:(JSCPost *)post;

/**
 User pressed on the comments button.
 
 @param post - post cell is showing.
 */
- (void)didPressCommentsButton:(JSCPost *)post;

@end

/**
 Representation for a post.
 */
@interface JSCPostTableViewCell : UITableViewCell

/**
 Identifies the cell type.
 */
+ (NSString *)reuseIdentifier;

/**
 Sets up the Cell with post data.
 
 @param post - post to be displayed.
 */
- (void)updateWithPost:(JSCPost *)post;

/**
 Delegate of the protocol JSCPostTableViewCellDelegate.
 */
@property (nonatomic, weak) id<JSCPostTableViewCellDelegate> delegate;

@end
