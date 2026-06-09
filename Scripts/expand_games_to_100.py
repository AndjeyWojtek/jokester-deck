#!/usr/bin/env python3
"""Append 50 new card games to reach 100 total in GamesManifest.json and games-en.json."""

from __future__ import annotations

import json
from pathlib import Path

RESOURCES = Path(__file__).resolve().parent.parent / "jokester-deck" / "Resources"
TARGET_TOTAL = 100

NEW_GAMES = [
    # --- Classic (10) ---
    {
        "slug": "freecell",
        "emoji": "🆓",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 1,
        "name": "FreeCell",
        "rules": [
            "Deal all cards face-up into eight columns with four open storage cells.",
            "Move one card at a time; build columns downward alternating red and black.",
            "Win by moving every card to four foundation piles ascending by suit.",
        ],
        "strategyTips": [
            "Keep free cells open early to maximize move options.",
            "Clear buried aces and low cards before building tall stacks.",
            "Plan several moves ahead before emptying a column.",
        ],
    },
    {
        "slug": "spider-solitaire",
        "emoji": "🕷️",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 2,
        "name": "Spider Solitaire",
        "rules": [
            "Deal ten columns; build sequences downward in the same suit.",
            "Move fully packed same-suit runs as a unit when allowed.",
            "Remove completed king-to-ace runs; clear all columns to win.",
        ],
        "strategyTips": [
            "Expose face-down cards before creating new empty columns.",
            "Prioritize same-suit builds over mixed-suit stacks.",
            "Avoid deals from stock until no productive moves remain.",
        ],
    },
    {
        "slug": "pyramid-solitaire",
        "emoji": "🔺",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 1,
        "name": "Pyramid Solitaire",
        "rules": [
            "Arrange 28 cards in a pyramid; pair exposed cards totaling thirteen.",
            "Kings remove alone; draw from stock when no pairs remain.",
            "Clear the entire pyramid to win the deal.",
        ],
        "strategyTips": [
            "Remove cards that block many others first.",
            "Save kings until they unlock deeper pyramid layers.",
            "Track which totals still need matching partners.",
        ],
    },
    {
        "slug": "clock-solitaire",
        "emoji": "🕐",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 1,
        "name": "Clock Solitaire",
        "rules": [
            "Lay twelve piles in a circle like clock positions plus a center pile.",
            "Flip the top card of the current pile and place it on its rank pile.",
            "Win if all cards reach their matching clock positions before kings end the run.",
        ],
        "strategyTips": [
            "Watch which piles still hold face-down cards.",
            "Kings always go to the center; plan around that rule.",
            "Stay patient; luck matters more than deep strategy here.",
        ],
    },
    {
        "slug": "accordion",
        "emoji": "📂",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 2,
        "name": "Accordion",
        "rules": [
            "Lay cards one at a time in a row from the deck.",
            "Compress a card onto the pile one or three places left if rank or suit matches.",
            "Win by reducing the entire deck to a single pile.",
        ],
        "strategyTips": [
            "Prefer three-space jumps when they open longer merges.",
            "Avoid early moves that block later compression chains.",
            "Replay tricky deals to learn which merges matter most.",
        ],
    },
    {
        "slug": "thirty-one",
        "emoji": "3️⃣",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 9,
        "difficulty": 1,
        "name": "Thirty-One",
        "rules": [
            "Each player receives three cards; aim for the highest same-suit total up to thirty-one.",
            "On your turn, draw from deck or discard and discard one card.",
            "Knock when satisfied; lowest hand loses a life until one player remains.",
        ],
        "strategyTips": [
            "Switch suits early if your starting three cards are split.",
            "Knock quickly when holding twenty-nine or thirty in one suit.",
            "Watch how long opponents draw instead of knocking.",
        ],
    },
    {
        "slug": "bezique",
        "emoji": "💎",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 3,
        "name": "Bezique",
        "rules": [
            "Use a 64-card double deck; deal eight cards each.",
            "Melds like marriages and beziques score immediately when declared.",
            "Follow suit; win tricks to draw fresh cards and reach the target score.",
        ],
        "strategyTips": [
            "Declare scoring melds before losing those cards in tricks.",
            "Track trump length to judge endgame trick prospects.",
            "Save double bezique combinations for maximum point swings.",
        ],
    },
    {
        "slug": "piquet",
        "emoji": "🎩",
        "categoryKey": "classic",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 3,
        "name": "Piquet",
        "rules": [
            "Use a 32-card deck; exchange cards after evaluating point combinations.",
            "Score for sets, runs, and point totals before trick play begins.",
            "Play twelve tricks; additional points come from cards captured in tricks.",
        ],
        "strategyTips": [
            "Exchange aggressively when your hand lacks cartes blanches potential.",
            "Lead suits where you hold both length and high honors.",
            "Count remaining trump cards before committing a late trick.",
        ],
    },
    {
        "slug": "golf-solitaire",
        "emoji": "🏌️",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 1,
        "name": "Golf Solitaire",
        "rules": [
            "Deal seven columns of five overlapping cards plus a waste pile starter.",
            "Remove exposed cards one rank higher or lower than the waste top.",
            "Clear the tableau; fewer remaining cards means a better score.",
        ],
        "strategyTips": [
            "Choose moves that unlock the most buried cards.",
            "Save versatile middle ranks for dead-end positions.",
            "Replay deals to beat your personal best clearance count.",
        ],
    },
    {
        "slug": "bakers-dozen",
        "emoji": "🍞",
        "categoryKey": "classic",
        "minPlayers": 1,
        "maxPlayers": 1,
        "difficulty": 2,
        "name": "Baker's Dozen",
        "rules": [
            "Deal thirteen columns of four cards; kings move automatically to column tops.",
            "Build columns downward by suit regardless of rank order at start.",
            "Move all cards to foundations ascending by suit to win.",
        ],
        "strategyTips": [
            "Use the guaranteed king positions to plan early suit builds.",
            "Free buried low cards before committing to one foundation path.",
            "Empty a column only when it helps expose needed cards.",
        ],
    },
    # --- Family (12) ---
    {
        "slug": "spoons",
        "emoji": "🥄",
        "categoryKey": "family",
        "minPlayers": 3,
        "maxPlayers": 13,
        "difficulty": 1,
        "name": "Spoons",
        "rules": [
            "Place one fewer spoon than players in the center; deal four cards each.",
            "Pass one card left each turn; grab a spoon when you collect four of a kind.",
            "Last player to grab a spoon earns a letter toward S-P-O-O-N-S.",
        ],
        "strategyTips": [
            "Keep passing rhythm fast to pressure slower opponents.",
            "Fake a reach toward spoons only when it helps you spot laggers.",
            "Track which ranks opponents stop passing to infer their sets.",
        ],
    },
    {
        "slug": "switch",
        "emoji": "🔀",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 5,
        "difficulty": 1,
        "name": "Switch",
        "rules": [
            "Deal seven cards each; play a card matching rank or suit on the discard pile.",
            "Special cards may skip turns, reverse order, or force draws.",
            "First player to empty their hand wins the round.",
        ],
        "strategyTips": [
            "Save action cards for moments when opponents are close to winning.",
            "Change suit when you hold many cards of one color.",
            "Count cards left in opponents' hands during the final turns.",
        ],
    },
    {
        "slug": "palace",
        "emoji": "🏰",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 5,
        "difficulty": 2,
        "name": "Palace",
        "rules": [
            "Each player builds a hand, face-down palace, and face-up palace.",
            "Play equal or higher cards on the pile; twos reset and tens clear the pile.",
            "Empty hand, then palace cards; first to shed everything wins.",
        ],
        "strategyTips": [
            "Place strong cards face-up on your palace when setting up.",
            "Use twos and tens to escape bad pile situations.",
            "Hold low cards for endgame palace turns when possible.",
        ],
    },
    {
        "slug": "garbage",
        "emoji": "🗑️",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "Garbage",
        "rules": [
            "Lay ten face-down slots numbered ace through ten in front of each player.",
            "Draw and place cards in matching slots; replaced cards continue your turn.",
            "First to fill all ten slots wins; others reduce layout size next round.",
        ],
        "strategyTips": [
            "Place wildcards on hard-to-draw slots like ten or nine.",
            "Remember which slots opponents still need from visible discards.",
            "Keep drawing when replacements let you chain multiple placements.",
        ],
    },
    {
        "slug": "beggar-my-neighbor",
        "emoji": "👋",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 1,
        "name": "Beggar My Neighbor",
        "rules": [
            "Split the deck evenly; players alternate playing cards face-up.",
            "When a court card appears, the opponent must pay penalty cards.",
            "Collect the entire pile when penalties fail; most cards wins.",
        ],
        "strategyTips": [
            "Court cards are power turns; note when many remain.",
            "There is little skill—enjoy the suspense of penalty chains.",
            "Shuffle thoroughly between short rematches for variety.",
        ],
    },
    {
        "slug": "happy-families",
        "emoji": "👨‍👩‍👧",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "Happy Families",
        "rules": [
            "Collect complete four-card families by asking opponents for members.",
            "If asked player holds the card, they must hand it over and you ask again.",
            "Most complete families when the deck runs out wins.",
        ],
        "strategyTips": [
            "Ask for cards where you already hold multiple family members.",
            "Track denials to remember who likely holds missing cards.",
            "Complete one family early to reduce random luck later.",
        ],
    },
    {
        "slug": "pass-the-card",
        "emoji": "🔄",
        "categoryKey": "family",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 1,
        "name": "Pass the Card",
        "rules": [
            "Each player starts with one face-down card and three tokens.",
            "On a signal, peek at your card once and pass it left or keep it.",
            "Lowest card showing loses a token; last player with tokens wins.",
        ],
        "strategyTips": [
            "Pass clearly bad cards early in the round sequence.",
            "Watch neighbors hesitate before passing—that hints at strength.",
            "Keep a token cushion by staying near average ranks when unsure.",
        ],
    },
    {
        "slug": "my-ship-sails",
        "emoji": "⛵",
        "categoryKey": "family",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 1,
        "name": "My Ship Sails",
        "rules": [
            "Deal seven cards each; collect seven of one suit to win instantly.",
            "Each turn trade one to three cards with another player by agreement.",
            "Call when you hold seven of a suit; wrong calls add penalty cards.",
        ],
        "strategyTips": [
            "Trade away stray suits early to focus your collection.",
            "Offer fair trades to stay trusted for later big swaps.",
            "Track which suits opponents are hoarding from their requests.",
        ],
    },
    {
        "slug": "blitz",
        "emoji": "⚡",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "Blitz",
        "rules": [
            "Each player builds three stacks from a personal blitz pile in the center.",
            "Play ascending same-suit piles on shared center stacks when possible.",
            "First to empty their blitz pile shouts blitz and wins the round.",
        ],
        "strategyTips": [
            "Keep one hand on your blitz pile and one on center stacks.",
            "Open moves that free multiple buried cards at once.",
            "Do not hesitate when a valid center play appears.",
        ],
    },
    {
        "slug": "yaniv",
        "emoji": "🇮🇱",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 5,
        "difficulty": 2,
        "name": "Yaniv",
        "rules": [
            "Deal five cards each; reduce hand value by drawing and discarding.",
            "Call Yaniv when your hand totals five or fewer points.",
            "Lowest hand wins unless someone beats the caller with equal or lower.",
        ],
        "strategyTips": [
            "Track visible discards to estimate opponents' totals.",
            "Call Yaniv early when others likely hold face cards.",
            "Break pairs if doing so drops your total faster.",
        ],
    },
    {
        "slug": "james-bond",
        "emoji": "🕵️",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 1,
        "name": "James Bond",
        "rules": [
            "Deal four piles of four cards with four center cards shared by all.",
            "Race to swap cards simultaneously without taking turns.",
            "First to make each of their four piles match by rank wins.",
        ],
        "strategyTips": [
            "Focus one pile at a time instead of random swapping.",
            "Watch center cards opponents ignore for quick matches.",
            "Keep moving; stalling lets faster players finish first.",
        ],
    },
    {
        "slug": "kings-in-the-corner",
        "emoji": "👑",
        "categoryKey": "family",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 1,
        "name": "Kings in the Corner",
        "rules": [
            "Deal seven cards each; build four corner piles alternating red and black downward.",
            "Play one card per turn on corners or shared descending piles.",
            "First to empty hand wins; kings start new corner piles.",
        ],
        "strategyTips": [
            "Play kings to corners quickly to open new placement options.",
            "Hold cards that fit multiple piles for flexible turns.",
            "Block opponents by using shared piles they need.",
        ],
    },
    # --- Trick-Taking (14) ---
    {
        "slug": "five-hundred",
        "emoji": "5️⃣",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Five Hundred",
        "rules": [
            "Partners sit across; bid how many tricks and which suit will be trump.",
            "Follow suit when able; highest trump or led suit wins each trick.",
            "Meet your contract to score; fail and lose points toward game total.",
        ],
        "strategyTips": [
            "Bid with strong trump length plus side aces.",
            "Lead trump early when you need to pull opponents' honors.",
            "Track which suits opponents are void in from discards.",
        ],
    },
    {
        "slug": "sheepshead",
        "emoji": "🐑",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Sheepshead",
        "rules": [
            "One player opposes the others as picker after a short auction.",
            "Queens and jacks are permanent trump in fixed order.",
            "Picker needs sixty-one points from tricks to win the hand.",
        ],
        "strategyTips": [
            "Pick only with strong trump and point-rich cards.",
            "Defenders lead suits the picker is likely void in.",
            "Count trump as they fall; late tricks often decide close hands.",
        ],
    },
    {
        "slug": "doppelkopf",
        "emoji": "🎭",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Doppelkopf",
        "rules": [
            "Partnerships are hidden until revealed through play.",
            "Queens, jacks, and diamonds behave as trump depending on variant.",
            "Team reaching the target score first wins the session.",
        ],
        "strategyTips": [
            "Signal partner subtly with thoughtful card choice.",
            "Reveal partnership when coordination will swing key tricks.",
            "Track which queens and jacks have been played.",
        ],
    },
    {
        "slug": "schafkopf",
        "emoji": "♣️",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Schafkopf",
        "rules": [
            "Partnerships shift each hand based on who holds called cards.",
            "Obers and Unters are trump; aces and tens carry high point values.",
            "Calling team must reach sixty-one trick points to win.",
        ],
        "strategyTips": [
            "Learn the fixed trump order before playing competitively.",
            "Lead aces from long side suits when you are on defense.",
            "Save trump for tricks that protect tens and aces.",
        ],
    },
    {
        "slug": "bid-whist",
        "emoji": "📣",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Bid Whist",
        "rules": [
            "Partners bid tricks and choose trump or no-trump for the hand.",
            "Follow suit; jokers may act as highest trump in some variants.",
            "Bidder's team must capture at least the promised tricks to score.",
        ],
        "strategyTips": [
            "Count sure winners before committing to a high bid.",
            "No-trump rewards long strong suits and careful entry management.",
            "Defenders cooperate to force the bidder to spend trump early.",
        ],
    },
    {
        "slug": "jass",
        "emoji": "🇨🇭",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Jass",
        "rules": [
            "Partners sit across; choose trump through bidding or card turn-up.",
            "Must trump when void in led suit if opponents are winning.",
            "Score melds plus trick points; first team to target wins.",
        ],
        "strategyTips": [
            "Announce strong melds before trick play when rules allow.",
            "Pull trump when you hold length and high honors.",
            "Discard low points when you cannot win the trick.",
        ],
    },
    {
        "slug": "klaberjass",
        "emoji": "🎴",
        "categoryKey": "trick_taking",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 2,
        "name": "Klaberjass",
        "rules": [
            "Two players with a 32-card deck; bid to choose trump suit.",
            "Jacks and queens form a special trump order separate from suit rank.",
            "Reach the agreed total from melds and trick points to win.",
        ],
        "strategyTips": [
            "Bid trump when jack-nine combinations are in your hand.",
            "Lead non-trump aces before trump strips your length.",
            "Track which trump honors remain after each trick.",
        ],
    },
    {
        "slug": "twenty-eight",
        "emoji": "2️⃣8️⃣",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 3,
        "name": "Twenty-Eight",
        "rules": [
            "Deal four cards each; bid from zero to twenty-eight for trump choice.",
            "Only trump jack, nine, ace, and ten rank high in point tricks.",
            "Bidder's team must meet the contract or lose the round score.",
        ],
        "strategyTips": [
            "Bid aggressively only with strong trump jack-nine combinations.",
            "Lead trump early when you need to pull opposing honors.",
            "Defenders target suits where the bidder looks weak.",
        ],
    },
    {
        "slug": "pluck",
        "emoji": "🪶",
        "categoryKey": "trick_taking",
        "minPlayers": 3,
        "maxPlayers": 5,
        "difficulty": 2,
        "name": "Pluck",
        "rules": [
            "Each player may stay in or drop after seeing a few cards.",
            "Trump is fixed or chosen; follow suit when possible.",
            "Lowest trick count among staying players wins the round.",
        ],
        "strategyTips": [
            "Drop early with scattered low cards and no trump length.",
            "Force opponents to win tricks they do not want with high leads.",
            "Count how many players stayed in before playing your best cards.",
        ],
    },
    {
        "slug": "misere",
        "emoji": "🌙",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Misère",
        "rules": [
            "Players try to avoid winning tricks rather than collect them.",
            "Follow suit when able; highest card of led suit takes the trick.",
            "Each unwanted trick adds penalty points; lowest total wins.",
        ],
        "strategyTips": [
            "Dump high cards early when you are safe to lose the trick.",
            "Lead low cards in suits where opponents hold higher ones.",
            "Track who is forced to win tricks near round end.",
        ],
    },
    {
        "slug": "napoleon",
        "emoji": "🎖️",
        "categoryKey": "trick_taking",
        "minPlayers": 3,
        "maxPlayers": 5,
        "difficulty": 2,
        "name": "Napoleon",
        "rules": [
            "Players bid how many tricks they will win as soloist.",
            "Highest bidder names trump and plays alone against the others.",
            "Make the contract to score; fail and pay points to opponents.",
        ],
        "strategyTips": [
            "Bid five only with secure trump control and side aces.",
            "Defenders lead suits the soloist is void in when possible.",
            "Use trump sparingly when defenders must follow suit anyway.",
        ],
    },
    {
        "slug": "setback",
        "emoji": "⏪",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Setback",
        "rules": [
            "Partners bid tricks; trump suit comes from highest bid.",
            "Score for high, low, jack, and game points each hand.",
            "First team to the target score wins the match.",
        ],
        "strategyTips": [
            "Bid conservatively until you know partner's strength signals.",
            "Capture the jack of trump even when other tricks look lost.",
            "Track point cards played to judge game-point totals.",
        ],
    },
    {
        "slug": "all-fours",
        "emoji": "4️⃣",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "All Fours",
        "rules": [
            "Partners sit across; dealer may turn trump or players bid.",
            "Score for high trump, low trump, jack of trump, and game points.",
            "Follow suit; win tricks to capture scoring honors.",
        ],
        "strategyTips": [
            "Lead trump when you hold both high and low trump honors.",
            "Protect the jack of trump until you can secure it safely.",
            "Count point cards taken to estimate game-point totals.",
        ],
    },
    {
        "slug": "pedro",
        "emoji": "🎯",
        "categoryKey": "trick_taking",
        "minPlayers": 4,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Pedro",
        "rules": [
            "Bid to choose trump; five of trump called Pedro scores extra.",
            "Follow suit; partners combine tricks toward contract total.",
            "Reach the session target score through successful contracts.",
        ],
        "strategyTips": [
            "Bid when you hold Pedro plus strong trump support.",
            "Lead side-suit aces before trump strips your entries.",
            "Defenders target Pedro holders with forced trump plays.",
        ],
    },
    # --- Strategy (14) ---
    {
        "slug": "five-hundred-rummy",
        "emoji": "📊",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 8,
        "difficulty": 2,
        "name": "Five Hundred Rummy",
        "rules": [
            "Deal seven cards each; meld sets and runs to reduce deadwood.",
            "Draw from stock or discard pile; lay off on existing melds when allowed.",
            "First to reach five hundred points across hands wins.",
        ],
        "strategyTips": [
            "Lay melds early to start scoring and reduce hand risk.",
            "Watch discard pile for free lay-off opportunities.",
            "Hold high deadwood only when close to going out in one turn.",
        ],
    },
    {
        "slug": "hand-and-foot",
        "emoji": "🖐️",
        "categoryKey": "strategy",
        "minPlayers": 4,
        "maxPlayers": 6,
        "difficulty": 3,
        "name": "Hand and Foot",
        "rules": [
            "Each player has a hand and a hidden foot pile to play through.",
            "Melds require minimum point totals that rise each round.",
            "Team that completes required melds and empties both piles wins the deal.",
        ],
        "strategyTips": [
            "Open melds quickly so partners can add cards freely.",
            "Manage wild cards to hit round point thresholds efficiently.",
            "Pick up the discard pile only when it completes a strong meld.",
        ],
    },
    {
        "slug": "shanghai-rummy",
        "emoji": "🌆",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 3,
        "name": "Shanghai Rummy",
        "rules": [
            "Ten rounds with different meld contracts each round.",
            "Buy extra cards when allowed by paying one discard per purchase.",
            "First to empty hand after meeting the round contract wins the deal.",
        ],
        "strategyTips": [
            "Plan purchases early in rounds with tough contracts.",
            "Lay down immediately once legal to start reducing hand size.",
            "Track round requirements so you keep needed cards through buys.",
        ],
    },
    {
        "slug": "liverpool-rummy",
        "emoji": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 3,
        "name": "Liverpool Rummy",
        "rules": [
            "Series of deals with contracts requiring specific meld patterns.",
            "Draw and discard; lay down contract before adding to other melds.",
            "Lowest total deadwood across all deals wins the game.",
        ],
        "strategyTips": [
            "Memorize upcoming contracts to hold flexible cards early.",
            "Break almost-complete sets only when the contract demands it.",
            "Lay off on opponents' melds to shrink deadwood late in a deal.",
        ],
    },
    {
        "slug": "michigan-rummy",
        "emoji": "🏛️",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 8,
        "difficulty": 2,
        "name": "Michigan Rummy",
        "rules": [
            "Play chips on board spaces while melding and taking tricks each round.",
            "Collect payouts when you capture key cards or complete melds.",
            "Most chips after all rounds wins the session.",
        ],
        "strategyTips": [
            "Place chips on spaces matching cards you hold when affordable.",
            "Track which bonus cards have already been captured.",
            "Balance meld speed with trick timing for board payouts.",
        ],
    },
    {
        "slug": "hollywood-gin",
        "emoji": "🎬",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 2,
        "difficulty": 2,
        "name": "Hollywood Gin",
        "rules": [
            "Play three simultaneous gin rummy scoresheets at once.",
            "Each hand updates all three columns with cumulative totals.",
            "Win the overall game by leading in at least two of three columns.",
        ],
        "strategyTips": [
            "Play slightly safer when ahead in two columns already.",
            "Knock early in columns where opponents are close to gin.",
            "Track deadwood across sheets—not just the current hand.",
        ],
    },
    {
        "slug": "oklahoma-gin",
        "emoji": "🤠",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Oklahoma Gin",
        "rules": [
            "First upcard sets the maximum knock value for the hand.",
            "Form sets and runs; knock when deadwood is at or below the limit.",
            "Gin scores bonus; undercut rewards the defender.",
        ],
        "strategyTips": [
            "Adjust knock timing every hand based on the upcard value.",
            "A high upcard favors holding out for gin over quick knocks.",
            "Discard near-knock cards opponents could use to undercut.",
        ],
    },
    {
        "slug": "tripoley",
        "emoji": "🎪",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 9,
        "difficulty": 2,
        "name": "Tripoley",
        "rules": [
            "Place markers on board spaces for hearts, queens, and other bonuses.",
            "Play a round of poker-style hands, then rummy, then hearts-style tricks.",
            "Collect markers when you win the matching segment.",
        ],
        "strategyTips": [
            "Claim board spaces that match cards you hold in multiple segments.",
            "Save strong hearts for the final trick-taking phase.",
            "Track which markers opponents still need from visible plays.",
        ],
    },
    {
        "slug": "tressette",
        "emoji": "🇮🇹",
        "categoryKey": "strategy",
        "minPlayers": 4,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Tressette",
        "rules": [
            "Partners sit across; no trump suit in classic play.",
            "Follow suit; highest card of led suit wins unless a three is played.",
            "Threes are special high cards; team reaching target score wins.",
        ],
        "strategyTips": [
            "Lead aces from long suits to pull opposing honors.",
            "Save threes for tricks opponents expect to win.",
            "Communicate strength through conventional lead choices.",
        ],
    },
    {
        "slug": "briscola",
        "emoji": "🃏",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Briscola",
        "rules": [
            "Turn one card to set trump; aces and threes carry highest point values.",
            "Follow suit is not required; trump beats non-trump always.",
            "First side to the target score from captured cards wins.",
        ],
        "strategyTips": [
            "Lead worthless cards to coax out opposing trump.",
            "Save aces and threes for tricks you are sure to win.",
            "Track trump played to judge endgame capture chances.",
        ],
    },
    {
        "slug": "continents",
        "emoji": "🌍",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Continents",
        "rules": [
            "Each round requires a different meld pattern before you can go out.",
            "Draw and discard; complete the round requirement then empty your hand.",
            "Lowest cumulative penalty points after all rounds wins.",
        ],
        "strategyTips": [
            "Read the round card early and hoard matching combinations.",
            "Lay down as soon as legal to start shedding extra cards.",
            "Discard high penalty cards opponents could lay off on you.",
        ],
    },
    {
        "slug": "conspiracy",
        "emoji": "🤫",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 6,
        "difficulty": 2,
        "name": "Conspiracy",
        "rules": [
            "Collect four-of-a-kind sets by trading cards face-down with opponents.",
            "When you have a set, secretly signal your partner with an agreed gesture.",
            "Call conspiracy when you spot your partner's signal before others do.",
        ],
        "strategyTips": [
            "Design subtle signals that blend with normal table movement.",
            "Trade away duplicate ranks you are not collecting.",
            "Watch opponents for accidental repeated gestures.",
        ],
    },
    {
        "slug": "push",
        "emoji": "👊",
        "categoryKey": "strategy",
        "minPlayers": 2,
        "maxPlayers": 4,
        "difficulty": 2,
        "name": "Push",
        "rules": [
            "Deal a shared layout of stacks; play cards matching rank or suit on top.",
            "Push a stack to your neighbor when you cannot play legally.",
            "First to empty their personal pile wins the round.",
        ],
        "strategyTips": [
            "Push burdensome stacks toward players with fewer options.",
            "Hold versatile cards that match multiple visible tops.",
            "Track stack sizes to spot who is close to winning.",
        ],
    },
    {
        "slug": "sergeant-major",
        "emoji": "⭐",
        "categoryKey": "strategy",
        "minPlayers": 3,
        "maxPlayers": 3,
        "difficulty": 2,
        "name": "Sergeant Major",
        "rules": [
            "Deal sixteen cards each; bid how many tricks you will win.",
            "Follow suit; highest card of led suit wins unless trump is played.",
            "Score when your bid exactly matches tricks taken.",
        ],
        "strategyTips": [
            "Bid one less than your sure winners when hand looks strong.",
            "Force opponents to win unwanted tricks with low leads.",
            "Track exact trick counts as the hand nears its end.",
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
    skipped = 0
    for game in NEW_GAMES:
        slug = game["slug"]
        if slug in existing:
            skipped += 1
            continue
        if len(manifest) >= TARGET_TOTAL:
            break
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
        existing.add(slug)
        added += 1

    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    games_en_path.write_text(json.dumps(games_en, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(f"Added {added} games (skipped {skipped} duplicates); total {len(manifest)}")
    if len(manifest) != TARGET_TOTAL:
        print(f"WARNING: expected {TARGET_TOTAL} games, got {len(manifest)}")


if __name__ == "__main__":
    main()
