[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=56d0809b8acfa80100259480&branch=dev&build=latest)](https://dashboard.buddybuild.com/apps/56d0809b8acfa80100259480/build/latest)
[![Build Status](https://travis-ci.org/lagubull/SocialChallenge.svg)](https://travis-ci.org/lagubull/SocialChallenge)


Test Project to show a feed with content that paginates.

This Project demonstrate the usage of Coredata for storing content and reflects the 
importance of using adapters for tableviews simplifying the view controllers. Illustrates
how it is a good practice to parse the responses of API calls in the background, in this
test project we will be using NSOperations and NSOperationQueues.

For the purpose of the exercise we are using a link to an old coding challenge, which is 
still working, but some of the images are not, which is great for us to show why you 
should always protect the user against server errors.

It works as an example for the Pod SimpleTableView. We use it here for connecting coreData
via NSFetchedResultsController to display  a feed of posts.

This project also shows the usage of the pod EasyDownloadSession. This pod allows us to
download the images of the user in the background and therefore prevents lagging when 
scrolling down the tableview.

A special mention to the pod EasyALertView which we are using here to show alerts for the 
unimplemented button actions.

