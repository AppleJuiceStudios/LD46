extends Timer

export var next_scene: PackedScene
export var time_limit: int

func _ready() -> void:
	wait_time = time_limit
	start()


func _on_LevelTimer_timeout() -> void:
	get_tree().change_scene_to(next_scene)
