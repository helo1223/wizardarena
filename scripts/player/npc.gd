extends CharacterBody2D

@export var health : float = 100.0
var max_health = health

var active_spells: Array[Spell] = [Fireball.new()] # Array of active spell instances
@onready var projectiles: Node = $Projectiles


func take_damage(damage):
    health -= damage
    if health <= 0:
        queue_free()
    
func get_projectiles():
    return $Projectiles

func _on_timer_timeout() -> void:
    pass#active_spells[0].cast(self, target.global_position)
