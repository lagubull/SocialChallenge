//
//  JSCPostTableViewCell.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 11/03/2016.
//
//

import Foundation
import PureLayout

/**
Constant to indicate the distance to the lower margin
*/
let kJSCBottomConstraint = 8.0 as CGFloat

/**
Constant to inidicate the margin between components and sides
*/
let kJSCMarginConstraint = 10.0 as CGFloat

/**
Constant for the dimmensions of the images to display in the cell.
*/
let kJSCPostAvatardimension = 25.0 as CGFloat

/**
 Actions from the cell.
 */
@objc protocol JSCPostTableViewCellDelegate {
    
    /**
     User pressed on the favorites button.
     
     - Parameter post post cell is showing.
     */
    func didPressFavoritesButton(post: JSCPost)
    
    /**
     User pressed on the comments button.
     
     - Parameter post post cell is showing.
     */
    func didPressCommentsButton(post: JSCPost)
}

@objc (JSCPostTableViewCell)

/**
Representation for a post.
*/
class JSCPostTableViewCell: UITableViewCell {
    
    /**
     Post shown in the cell.
     */
    private var post: JSCPost?
    
    /**
     Delegate of the protocol JSCPostTableViewCellDelegate.
     */
    var delegate:JSCPostTableViewCellDelegate?
    
    /**
     Identifies the cell type.
     */
    class func reuseIdentifier() -> String {
        
        return NSStringFromClass(self)
    }
    
    //MARK: Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.contentView.addSubview(self.baseContentView)
        
        self.baseContentView.addSubview(self.contentLabel)
        self.baseContentView.addSubview(self.avatar)
        self.baseContentView.addSubview(self.avatarLoadingView)
        self.baseContentView.addSubview(self.authorLabel)
        self.baseContentView.addSubview(self.favoritesButton)
        self.baseContentView.addSubview(self.favoritesCountLabel)
        self.baseContentView.addSubview(self.commentsButton)
        self.baseContentView.addSubview(self.commentsCountLabel)
        
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subviews
    
    /**
    View on which the content is located, we need it to be on top of the edit options.
    */
    lazy var baseContentView: UIView = {
        
        let _baseContentView = UIView.newAutoLayoutView()
        
        _baseContentView.backgroundColor = .whiteColor()
        
        _baseContentView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        _baseContentView.layer.shadowOpacity = 1.0
        _baseContentView.layer.shadowRadius = 5.0
        _baseContentView.layer.shadowColor = UIColor.blackColor().CGColor
        
        return _baseContentView
    }()
    
    /**
     Content of the post.
     */
    lazy var contentLabel: UILabel = {
        
        let _contentLabel = UILabel.newAutoLayoutView()
        
        _contentLabel.textColor = .blackColor()
        _contentLabel.font = .boldSystemFontOfSize(11.0)
        _contentLabel.numberOfLines = 0
        _contentLabel.textAlignment = .Center
        
        return _contentLabel;
    }()
    
    /**
     Image for the author of the post.
     */
    lazy var avatar: UIImageView = {
        
        let _avatar = UIImageView.newAutoLayoutView()
        
        _avatar.contentMode = .ScaleToFill
        _avatar.clipsToBounds = true
        _avatar.image = UIImage.init(named: "avatarPlaceHolderIcon")
        
        return _avatar
    }()
    
    /**
     Spinner to show activity while downloading.
     */
    lazy var avatarLoadingView: UIActivityIndicatorView = {
        
        let _avatarLoadingView = UIActivityIndicatorView.newAutoLayoutView()
        
        _avatarLoadingView.activityIndicatorViewStyle = .White
        _avatarLoadingView.hidesWhenStopped = true
        
        return _avatarLoadingView
    }()
    
    /*
    Name of the author.
    */
    lazy var authorLabel: UILabel = {
        
        let _authorLabel = UILabel.newAutoLayoutView()
        
        _authorLabel.textColor = .blackColor()
        _authorLabel.font = .systemFontOfSize(9.0)
        
        return _authorLabel
    }()
    
    /**
     Button for favorites.
     */
    lazy var favoritesButton: UIButton = {
        
        let _favoritesButton = UIButton.newAutoLayoutView()
        
        _favoritesButton.setImage(UIImage.init(named: "favoritesIcon"), forState: .Normal)
        
        _favoritesButton.addTarget(self, action: "favoritesButtonPressed", forControlEvents : .TouchUpInside)
        
        return _favoritesButton;
    }()
    
    /**
     Shows the number of times post was made favourtie.
     */
    lazy var favoritesCountLabel: UILabel = {
        
        let _favoritesCountLabel = UILabel.newAutoLayoutView()
        
        _favoritesCountLabel.textColor = .blackColor()
        _favoritesCountLabel.font = .boldSystemFontOfSize(18.0)
        
        return _favoritesCountLabel
    }()
    
    /**
     Button for comments.
     */
    lazy var commentsButton: UIButton = {
        
        let _commentsButton = UIButton.newAutoLayoutView()
        
        _commentsButton.setImage(UIImage.init(named: "commentsIcon"), forState: .Normal)
        
        _commentsButton.addTarget(self, action: "commentsButtonPressed", forControlEvents : .TouchUpInside)
        
        return _commentsButton
    }()
    
    /**
     Shows the number of comments.
     */
    lazy var commentsCountLabel: UILabel = {
        
        let _commentsCountLabel = UILabel.newAutoLayoutView()
        
        _commentsCountLabel.textColor = .blackColor()
        _commentsCountLabel.font = .boldSystemFontOfSize(18.0)
        
        return _commentsCountLabel
    }()
    
    //MARK: PrepareForReuse
    
    override func prepareForReuse(){
        
        super.prepareForReuse()
        
        self.avatar.image = nil;
    }
    
    //MARK: Constraints
    
    override func updateConstraints () {
        
        self.baseContentView.autoPinEdgesToSuperviewMargins()
        
        /*------------------*/
        
        self.contentLabel.autoPinEdgeToSuperviewEdge(.Top)
        
        self.contentLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: kJSCMarginConstraint)
        
        self.contentLabel.autoPinEdgeToSuperviewEdge (.Right, withInset: kJSCMarginConstraint)
        
        self.contentLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset:58.0)
        
        /*------------------*/
        
        self.avatar.autoPinEdgeToSuperviewEdge(.Bottom, withInset:15.0)
        
        self.avatar.autoPinEdgeToSuperviewEdge(.Left, withInset: kJSCMarginConstraint)
        
        self.avatar.autoSetDimensionsToSize(CGSizeMake(kJSCPostAvatardimension, kJSCPostAvatardimension))
        
        /*------------------*/
        
        self.avatarLoadingView.autoPinEdgeToSuperviewEdge(.Bottom, withInset:15.0)
        
        self.avatarLoadingView.autoPinEdgeToSuperviewEdge(.Left, withInset: kJSCMarginConstraint)
        
        self.avatarLoadingView.autoSetDimensionsToSize(CGSizeMake(kJSCPostAvatardimension, kJSCPostAvatardimension))
        
        /*------------------*/
        
        self.authorLabel.autoPinEdge(.Top, toEdge:.Top, ofView:self.avatar, withOffset: kJSCBottomConstraint)
        
        self.authorLabel.autoPinEdge(.Left, toEdge:.Right, ofView:self.avatar, withOffset:6.0)
        
        /*------------------*/
        
        self.commentsCountLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: kJSCMarginConstraint)
        
        self.commentsCountLabel.autoPinEdge(.Top, toEdge:.Top, ofView:self.avatar, withOffset:kJSCBottomConstraint)
        
        /*------------------*/
        
        self.commentsButton.autoPinEdge(.Right, toEdge:.Left, ofView:self.commentsCountLabel, withOffset:-5.0)
        
        self.commentsButton.autoPinEdge(.Top, toEdge:.Top, ofView:self.avatar, withOffset:kJSCBottomConstraint)
        
        /*------------------*/
        
        self.favoritesCountLabel.autoPinEdge(.Right, toEdge: .Left, ofView:self.commentsButton, withOffset: -kJSCMarginConstraint)
        
        self.favoritesCountLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar, withOffset: kJSCBottomConstraint)
        
        /*------------------*/
        
        self.favoritesButton.autoPinEdge(.Right, toEdge: .Left, ofView: self.favoritesCountLabel, withOffset: -5.0)
        
        self.favoritesButton.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar, withOffset: kJSCBottomConstraint)
        
        /*------------------*/
        
        super.updateConstraints()
    }
    
    
    //MARK: ButtonActions
    
    func favoritesButtonPressed() {
        
        self.delegate?.didPressFavoritesButton(self.post!)
    }
    
    func commentsButtonPressed() {
        
        self.delegate?.didPressCommentsButton(self.post!)
    }
    
    //MARK: UpdateWithPost
    
    /**
    Sets up the Cell with post data.
    
    - Parameter post post to be displayed.
    */
    func updateWithPost(post: JSCPost)
    {
        self.post = post;
        
        self.contentLabel.text = post.content;
        
        self.avatar.image = UIImage.init(named:"avatarPlaceHolderIcon")
        
        JSCMediaManager.retrieveMediaForPost(post, retrievalRequired: { [weak self] (postId) -> Void in
            
            if self!.post!.postId == postId {
                
                self!.avatarLoadingView.startAnimating()
            }
            }, success: { [weak self] (result, postId) -> Void in
                
                if self!.post!.postId == postId {
                    
                    self!.avatarLoadingView.stopAnimating()
                    
                    self!.avatar.image = result as? UIImage
                }
            }, failure: { [weak self] (error, postId) -> Void in
                
                if self!.post!.postId == postId {
                    
                    self!.avatarLoadingView.stopAnimating()
                }
                
                if let error: NSError = error {
                    
                    NSLog("ERROR: \(error)")
                }
            })
        
        self.authorLabel.text = post.userName();
        
        self.favoritesCountLabel.text = "\(post.likeCount!)"
        
        self.commentsCountLabel.text = "\(post.commentCount!)"
    }
}