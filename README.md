# Marvel Comics App 🦸🏼🧾

This Rails project uses the Marvel API to display character data and other related information. The frontend is styled with Tailwind CSS, and the app is primarily tested using RSpec.

The app allows you to search for your favorite Marvel character (like Hulk, for example) and then get a random story that they appear in. Once you search, the app shows the story’s description, lists the names and pictures of the characters featured in the story. At the bottom of every page, you can also find the required Marvel attribution text. `(Data provided by Marvel. © 2024 MARVEL)`

In short, this was a great way to enhance my Ruby on Rails skills and also get to know more stories and characters in the Marvel universe!

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)

## Prerequisites

Ensure you have the following installed before setting up the project:

- Ruby 3.3.5
- Rails 8.0.0
- Redis

## Setup

To set up the project, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/calvitoria/marvel_comics
    cd marvel_comics
    ```

2. You can use the `make` command to automate setup, configuration, and running the app:
    ```bash
    make server

    ```

   Alternatively, you can manually set up and configure the project with the following steps:

    ```bash
    # Install required gems
    bundle install

    # Install JavaScript dependencies
    yarn install

    # Run redis
    redis-server

    # Precompile assets
    bin/rails assets:precompile
    ```

## Configuration

To configure the project, you will need to set up the necessary environment variables:

1. Create and populate the `.env` file with your Marvel API credentials and other required settings.
2. You can use the `make` command to automate this step:
    ```bash
    make config

    ```
   Or manually configure credentials with the following command:
    ```bash
    bin/credentials_config

    ```

## Running the Application

To start the application locally, run:

```bash
rails server

```
## Running Tests

To run the tests using RSpec:

```bash
rspec

```

I am open to any feedback and collaboration! Feel free to reach out if you'd like to contribute or share suggestions.
