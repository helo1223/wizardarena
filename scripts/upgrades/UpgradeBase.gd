extends Node
class_name Upgrade

@onready var description_label = $DescriptionLabel
var upgrade_name : String = "Upgrade"
var description : String = "Base upgrade"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    description_label.text = description

func apply(player: Player):
    # By default, upgrades do nothing, specific upgrades will override this
    print("Applying upgrade ", upgrade_name, " to " + player.names)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
