## 0.2.0

### Breaking changes:
- Introduced nested navigation
 
### Internal:
- Implement Exception instead of extending Error 

## 0.1.1

### Internal:
- Removed generics from page's typedef

## 0.1.0

### Testing
- Unit-tested configuration
- Unit-tested blaze matcher
- Unit-tested errors
- Unit-tested router

### Breaking Changes:
- Removed route information provider

### Internal:
- Removed useless try\catches

## 0.0.2

### Unit-tests
- Unit-tested blaze routes entity(300+ lines)

### Fixes
- Now path arguments work even if them were at the root, like **/:id**

### New
- Added new maxInnering field
- Added innering error 

## 0.0.1

### Introduced base components
- BlazeDelegate
- BlazeParser
- BlazeInformationProvider
- BlazeConfiguration
- BlazeRouter
- BlazePageBuilder
- BlazeRoutes
- BlazeMatcher
- BlazePage
- BlazeRoute

