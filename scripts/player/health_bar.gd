extends ProgressBar

@onready var player: Node = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if is_instance_of(player, Player) and not is_instance_of(player, NPC):
        pass
    var max_hp_with_shield = player.max_health + player.shield
    self.value = (player.health / max_hp_with_shield) * 100
