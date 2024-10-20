extends ProgressBar

@onready var player: Node = $".."

var hp_value : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    hp_value = player.health
    self.value = (hp_value / player.max_health) * 100
