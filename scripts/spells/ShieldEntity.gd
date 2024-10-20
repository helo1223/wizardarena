extends Area2D
class_name ShieldEntity

@export var health : float
@export var lifetime : float
@onready var lifetime_timer : Timer = $Lifetime

var target_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    lifetime_timer.wait_time = lifetime
    lifetime_timer.start()
    if target_player == null:
        target_player = get_parent()

func _on_lifetime_timeout() -> void:
    queue_free()

func take_damage(damage):
    print("shield health: ", health)
    health -= damage
    print("new health: ", health)
    if health <= 0:
        target_player.take_damage(health * -1)
        queue_free()
