# tara_driver_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Clean Achectiture
### Cores
1. This directory contains code that is used across multiple features, such as error handling, common use cases, and utility functions.
    1.  `error` : Contains error handling classes.
    2.  `usecase` : Contains base classes for use cases.
    3. `utils` : Contains utility classes and functions.
### Features
1. This directory contains subdirectories for each feature of the app. Each feature follows the same structure:
    #### data 
    + `data` is handles data management, including data sources, models, and repositories.
        1.  `data source` : Contains classes for fetching data from remote or local sources.
        2. `model`: Contains data models
        3. `repositories`: Contains implementations of repository interfaces.
    #### domain 
    + `domain` is Contains the business logic of the feature.
        1.  `entities` : Contains the core entities of the feature.
        2. `repositories`: Contains repository interfaces.
        3. `usecases`: Contains the use cases for the feature.
    #### presentation
    1. `bloc`: Contains BLoC (Business Logic Component) classes for state management.
    2. `pages` : Contains the main pages/screens.
    3. `widgets` : Contains reusable widgets.
    #### injection_container.dart: 
    + Handles dependency injection, typically using a package like get_it.
    + Why we need to use get_it package?
        1. `get_it` is the dependency for update UI with BuildContext.
        2. it have abilities on change UI without BuildContext for access to Widget