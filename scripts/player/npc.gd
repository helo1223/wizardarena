extends Player
class_name NPC

func _init() -> void:
    spawn_point = Vector2(200.0, -10.0)
    player_name = "Target dummy"

func _ready() -> void:
    super._ready()
    GameManager.players["NPC"] = self
    GameManager.teams[1] = ([self])

func _on_timer_timeout() -> void:
    if not dead and input_enabled:
        active_spells[0].cast(self, Vector2.LEFT)

func reset_for_round():
    super.reset_for_round()
    GameManager.players["NPC"] = self
    GameManager.teams[1] = ([self])
