# Tic Tac Toe Game
This project implements a simple Tic-Tac-Toe game using Ruby on Rails with ActionCable for real-time updates. The game allows two players to play against each other and provides features like making moves, ending turns, and resetting the game.

## Table of Contents
- [Getting Started](#getting-started)
- [Game Rules](#game-rules)
- [Project Structure](#project-structure)
- [Changelog](#changelog)

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Ruby (version 3.2.2)
- Rails (version 7.0.0)

### Installation

1. **Clone the repository:**
    ```bash
      git clone git remote add origin https://github.com/dedenfarhanhub/assignment-tic-tac-toe.git
    ```

2. **Change into the project directory:**
    ```bash
      cd assignment-tic-tac-toe
    ```
3. **Install dependencies:**
    ```bash
      rbenv install
      rbenv rehash
      gem install bundler
      bundle install
    ```
4. **Set up the database:**
    ```bash
      rails db:create db:migrate
    ```
5. **Start the Rails server:**
    ```bash
      rails server
    ```
6. Open your browser and navigate to http://localhost:3000 to play the game!

## Game Rules

- The game follows standard Tic-Tac-Toe rules.
- Players take turns to make moves by clicking on empty cells on the game board.
- The game ends when a player has a winning combination, or the board is full, resulting in a draw.

## Project Structure

The project structure is organized as follows:

- **app/controllers/games_controller.rb:** Manages game-related actions, such as creating, showing, making moves, ending turns, and resetting the game.

- **app/models/game.rb:** Represents the state and logic of the Tic-Tac-Toe game. Handles game initialization, joining, making moves, and checking for winners.

- **test/controllers/games_controller_test.rb:** Contains unit tests for the `GamesController` actions.

- **test/models/game_test.rb:** Includes unit tests for the `Game` model methods.

## Changelog
### **[CHANGELOG.MD](./CHANGELOG.md)**

### Development
Feel free to contribute to the project by opening issues or submitting pull requests. Your feedback and improvements are always welcome.

### License
This project is licensed under the MIT License - see the LICENSE file for details.
