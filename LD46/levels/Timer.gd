extends Timer

func _ready() -> void:
	PlayerData.connect("power_regen_updated", self, "_on_power_regen_updated")
	
func _on_power_regen_updated() -> void:
	wait_time = 1.0 / PlayerData.power_regen
