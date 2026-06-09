#!/usr/bin/env python3
"""Append new card games to GamesManifest.json and games-en.json."""

from __future__ import annotations

import json
from pathlib import Path

RESOURCES = Path(__file__).resolve().parent.parent / "jokester-deck" / "Resources"

NEW_GAMES = [
    {
        "slug": "pinochle",
        "emoji": "🎺",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Pinochle",
        "rules": [
            "Partners sit across; deal 12 cards each from a 48-card double deck.",
            "Bid to name trump and win at least the promised number of points from melds and tricks.",
            "Follow suit when able; highest trump or led suit wins each trick.",
        ],
        "strategyTips": [
            "Count trump early to judge whether your bid is safe.",
            "Save high trump for tricks that protect valuable melds.",
            "Communicate strength through disciplined bidding rather than risky overcalls.",
        ],
    },
    {
        "slug": "belote",
        "emoji": "🇫🇷",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Belote",
        "rules": [
            "Four players in fixed partnerships; five cards each plus a turned trump card.",
            "Teams choose trump or pass; must follow suit and trump when required.",
            "Score points from declared combinations and captured tricks.",
        ],
        "strategyTips": [
            "Call trump only when your side holds strong trump control.",
            "Lead through opponents' known long suits when defending.",
            "Track which honors have been played before declaring combinations.",
        ],
    },
    {
        "slug": "skat",
        "emoji": "🎯",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 3,
        "difficulty": 3,
        "name": "Skat",
        "rules": [
            "One player opposes the other two; deal 10 cards to each with two in the skat.",
            "Auction sets the soloist, trump suit or grand game, and point target.",
            "Follow suit; jacks are permanent trump in suit games.",
        ],
        "strategyTips": [
            "Evaluate the skat before committing to a high contract.",
            "Discard to create void suits only when you can trump safely.",
            "Defenders coordinate by signaling with card choice within legal play.",
        ],
    },
    {
        "slug": "oh-hell",
        "emoji": "👋",
        "categoryKey": "trick_taking",
        "minPlayers": 3,
        "maxPlayers": 7,
        "difficulty": 2,
        "name": "Oh Hell",
        "rules": [
            "Hand size changes each round; players bid how many tricks they will win.",
            "Follow suit when possible; highest card of led suit wins unless trump is used.",
            "Score only when your bid exactly matches tricks taken.",
        ],
        "strategyTips": [
            "Adjust bids as hand size shrinks and trump length becomes clearer.",
            "Dump high cards early when you need to miss your bid.",
            "Watch opponents' bids to infer who must win or lose tricks.",
        ],
    },
    {
        "slug": "knock-rummy",
        "emoji": "✊",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Knock Rummy",
        "rules": [
            "Deal seven cards each; draw and discard each turn to form sets and runs.",
            "Knock when total unmatched card value is ten or fewer.",
            "Opponents reveal hands; lower deadwood scores better.",
        ],
        "strategyTips": [
            "Track discards to avoid feeding opponents useful cards.",
            "Knock early when opponents look close to gin-style hands.",
            "Break large deadwood even if it delays a perfect meld.",
        ],
    },
    {
        "slug": "contract-rummy",
        "emoji": "📜",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 3,
        "name": "Contract Rummy",
        "rules": [
            "Play a series of deals with rising meld requirements each round.",
            "Draw and discard; lay down the required contract before extending melds.",
            "First player to empty their hand after all contracts wins the round sequence.",
        ],
        "strategyTips": [
            "Plan two rounds ahead to keep flexible middle cards.",
            "Hold wild cards until the contract for that round allows them.",
            "Watch who has already laid down to judge risk on discards.",
        ],
    },
    {
        "slug": "durak",
        "emoji": "🛡️",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Durak",
        "rules": [
            "Attack with a card; defender must beat it with higher same suit or trump.",
            "Other players may add matching ranks while the defender still holds cards.",
            "Last player holding cards becomes the durak; others win.",
        ],
        "strategyTips": [
            "Save trump for critical defense, not every trick.",
            "Add low cards to attacks when the defender is low on cards.",
            "Force opponents to spend trump before your final push.",
        ],
    },
    {
        "slug": "scopa",
        "emoji": "🇮🇹",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Scopa",
        "rules": [
            "Four face-up table cards; play one card to capture matching sums or ranks.",
            "Clear the table for a scopa bonus point.",
            "Score for sets, seven of coins, most cards, and most coins.",
        ],
        "strategyTips": [
            "Leave totals that are hard for opponents to capture.",
            "Track which ranks have been played before setting up scopa.",
            "Protect the seven of coins when possible.",
        ],
    },
    {
        "slug": "cassino",
        "emoji": "🏛️",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Cassino",
        "rules": [
            "Deal four cards each plus four face-up on the table.",
            "Capture by matching rank or building combinations to a target total.",
            "Score for sweeps, aces, big cassino, little cassino, and most cards.",
        ],
        "strategyTips": [
            "Build piles you can capture on your next turn.",
            "Avoid leaving easy single-card captures for opponents.",
            "Remember which spades and aces are still unplayed.",
        ],
    },
    {
        "slug": "speed",
        "emoji": "⚡",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 1,
        "name": "Speed",
        "rules": [
            "Split the deck; each player holds five cards and flips two center piles.",
            "Play cards one rank higher or lower onto either pile as fast as possible.",
            "Refill from your stock; first to empty hand and stock wins.",
        ],
        "strategyTips": [
            "Keep eyes on both piles simultaneously.",
            "Hold versatile middle ranks that connect both piles.",
            "Flip new center cards quickly when both players stall.",
        ],
    },
    {
        "slug": "spit",
        "emoji": "💨",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 1,
        "name": "Spit",
        "rules": [
            "Each player builds five tableau piles and shares a spit pile in the center.",
            "Play ascending sequences on center piles when available without taking turns.",
            "Empty all tableau piles first, then clear the spit pile to win.",
        ],
        "strategyTips": [
            "Expose buried cards in tableau piles early.",
            "Watch opponent speed but avoid illegal simultaneous plays.",
            "Prioritize moves that unlock multiple face-down cards.",
        ],
    },
    {
        "slug": "concentration",
        "emoji": "🧠",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "Concentration",
        "rules": [
            "Spread cards face down in a grid.",
            "On your turn, flip two cards; keep pairs and play again.",
            "Most pairs when the board is cleared wins.",
        ],
        "strategyTips": [
            "Remember positions of revealed cards even when unmatched.",
            "Open new areas when you know a pair is elsewhere.",
            "Use systematic scanning rather than random guesses.",
        ],
    },
    {
        "slug": "memory",
        "emoji": "💭",
        "categoryKey": "family",
        "minPlayers": 1,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "Memory",
        "rules": [
            "Lay all cards face down in rows.",
            "Flip two at a time; matched ranks stay face up.",
            "Player with the most pairs wins.",
        ],
        "strategyTips": [
            "Group remembered cards by rank mentally.",
            "Say ranks quietly to reinforce recall if learning.",
            "Start with smaller decks when teaching children.",
        ],
    },
    {
        "slug": "fan-tan",
        "emoji": "🌬️",
        "categoryKey": "family",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 2,
        "name": "Fan Tan",
        "rules": [
            "Deal all cards; play in order by suit starting at seven.",
            "Add cards adjacent to existing suit sequences on the table.",
            "First to empty hand wins.",
        ],
        "strategyTips": [
            "Block suits opponents need with your own low or high cards.",
            "Play middle cards early when you hold many of one suit.",
            "Track which suits are still waiting for a seven.",
        ],
    },
    {
        "slug": "kemps",
        "emoji": "🤝",
        "categoryKey": "family",
        "minPlayers": 4,
        "maxPlayers": 6,
        "difficulty": 1,
        "name": "Kemps",
        "rules": [
            "Partners sit across; four cards each and frequent swaps from the deck.",
            "Signal your partner when you hold four of a kind without being caught.",
            "Call Kemps when you see your partner's signal; opponents may call false.",
        ],
        "strategyTips": [
            "Design subtle signals before the game starts.",
            "Watch opponents for accidental patterns.",
            "Discard and draw aggressively to chase four of a kind.",
        ],
    },
    {
        "slug": "nerts",
        "emoji": "🐝",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Nerts",
        "rules": [
            "Each player builds solitaire-style piles while sharing ascending center piles.",
            "Race to play aces and continue sequences without taking turns.",
            "Score when your nerts pile is empty minus penalties for remaining cards.",
        ],
        "strategyTips": [
            "Free buried cards in your personal tableau first.",
            "Play to center piles quickly when sequences open.",
            "Balance speed with avoiding illegal pile conflicts.",
        ],
    },
    {
        "slug": "pig",
        "emoji": "🐷",
        "categoryKey": "family",
        "minPlayers": 3,
        "maxPlayers": 13,
        "difficulty": 1,
        "name": "Pig",
        "rules": [
            "Pass one card left each round; aim to collect four of a kind.",
            "When you have four of a kind, quietly put your finger on your nose.",
            "Last player to notice and touch their nose gets a letter toward P-I-G.",
        ],
        "strategyTips": [
            "Pass quickly to keep rhythm high.",
            "Glance at opponents often without obvious staring.",
            "Discard ranks you no longer need early each pass.",
        ],
    },
    {
        "slug": "authors",
        "emoji": "📚",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 1,
        "name": "Authors",
        "rules": [
            "Collect complete four-card sets by asking opponents for ranks.",
            "If asked player has the rank, they must hand all matching cards.",
            "Most complete sets when the deck runs out wins.",
        ],
        "strategyTips": [
            "Ask for ranks where you hold multiple cards.",
            "Track which players denied you to infer their holdings.",
            "Remember successful requests to rebuild sets quickly.",
        ],
    },
    {
        "slug": "crazy-rummy",
        "emoji": "🎭",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Crazy Rummy",
        "rules": [
            "Each round requires a different meld pattern before you can lay down.",
            "Draw and discard; extend your melds and opponents' shown melds when legal.",
            "First to empty hand after completing the round contract wins the deal.",
        ],
        "strategyTips": [
            "Keep flexible cards until the round contract is clear.",
            "Lay down as soon as legal to start reducing hand size.",
            "Watch discard pile for clues about near-complete opponent melds.",
        ],
    },
    {
        "slug": "indian-rummy",
        "emoji": "🇮🇳",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 3,
        "name": "Indian Rummy",
        "rules": [
            "Deal 13 cards each; form at least two sequences including one pure sequence.",
            "Draw from stock or discard pile; finish with one card discarded.",
            "Declare when all cards form valid sets and sequences.",
        ],
        "strategyTips": [
            "Build a pure sequence before chasing sets.",
            "Discard high unmatched cards early.",
            "Track jokers and use them to complete second sequences.",
        ],
    },
    {
        "slug": "schnapsen",
        "emoji": "🇦🇹",
        "categoryKey": "trick_taking",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 3,
        "name": "Schnapsen",
        "rules": [
            "Use a 20-card deck; players need 66 points to win the game.",
            "Follow suit; trump beats non-trump; winner of trick leads next.",
            "Close the stock early when you believe your hand can reach the target.",
        ],
        "strategyTips": [
            "Count trump and marriage points before closing.",
            "Lead small trump to pull opponents' high trump.",
            "Track point totals every trick to know when to close.",
        ],
    },
    {
        "slug": "thousand",
        "emoji": "💯",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 3,
        "difficulty": 3,
        "name": "Thousand",
        "rules": [
            "Three players with a 24-card deck; bid to become declarer.",
            "Declarer seeks tricks and marriages to reach the bid total.",
            "Defenders cooperate to stop the declarer from making the contract.",
        ],
        "strategyTips": [
            "Bid based on marriage points plus likely trick strength.",
            "Lead trump when you need to pull control from declarer.",
            "Remember which marriages are still possible from remaining cards.",
        ],
    },
    {
        "slug": "scat",
        "emoji": "🃏",
        "categoryKey": "trick_taking",
        "minPlayers": 3,
        "maxPlayers": 3,
        "difficulty": 2,
        "name": "Scat",
        "rules": [
            "Three players; one card at a time bidding for pick of trump or pass.",
            "Defending players try to stop the picker from making three tricks.",
            "Score accumulates over multiple hands to a set target.",
        ],
        "strategyTips": [
            "Pick only with secure trump length and high cards.",
            "Defenders lead suits the picker is void in when possible.",
            "Track who passed to estimate remaining trump distribution.",
        ],
    },
    {
        "slug": "bourre",
        "emoji": "🎲",
        "categoryKey": "trick_taking",
        "minPlayers": 2,
        "maxPlayers": 7,
        "difficulty": 2,
        "name": "Bourré",
        "rules": [
            "Five cards each; players may stay in or drop after seeing trump.",
            "Must follow suit; highest trump or led suit wins tricks.",
            "Fail to take at least one trick and you bourré into the penalty pile.",
        ],
        "strategyTips": [
            "Drop weak hands early rather than forcing a bourré.",
            "Lead trump when you hold length and high honors.",
            "Count how many players stayed in before committing high cards.",
        ],
    },
    {
        "slug": "bridge-whist",
        "emoji": "🌉",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Whist (Classic)",
        "rules": [
            "Partners sit across; last card dealt sets trump for the hand.",
            "Follow suit; highest trump or led suit wins each trick.",
            "Team scoring the most tricks earns points toward game total.",
        ],
        "strategyTips": [
            "Lead your longest strong suit to establish tricks.",
            "Use trump economically rather than on every opportunity.",
            "Signal partner with thoughtful card selection within legal play.",
        ],
    },
    {
        "slug": "double-solitaire",
        "emoji": "🔄",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 1,
        "name": "Double Solitaire",
        "rules": [
            "Each player runs their own solitaire layout side by side.",
            "Share foundation piles ascending by suit from ace to king.",
            "First to move all cards to foundations wins the race.",
        ],
        "strategyTips": [
            "Prioritize moves that open face-down tableau cards.",
            "Play to shared foundations quickly when aces appear.",
            "Do not block foundations your opponent needs unless it helps your tableau.",
        ],
    },
]


def main() -> None:
    manifest_path = RESOURCES / "GamesManifest.json"
    games_en_path = RESOURCES / "games-en.json"

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    games_en = json.loads(games_en_path.read_text(encoding="utf-8"))
    existing = {entry["slug"] for entry in manifest}

    added = 0
    for game in NEW_GAMES:
        slug = game["slug"]
        if slug in existing:
            continue
        manifest.append(
            {
                "slug": slug,
                "emoji": game["emoji"],
                "categoryKey": game["categoryKey"],
                "minPlayers": game["minPlayers"],
                "maxPlayers": game["maxPlayers"],
                "difficulty": game["difficulty"],
            }
        )
        games_en[slug] = {
            "name": game["name"],
            "rules": game["rules"],
            "strategyTips": game["strategyTips"],
        }
        added += 1

    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    games_en_path.write_text(json.dumps(games_en, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Added {added} games; total {len(manifest)}")


if __name__ == "__main__":
    main()
