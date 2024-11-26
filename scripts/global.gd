extends Node

signal score_changed
signal player_total_changed
signal house_total_changed

@export var score = 0:
  get:
    return score
  set(value):
    score = value
    emit_signal("score_changed")

@export var player_total = 0:
  get:
    return player_total
  set(value):
    player_total = value
    emit_signal("player_total_changed")

@export var house_total = 0:
  get:
    return house_total
  set(value):
    house_total = value
    emit_signal("house_total_changed")

# @export var screen_size : Vector2