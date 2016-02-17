//
//  JSCTableView.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/08/2015.
//
//

#import "JSCTableView.h"

/**
 index from which pagination will be triggered, it should be at least half  of the expected load.
 */
static NSUInteger const kJSCPaginationOffset = 5;

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
            NSUInteger paginationTriggerIndex = numberOfRowsInSection - kJSCPaginationOffset;
            
            if (indexPath.row >= MIN(paginationTriggerIndex, numberOfRowsInSection - 1))
            {
                [self.dataRetrievalDelegate paginate];
            }
        }
    }
    
    return cell;
}


#pragma mark - Pagination

- (void)willPaginate
{
    self.paginating = YES;
}

- (void)didPaginate
{
    self.paginating = NO;
}


//if ([self.dataRetrievalDelegate respondsToSelector:@selector(paginate)])
//{
//    if (!self.isPaginating)
//    {
//        BOOL triggerPagination = NO;
//        
//        switch (self.paginationDirection)
//        {
//            case FSNDataRetrievalPaginationDirectionTop:
//            {
//                triggerPagination = (indexPath.row <= kFSNPaginationOffset);
//                
//                break;
//            }
//            case FSNDataRetrievalPaginationDirectionBottom:
//            {
//                NSUInteger numberOfRowsInSection = [self numberOfRowsInSection:indexPath.section];
//                NSUInteger paginationTriggerIndex = numberOfRowsInSection - kFSNPaginationOffset;
//                
//                triggerPagination = (indexPath.row >= MIN(paginationTriggerIndex, numberOfRowsInSection - 1));
//                
//                break;
//            }
//        }
//        
//        if(triggerPagination)
//        {
//            [self.dataRetrievalDelegate paginate];
//        }
//    }
//}


@end


