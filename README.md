# MJ
<<<<<<< Updated upstream
=======

Mahjong game implementation in Godot 4.4.

## GitHub Actions & itch.io Setup

This project uses GitHub Actions to automatically build and deploy to itch.io when pushing to the main branch or creating a new tag.

### Setting up the itch.io Deployment

To make the GitHub Actions workflow work with your itch.io account, you need to set up the following in your GitHub repository:

1. Go to your GitHub repository
2. Click on "Settings" > "Secrets and variables" > "Actions"
3. Add the following secret:
   - `BUTLER_API_KEY`: Your itch.io API key (get it from https://itch.io/user/settings/api-keys)

4. Under the "Variables" tab, add:
   - `ITCH_USERNAME`: Your itch.io username
   - `ITCH_GAME_NAME`: The URL name of your game on itch.io

For example, if your game URL is `https://username.itch.io/my-game`, then:
- `ITCH_USERNAME` would be "username"
- `ITCH_GAME_NAME` would be "my-game"

The workflow will:
- Build for Web, Windows, macOS, and Linux
- Upload each build as an artifact to GitHub Actions
- Publish each build to the appropriate channel on itch.io

### Manual Deployment

If you prefer to manually deploy your game:

1. Install Butler: https://itch.io/docs/butler/
2. Login to Butler: `butler login`
3. Build your game
4. Push to itch.io: `butler push build/web username/game-name:html5`

## Development

### Requirements

- Godot 4.4.2 or newer

### Getting Started

1. Clone the repository
2. Open the project in Godot
3. Press F5 to run the game
>>>>>>> Stashed changes
