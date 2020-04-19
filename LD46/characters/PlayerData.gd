extends Node

signal max_power_updated
signal power_regen_updated
signal power_updated

const TILE_MAP_HEIGHT = 12
const TILE_MAP_WIDTH = 21

var max_power = 100.0 setget set_max_power
var power_regen = 1.0 setget set_power_regen # regens X power per second
var power = max_power setget set_power

func set_max_power(value: float) -> void:
	max_power = value
	emit_signal("max_power_updated")
	
func set_power_regen(value: float) -> void:
	power_regen = value
	emit_signal("power_regen_updated")

func set_power(value: float) -> void:
	if value < 0.0:
		value = 0.0
	if value > max_power:
		value = max_power
	power = value
	emit_signal("power_updated")
	return
	
func reset() -> void:
	power = 100
