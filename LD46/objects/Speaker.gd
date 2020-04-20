extends Sprite

export var cost := 20.0

var playing : bool = false

func _on_Button_pressed() -> void:
	if playing:
		return
	if PlayerData.power >= cost:
		PlayerData.power -= cost
		playing = true
		$Timer.start()
		$AnimationPlayer.play("play_sounds")
		$AreaDance.monitorable = true
		$AreaSpeaker.monitorable = true


func _on_Timer_timeout() -> void:
	playing = false
	$AnimationPlayer.play("silent")
	$AreaDance.monitorable = false
	$AreaSpeaker.monitorable = false
