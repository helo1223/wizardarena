extends ProgressBar

@onready var player: Node = $".."

var hp_value : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    hp_value = player.health
    var shield = player.shield
    var max_hp_with_shield = player.max_health + shield
    var current_hp_with_shield = hp_value + shield
    self.value = (current_hp_with_shield / max_hp_with_shield) * 100
