extends Player
class_name NPC

func _ready() -> void:
    $CollisionShape2D.set_deferred("disabled", false)
    
func _process(delta: float) -> void:
    update_shield_value()


func _on_timer_timeout() -> void:
    if not dead:
        active_spells[0].cast(self, Vector2.LEFT)
