extends Timer

var setDanger : bool = false;
var progressBar : ProgressBar;

func _ready() -> void:
	progressBar = $"../UI/ProgressBar";
	progressBar.max_value = wait_time;

func _process(delta : float) -> void:
	progressBar.value = time_left;
	
	if !setDanger and time_left < wait_time/3:
		setDanger = true;
		progressBar.self_modulate = Color("#ff7675");
		($"../AudioStreamPlayer" as AudioStreamPlayer).pitch_scale = 1.5;

func _on_timeout() -> void:
	$"../..".call("changeState", main.GAMESTATE.SCORE);
