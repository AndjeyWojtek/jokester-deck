# Jokester Deck — App Store Metadata (English)

App Store Connect copy for **Jokester Deck** v1.1 (`com.jokester.deck`).

---

## App Store Connect settings

| Field | Value |
|-------|-------|
| **App name** | Jokester Deck |
| **Bundle ID** | `com.jokester.deck` |
| **Version** | 1.1 |
| **Primary category** | Education |
| **Secondary category** | Reference |
| **Age rating** | 4+ (no gambling, violence, etc.) |
| **Privacy Policy URL** | Host [docs/privacy-policy.html](../docs/privacy-policy.html) (e.g. GitHub Pages) — see [AppStore/README.md](README.md) |
| **Support email** | support@jokester.deck |

---

## 1. Description

```
Jokester Deck is your pocket guide to traditional playing-card games — for family nights, travel, and learning something new with friends.

Browse a library of 100 classic card games, from easy two-player favorites to strategy and trick-taking titles. Each entry includes clear step-by-step rules and practical strategy tips so you can teach and play at the table with a real deck of cards.

WHAT YOU CAN DO

• Codex — Search and filter 100 games by player count and style (Classic, Family, Strategy, Trick-Taking)
• Demo — See a sample hand dealt on screen while you read the rules (illustration only — you play with your own cards)
• Trivia — Test your knowledge with a 10-question quiz and earn learning progress
• Collection — Track XP, levels, and mastery as you explore the catalog
• Daily Wisdom — Inspirational quotes about games, patience, and strategy
• Offline ready — Core game library and trivia packs work without an internet connection
• 10 languages — English, Ukrainian, Hebrew, Russian, Arabic, Chinese, French, German, Spanish, and Japanese

LEARN AT YOUR OWN PACE

Games unlock gradually as you level up — a gentle way to discover new titles without feeling overwhelmed. Master games by reviewing demos and trivia to build your personal collection of strategy tips.

FOR HOME AND SOCIAL PLAY

Jokester Deck is a reference and learning tool. It does not simulate full games, use real money, or involve any form of wagering. Bring a deck of cards, open the rules, and play together in person.

Perfect for parents teaching kids, groups planning game night, or anyone who wants a well-organized card-game handbook on iPhone and iPad.

Download Jokester Deck and turn your next gathering into a card-game adventure.
```

---

## 2. What's New (v1.1)

```
• Favorites — Star games for quick access in the Codex
• Category filters — Family, Strategy, and Trick-Taking chips in the library
• Demo picker — Choose which unlocked game to preview on the Demo tab
• Strategy tips — Read pro tips right in the demo, before mastering a game
• Share rules — Send a game's rules and tips to friends at the table
• Better offline — English trivia fallback and local card dealing when offline
```

---

## 3. Promotional text (170 chars max)

```
v1.1: Favorites, category filters, demo game picker, shareable rules, and stronger offline play — 100 card games in 10 languages.
```

Character count: 128/170

---

## 4. Subtitle (30 chars max)

```
Learn 100 Card Games
```

Character count: 20/30

**Alternatives:**

- `Rules, Tips & Trivia` (20)
- `Traditional Card Guide` (22)
- `Card Game Reference` (19)

---

## 5. Keywords (100 chars max)

```
card,games,rules,rummy,hearts,bridge,solitaire,family,trivia,guide,learn,strategy,offline,deck,trick
```

Character count: 97/100

**Do not include:** app name, "joker", "blackjack", "poker", "casino", "gambling", "bet"

---

## 6. Icon creation prompt

Use with an image generator or designer. Matches in-app theme (`#0A0A0C` background, `#C9A84C` gold).

```
Design a 1024×1024 iOS app icon for "Jokester Deck", an educational card-game reference app.

Subject: A single elegant playing card (portrait orientation) centered on the icon. White card face with subtle rounded corners. Gold letter "J" in all four corners (standard playing-card layout). A friendly, stylized joker character or joker symbol in the center — playful and classic, NOT scary or sinister.

Style: Premium, minimal, educational. Flat or softly dimensional illustration. Clean lines readable at small sizes. No photorealism.

Colors:
- Background: deep charcoal black (#0A0A0C) with a subtle radial gold glow (#C9A84C at ~15% opacity) from the top
- Card: white (#FFFFFF)
- Accents: warm gold (#C9A84C) and cream (#F0EAD6)
- Optional tiny red accent (#C0392B) on joker suit detail only

Constraints (IMPORTANT):
- NO casino imagery: no slot machines, roulette, dice stacks, poker chips, neon Vegas signs, or "CASINO" text
- NO money, coins, dollar signs, or betting visuals
- NO cluttered multi-card fan or gambling-table green felt
- Keep important content inside iOS icon safe zone (center ~80%, avoid text at edges)
- No small unreadable text; no "App Store" badge
- Must feel like a family-friendly learning/reference app, not a gambling product

Output: Square 1024×1024 PNG, suitable for App Store Connect App Icon slot.
```

Generated asset: [`jokester-deck/Assets.xcassets/AppIcon.appiconset/AppIcon.png`](../jokester-deck/Assets.xcassets/AppIcon.appiconset/AppIcon.png)

---

## 7. Notes for App Review

Paste into App Store Connect → App Review Information.

```
Thank you for reviewing Jokester Deck.

APP PURPOSE
Jokester Deck is an educational reference app for traditional playing-card games. Users browse rules and strategy tips, view an illustrative card-deal demo, and take optional trivia quizzes. The app is intended for learning and home/social play with a physical deck of cards — NOT for gambling or wagering.

NOT A GAMBLING OR CASINO APP
• No real-money gambling, simulated betting, or wagering of any kind
• No in-app purchases, subscriptions, loot boxes, or virtual currency
• No playable casino-style game loops (no blackjack hands, poker betting rounds, slot mechanics, etc.)
• No accounts, login, or age-gated gambling features
• XP, levels, scores, and "mastery" are learning-progress labels only — not money or prizes

WHAT THE DEMO TAB DOES
The Demo tab draws 5 sample cards from a public card-image API (deckofcardsapi.com) to help users visualize a starting hand while reading written rules. It does NOT run game logic, accept bets, or determine winners. Users are expected to play real games offline with physical cards.

CONTENT NOTE
The game catalog includes well-known traditional titles (e.g., Hearts, Rummy, Bridge, and educational entries whose names may appear in home-game contexts). All content is instructional text about social/family card games — not casino operations.

NETWORK USAGE
• deckofcardsapi.com — optional card images for Demo tab
• opentdb.com — optional English trivia questions (category: Entertainment / Board Games); bundled English pack used as fallback
Bundled JSON provides offline game library, offline trivia (all languages), and daily quotes. Demo tab falls back to locally shuffled cards when the card API is unavailable. Core functionality works offline.

TESTING INSTRUCTIONS
No demo account required. Launch the app and explore:
1. Codex tab — browse/search the game library
2. Demo tab — tap to deal sample cards and scroll rules
3. Trivia tab — complete a 10-question quiz
4. Collection tab — view XP and mastery progress
5. Settings (globe icon on Home) — switch language

CONTACT
support@jokester.deck
```

---

## Marketing checklist — words to avoid

When updating store copy, screenshots, or social posts, avoid terms that trigger gambling review on a personal developer account:

- casino, gambling, bet, betting, wager, jackpot
- poker room, slots, roulette, chips (as currency)
- real money, cash prizes, win money
- Vegas, high stakes, ante (in wagering context)

**Preferred framing:** reference, learn, rules, family, home play, social, traditional, educational, offline, strategy tips.
