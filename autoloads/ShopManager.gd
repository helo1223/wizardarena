# ShopManager.gd
extends Node

# Example arrays of available spells and upgrades
var available_spells: Array = [Fireball.new(), Shield.new()]
var available_upgrades: Array = []

# Function to offer random spells
func offer_random_spells():
    var random_spells = []
    while random_spells.size() < 2:
        var spell = available_spells[randi() % available_spells.size()]
        random_spells.append(spell)
    return random_spells

# Function to offer random upgrades
func offer_random_upgrades():
    var random_upgrades = []
    while random_upgrades.size() < 3:
        var upgrade = available_upgrades[randi() % available_upgrades.size()]
        random_upgrades.append(upgrade)
    return random_upgrades
