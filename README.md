# FavGiphy
Sample implementation of Giphy API

- Tab bar application with two tabs
1. For fetching and showing trending gifs
2. For showing favorite gifs from file storage

- Both view controllers using their own view models for business logic
- Giphy APIs are used (Giphy SDK not used)
- API calls are using URLSession
- Not used any thirdparty libraries to save files to directory

First tab:
- Using tableview to load trending gifs from Giphy Trending API
- Handled pagination in view model - fetching 15 records at a time
- gif files are loaded in to table view cell using "SwiftGifOrigin" library
- For smooth loading of files, we can avoid loading gif and show the image alone using the commented code in the Utility class
- Loaded gif files are locally cached using an image cache
- Search bar is added to the screen for searching the gifs using Giphy Search API
- Each tableview cell contains a button to favorite or un-favorite that gif
- Favorite gifs are stored in document directly with gif id as name

Second tab:
- Collection view is used to display the favorite gifs
- Segment controller used to switch between grid and list view
- Fetching all gif files from document directory to display items
- Can un-favorite the items using a button - that file will be removed from document directory
- Handled data sync between both tabs


ToDo:
- Need to try few optimisations for smooth loading of gifs
- UI can be improved
- Can use core data for proper storing of the favorite gifs
