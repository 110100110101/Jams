# Jams

An application designed to search & get info about tracks (movies) from iTunes Search API.

## Features supported
- Search
- Marking tracks as favorites
  - Persisted between launches; Backed by **Core Data**
- Detailed View of tracks
- Favorites List view
- UI State Restoration
  - Get back to your previous state even your app has been removed in memory
  
## Architecture

It's on MVVM to separate concerns from business rules and UI related only stuff.
Instances of DataSource was injected on ViewModels to provide data.. to the VM and to be rendered on corresponding views.
[Moya](https://github.com/Moya/Moya) was used for the network layer to ease prototyping and to support plans for much easier scaling (plugins, or more new endpoints).
[RxSwift](https://github.com/ReactiveX/RxSwift) was used instead of Apple's own `combine` API due to familiarity with APIs.

## Build

1. Clone
2. %CD to cloned project and run `pod install`
3. Build it or run it to your preferred device/simulator

I think, this codebase can still support iOS 13 devices with little to no configuration on your end.

### Dependencies

- Moya (Network)
- RxSwift (Bindings)
- DZNEmptyDataSet (Support empty data sets easily)
- KingFisher (Load image URLs to `UIImageView`
- Avatar  (Placeholder)
