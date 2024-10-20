extends Area2D
class_name SpellBase

var spell_name : String = "Base spell"

var cooldown : float = 1.0
var damage : int = 10

func cast():
    # Logic for casting the spell
    pass

func apply_effect(target):
    # Basic damage logic
    target.take_damage(damage)
