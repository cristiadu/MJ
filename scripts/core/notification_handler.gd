extends Node

# Global singleton responsible for displaying in-game notifications to the player
# This class handles showing and hiding the notification panel that displays temporary messages

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")

# Reference to the notification panel scene
var notification_panel_scene = preload("res://scenes/ui/notification_panel.tscn")

# UI components for notifications
var notification_panel     # The main panel that contains the notification
var notification_label     # The label that displays the notification text
var notification_timer     # Timer that controls how long notifications are displayed
var canvas_layer           # Canvas layer to ensure notifications appear on top
var is_panel_ready = false # Whether the notification panel has been initialized

func _ready():
	# Initialize notification panel when the node is ready
	# Using call_deferred to ensure proper initialization order
	call_deferred("initialize_notification_panel")
	
	# Register this notification handler with GameState for global access
	if GameState:
		GameState.game_instance = self
		
func initialize_notification_panel():
	# Creates and configures the notification panel UI components
	
	# Create canvas layer to ensure UI is always on top of game elements
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10  # Higher layer to be on top
	add_child(canvas_layer)
	
	# Instantiate the notification panel from the scene
	notification_panel = notification_panel_scene.instantiate()
	canvas_layer.add_child(notification_panel)
	
	# Get references to the child nodes
	notification_label = notification_panel.get_node("Label")
	notification_timer = notification_panel.get_node("Timer")
	
	# Connect the timer signal
	notification_timer.timeout.connect(_on_notification_timer_timeout)
	
	# Mark notification system as ready
	is_panel_ready = true
	
	# Debug message
	print("Notification panel initialized and added to canvas layer")

# Display a notification message to the player
# Parameters:
# - message: The text to display
# - duration: How long to display the message (in seconds)
func show_notification(message, duration = 2.0):
	# Debug log
	print("show_notification called with message: " + message)
	
	# Handle case where notification panel isn't ready yet
	if not is_panel_ready:
		print("Warning: Notification panel not ready yet. Message queued: " + message)
		
		# Create panel if not already done
		call_deferred("initialize_notification_panel")
		
		# Queue the message to be shown after a short delay
		var show_timer = Timer.new()
		add_child(show_timer)
		show_timer.wait_time = 0.5
		show_timer.one_shot = true
		show_timer.timeout.connect(func(): 
			show_notification(message, duration)
			show_timer.queue_free()
		)
		show_timer.start()
		return
	
	# Validate components exist
	if not notification_panel or not notification_label:
		print("Error: Notification components are null. Message: " + message)
		return
	
	# Display the notification
	notification_label.text = message
	notification_panel.visible = true
	notification_timer.wait_time = duration
	notification_timer.start()

# Callback for when notification display time expires
func _on_notification_timer_timeout():
	if notification_panel:
		notification_panel.visible = false 
