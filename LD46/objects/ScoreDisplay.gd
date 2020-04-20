extends Node2D

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_score")
	update_score()

func update_score() -> void:
	var score : int = Primes.get_prime(PlayerData.score)
	for i in range(6):
		if score > 0 or i == 0:
			get_child(i).visible = true
			get_child(i).frame = score % 10
		else:
			get_child(i).visible = false
		score = score / 10
		
