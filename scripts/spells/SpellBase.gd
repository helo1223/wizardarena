extends Node
class_name Spell

var spell_name : String = "Base spell"
var cooldown : float
var damage : int
var cast_time : float
var area_of_effect : float
var caster : Player

func _init() -> void:
    cooldown = GameManager.spells[spell_name]["cooldown"]
    damage = GameManager.spells[spell_name]["damage"]

func cast(caster: Node, target_position: Vector2):
    print(spell_name, " cast by ", caster.name)

func apply_effect(target: Player):
    print(spell_name, " was applied to ", target.name)
