extends Node

signal player_damage

signal gold_collected(number: float)
signal wood_collected(number: float)

signal gold_spent(amount: float)

signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)


func emit_gold_collected(number: float):
	gold_collected.emit(number)
	

func emit_wood_collected(number: float):
	wood_collected.emit(number)
	

func emit_gold_spent(number: float):
	gold_spent.emit(number)
	

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damage():
	player_damage.emit()
