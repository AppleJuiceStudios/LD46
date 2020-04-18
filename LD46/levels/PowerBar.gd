extends ProgressBar

func _ready() -> void:
	PlayerData.connect("max_power_updated", self, "_on_max_power_updated")
	PlayerData.connect("power_updated", self, "_on_power_updated")
	_on_max_power_updated()
	_on_power_updated()
	

func _on_Timer_timeout() -> void:
	if PlayerData.power < 100:
		PlayerData.power += 1

func _on_power_updated():
	value = PlayerData.power
	
func _on_max_power_updated():
	max_value = PlayerData.max_power
