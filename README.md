# BeanBox

Coffee shop mobile app built with Flutter.

## Problem and user
Helps coffee lovers quickly browse drinks, see details and save favorites.

## Features (Milestone 1)
- Home screen with a list of products (Card, Row, Column)
- Detail screen with Stack banner, tags and bottom bar
- Favorite button (StatefulWidget + setState)

## Project structure
- lib/models - data classes
- lib/screens - app screens
- lib/widgets - reusable widgets

## Run
flutter pub get
flutter run -d chrome

## Lab 7: Navigation
- BottomNavigationBar with 3 tabs: Feed, Favorites, Profile
- Navigator.push with the Product object passed to DetailScreen
- Navigator.pop (AppBar arrow and in-body "Back to menu" button)
- Shared favorites list managed in RootScreen with setState