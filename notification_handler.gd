extends Node

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")

# Reference to the notification panel
var notification_panel
var notification_label
var notification_timer
var canvas_layer
var is_panel_ready = false

func _ready():
	# Create notification panel if it doesn't exist
	call_deferred("create_notification_panel")
	
	# Make sure GameState can use the notification system
	if GameState:
		GameState.game_instance = self
		
func create_notification_panel():
	# Create canvas layer to ensure UI is always on top
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10  # Higher layer to be on top
	add_child(canvas_layer)
	
	# Create panel
	notification_panel = Panel.new()
	notification_panel.visible = false
	
	# Use Control's built-in anchors to center in screen
	notification_panel.anchor_left = 0.5
	notification_panel.anchor_top = 0.1  # Position at 10% from top
	notification_panel.anchor_right = 0.5
	notification_panel.anchor_bottom = 0.1
	
	# Use margin to define size and offset from anchor
	notification_panel.offset_left = -200   # Half width to left
	notification_panel.offset_right = 200   # Half width to right
	notification_panel.offset_top = 0
	notification_panel.offset_bottom = 100  # Height of panel
	
	# Add a colored background to make it stand out
	notification_panel.self_modulate = Color(0.1, 0.1, 0.1, 0.8)  # Semi-transparent dark background
	
	# Create label
	notification_label = Label.new()
	notification_label.anchor_left = 0
	notification_label.anchor_top = 0
	notification_label.anchor_right = 1
	notification_label.anchor_bottom = 1
	notification_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notification_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Set font size correctly
	var font_size = 24
	notification_label.add_theme_font_size_override("font_size", font_size)
	
	# Set text color to ensure visibility
	notification_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	
	notification_label.text = "Notification Text"
	notification_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Create timer
	notification_timer = Timer.new()
	notification_timer.wait_time = 2.0
	notification_timer.one_shot = true
	notification_timer.timeout.connect(_on_notification_timer_timeout)
	
	# Add all to hierarchy
	notification_panel.add_child(notification_label)
	notification_panel.add_child(notification_timer)
	
	# Add the panel to our canvas layer
	canvas_layer.add_child(notification_panel)
	
	# Mark as ready
	is_panel_ready = true
	
	# Debug message
	print("Notification panel initialized and added to canvas layer")

# Show notification to the player
func show_notification(message, duration = 2.0):
	# Debug log
	print("show_notification called with message: " + message)
	
	if not is_panel_ready:
		print("Warning: Notification panel not ready yet. Message queued: " + message)
		# Create it if not already done
		call_deferred("create_notification_panel")
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
	
	if not notification_panel or not notification_label:
		print("Error: Notification components are null. Message: " + message)
		return
		
	notification_label.text = message
	notification_panel.visible = true
	notification_timer.wait_time = duration
	notification_timer.start()

func _on_notification_timer_timeout():
	if notification_panel:
		notification_panel.visible = false 
