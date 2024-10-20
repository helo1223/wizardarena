extends Player
class_name NPC

func _ready() -> void:
    pass
    
func _physics_process(delta: float) -> void:
    update_shield_value()


func _on_timer_timeout() -> void:
    active_spells[0].cast(self, Vector2.LEFT)
