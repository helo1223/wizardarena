extends Control
class_name Upgrade

@onready var description_label = $DescriptionLabel
var description : String = "Base upgrade"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    description_label.text = description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
