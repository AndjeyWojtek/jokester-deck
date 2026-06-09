# Jokester Deck

An educational iOS reference app for traditional playing-card games — built for family nights, travel, and learning with friends using a real deck of cards.

**Not a gambling app.** Jokester Deck teaches rules and strategy; you play in person with physical cards.

## Features

- **Codex** — Browse and search 100 classic games with filters (player count, category, favorites)
- **Demo** — Sample 5-card deal while reading rules; pick any unlocked game, share rules, and read strategy tips
- **Trivia** — 10-question quizzes with XP rewards
- **Collection** — Track levels, mastery stars, and unlocked strategy tips
- **Daily Wisdom** — Inspirational quotes about games and patience
- **10 languages** — English, Ukrainian, Hebrew, Russian, Arabic, Chinese, French, German, Spanish, Japanese
- **Offline-friendly** — Game library, trivia packs, and local card dealing work without a network

## Requirements

- Xcode 16+ (Swift 6, iOS 18+ deployment target)
- iPhone or iPad simulator / device

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/jokester-deck.git
   cd jokester-deck
   ```

2. Open the project in Xcode:

   ```bash
   open jokester-deck.xcodeproj
   ```

3. Select the **jokester-deck** scheme and run on a simulator or device.

Swift Package Manager resolves dependencies automatically (GrowthBook iOS SDK).

## Project Structure

```
jokester-deck/          # Main app target (SwiftUI + SwiftData)
jokester-deckTests/     # Unit tests
jokester-deckUITests/   # UI tests
Scripts/                # Python tools for catalog & localization
AppStore/               # App Store metadata and release notes
docs/                   # Host-ready privacy policy (GitHub Pages)
```

## Content Pipeline

Game rules and UI strings live in bundled JSON under `jokester-deck/Resources/`. Python scripts in `Scripts/` help expand the catalog and generate translations:

```bash
python3 Scripts/generate_localizations.py
```

## App Store

See [AppStore/README.md](AppStore/README.md) for submission checklist, metadata, and reviewer notes.

Privacy policy for hosting: [docs/privacy-policy.html](docs/privacy-policy.html)

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI |
| Persistence | SwiftData |
| Networking | URLSession (optional card images & English trivia API) |
| Feature flags | GrowthBook |
| Tests | Swift Testing |

## License

All rights reserved. Source is published for portfolio and reference; contact the author before redistribution.
