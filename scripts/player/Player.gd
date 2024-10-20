extends CharacterBody2D
class_name Player

@export var speed : float = 300.0
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
    camera.enabled = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
    if !is_multiplayer_authority():
        return
    # Get the input direction using get_vector for up, down, left, right actions
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    # Apply movement based on input direction and speed
    velocity = input_direction * speed
    # Move the character
    move_and_slide()
