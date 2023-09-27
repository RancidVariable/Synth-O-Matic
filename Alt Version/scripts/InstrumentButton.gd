#class_name InstrumentButton
extends Button

var ID: int
var maxLoops: int
var audioPlayer: AudioStreamPlayer
var currentLoop: int = 0:
	set(value):
		currentLoop = (value) % maxLoops
		text = str(currentLoop) if currentLoop else "X"


signal update_loop(ID: int, loop: int)
signal audio_finished(ID: int)


func _ready():
	text = "X" # <--- This is set in currentLoop setter function
	connect("pressed", _on_button_pressed)
	
	audioPlayer = get_child(0)
	audioPlayer.connect("finished", _on_audio_finished)



# Signals
func _on_button_pressed() -> void:
	
	currentLoop += 1
	emit_signal("update_loop", ID, currentLoop)


func _on_audio_finished() -> void:
	
	emit_signal("audio_finished", ID)
