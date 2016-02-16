//
//  JSCTableView.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import "JSCTableView.h"

static NSUInteger const kFSNPaginationOffset = 10;

@interface JSCTableView ()

@property (nonatomic, assign, getter=isPaginating) BOOL paginating;

@end

@implementation JSCTableView

#pragma mark - Dequeue

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
                           forIndexPath:(NSIndexPath *)indexPath
{
    id cell = [super dequeueReusableCellWithIdentifier:identifier
                                          forIndexPath:indexPath];
    if ([self.dataRetrievalDelegate respondsToSelector:@selector(paginate)])
    {
        if (!self.isPaginating)
        {
            NSUInteger numberOfRowsInSection = [self numberOfRowsInSection:indexPath.section];
            NSUInteger paginationTriggerIndex = numberOfRowsInSection - kFSNPaginationOffset;
            
            if (indexPath.row >= MIN(paginationTriggerIndex, numberOfRowsInSection - 1))
            {
                [self.dataRetrievalDelegate paginate];
            }
        }
    }
    
    return cell;
}


@end
