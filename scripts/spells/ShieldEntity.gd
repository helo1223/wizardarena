extends Area2D

@export var health : float
@export var lifetime : float
@onready var lifetime_timer : Timer = $Lifetime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    lifetime_timer.wait_time = lifetime
    lifetime_timer.start()

func _on_lifetime_timeout() -> void:
    queue_free()

func take_damage(damage):
    print("shield health: ", health)
    health -= damage
    print("new health: ", health)
    if health <= 0:
        queue_free()
