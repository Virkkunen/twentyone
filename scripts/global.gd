extends Node

signal score_changed

@export var score = 0:
  get:
    return score
  set(value):
    score = value
    emit_signal("score_changed")

@export var screen_size : Vector2