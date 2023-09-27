#class_name AudioContainer
extends GridContainer

@export_dir() var audioFolder: String

var loops: Array[AudioStream] = [
	preload("res://Muted8Seconds.wav"),
]

var audioPlayers: Array[AudioStreamPlayer] = []
var currentTrack: int = -1

signal track_finished(container: GridContainer)




func _ready() -> void:
	
	# Gather the audio files. This could be better if you wanted specific order
	if audioFolder:
		for filePath in DirAccess.get_files_at(audioFolder):
			if filePath.get_extension() == "ogg":
				
				var data: AudioStream = load(audioFolder + "/" + filePath)
				loops.append(data)
	
	# Set max loops for buttons and give id so they can signal to control
	var audioPlayerID: int = 0
	
	for i in get_children().size():
		var child = get_child(i)
		
		if child.has_signal("update_loop"):
			
			child.maxLoops = loops.size()
			child.ID = audioPlayerID
			
			child.connect("update_loop", _on_update_loop)
			child.connect("audio_finished", _on_audio_finished)
			
			# Make array of audio players so we can call them by ID
			var player: AudioStreamPlayer = child.get_child(0)
			player.stream = loops[0]
			audioPlayers.append(player)
			audioPlayerID += 1
	randomize()

func stop_all_tracks():
	
	for audioPlayer in audioPlayers:
		audioPlayer.stop()
	
	currentTrack = -1

func play_next_track():
	
	currentTrack = (currentTrack + 1) % audioPlayers.size()
	
	audioPlayers[currentTrack].play()


# Signals
func _on_LABEL_pressed() -> void:
	
	for child in get_children():
		if true:#child is Button and child.name != "LABEL":
			
			if child.has_signal("update_loop"):
				child.currentLoop = randi_range(0, 999)
				child._on_button_pressed()



func _on_update_loop(ID: int, track: int) -> void:
	audioPlayers[ID].stream = loops[track]


func _on_audio_finished(_ID: int) -> void:
	#print("player: " + str(_ID) + " finished")
	play_next_track()
	emit_signal("track_finished", self)


