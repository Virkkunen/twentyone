extends Node

signal score_changed
signal player_total_changed
signal house_total_changed
signal player_bust
signal house_bust

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
    if player_total > 21:
      emit_signal("player_bust")

@export var house_total = 0:
  get:
    return house_total
  set(value):
    house_total = value
    emit_signal("house_total_changed")
    if house_total > 21:
      emit_signal("house_bust")

@export var screen_size : Vector2