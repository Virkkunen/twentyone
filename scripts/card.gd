extends Node2D

enum CardSuit {
  CLUBS,
  SPADES,
  HEARTS,
  DIAMONDS
}

enum SuitColour {
  RED,
  BLACK
}

enum CardRank {
  ACE, TWO, THREE, FOUR, FIVE,
  SIX, SEVEN, EIGHT, NINE,
  TEN, JOKER, QUEEN, KING
}

@export var card_suit : CardSuit
@export var suit_colour : SuitColour
@export var card_rank : CardRank
@export var is_face : bool
@export var card_value : int
@export var is_down : bool

@onready var label_rank : Label = $Rank
@onready var label_suit : Label = $Suit

var is_dragging = false
var mouse_offset = Vector2.ZERO

func update_card() -> void:
  if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
    label_rank.text = str(card_rank + 1)
  else:
    label_rank.text = CardRank.keys()[card_rank]
  label_suit.text = CardSuit.keys()[card_suit]

  if suit_colour == SuitColour.RED:
    label_suit.set("theme_override_colors/font_color", Color.RED)
    label_rank.set("theme_override_colors/font_color", Color.RED)
  else:
    label_suit.set("theme_override_colors/font_color", Color.BLACK)
    label_rank.set("theme_override_colors/font_color", Color.BLACK)
    
  # card value
  # ranks are as they are, face cards are 10
  # ace is 1 or 11
  if card_rank >= CardRank.TWO and card_rank <= CardRank.TEN:
    card_value = card_rank + 1
  elif is_face:
    card_value = 10
  # elif card is ace, check other cards
  # if total is over 21, ace is 1, else 11
  # maybe this should be in the game logic