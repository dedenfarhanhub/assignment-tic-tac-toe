# Changelog

All notable changes to this project will be documented in this file.
This project adheres to Semantic Versioning.

## [Unreleased]

## [0.0.0] - 2024-02-02
### Game Refactoring with ActionCable
#### Added

- Implemented the `GamesController` to manage tic-tac-toe games.
- Introduced the `Game` model representing the state of tic-tac-toe games.
- Implemented game initialization, joining, making moves, ending turns, and resetting.
- Game logic enhancements for checking winners, draws, and game completion.
- Unit tests added for `GamesController` actions and game model methods.

### UI Enhancement & Logic Fixes
#### Added

- Ability to create a new game.
- Capability to view the game board.
- Option to make moves during the game.
- Feature to end a turn and check for winners.
- Functionality to reset the game.

#### Changed

- Enhanced the `find_or_create_game` method in the `GamesController` for creating or joining a game.
- Improved the game model to handle joining games and checking for winners.

#### Fixed

- Addressed issues related to game state not updating correctly.
- Resolved problems with handling moves and turns.

### Project Initialization

#### Added

- Initial implementation of the `GamesController`.
- Initial implementation of the `Game` model.
- Basic game functionalities added.
