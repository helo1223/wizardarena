extends ProgressBar

@onready var player: Node = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    self.visible = true
    var shield = player.shield
    if shield == 0:
        self.value = 0
        self.visible = false
    var current_hp_with_shield = player.health + shield
    self.value = (current_hp_with_shield / player.max_health) * 100
