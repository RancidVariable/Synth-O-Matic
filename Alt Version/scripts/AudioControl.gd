#class_name AudioControl
extends Control

# Declare member variables here.
@onready var play_bar: HSlider = $PlayBar
@onready var play: Button = $Play
@onready var bass: GridContainer = $Bass
@onready var drums: GridContainer = $Drums
@onready var synth_chord: GridContainer = $SynthChord

var current_track = 0  # Keeps track of the currently playing track
#var bass_playing = false  # Variable to track bass playing status
#var drums_playing = false
#var synth_playing = false



func _ready() -> void:
	$Bass.connect("track_finished", _on_track_finished)





func _on_Play_pressed() -> void:
	# Stop playback on all instances of AudioStreamPlayers first
	stop_all_tracks()
	
	current_track = 0
	play_bar.value = 0
	
	update_current_track(0)

func stop_all_tracks() -> void:
	# Stop playback on all instances of AudioStreamPlayers for each instrument
	$Bass.stop_all_tracks()
	$Drums.stop_all_tracks()
	$SynthChord.stop_all_tracks()

func play_current_track() -> void:
	
	$Bass.play_next_track()
	$Drums.play_next_track()
	$SynthChord.play_next_track()

func update_current_track(track_number: int) -> void:
	current_track = track_number
	play_current_track()






# For funsies, I'll just say that the bass decides the HSlider Value
func _on_Bass0_finished() -> void:
	
	update_current_track(1)
	current_track = 1
	play_bar.value = 0

func _on_track_finished(instrument: GridContainer) -> void:
	
	current_track = instrument.currentTrack
	play_bar.value = current_track

func _on_Stop_pressed() -> void:
	
	stop_all_tracks()



