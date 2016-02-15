//
//  JSCPostTableViewCell.h
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import <UIKit/UIKit.h>

@class JSCPost;

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

@end
