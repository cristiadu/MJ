extends Node

# Use autoloaded singletons
@onready var GameState = get_node("/root/GameState")

# Reference to the notification panel
var notification_panel
var notification_label
var notification_timer
var is_panel_ready = false

func _ready():
	# Create notification panel if it doesn't exist
	call_deferred("create_notification_panel")
	
	# Make sure GameState can use the notification system
	if GameState:
		GameState.game_instance = self
		
func create_notification_panel():
	# Create panel
	notification_panel = Panel.new()
	notification_panel.visible = false
	notification_panel.anchors_preset = 5  # Top-center
	notification_panel.anchor_left = 0.5
	notification_panel.anchor_right = 0.5
	notification_panel.offset_left = -200
	notification_panel.offset_top = 50
	notification_panel.offset_right = 200
	notification_panel.offset_bottom = 150
	
	# Create label
	notification_label = Label.new()
	notification_label.layout_mode = 1
	notification_label.anchors_preset = 15  # Full rect
	notification_label.anchor_right = 1.0
	notification_label.anchor_bottom = 1.0
	notification_label.grow_horizontal = 2
	notification_label.grow_vertical = 2
	
	# Set font size correctly
	var font_size = 24
	notification_label.add_theme_font_size_override("font_size", font_size)
	
	notification_label.horizontal_alignment = 1  # Center
	notification_label.vertical_alignment = 1  # Center
	notification_label.text = "Notification Text"
	notification_label.autowrap_mode = 3  # Word wrap
	
	# Create timer
	notification_timer = Timer.new()
	notification_timer.wait_time = 2.0
	notification_timer.one_shot = true
	notification_timer.timeout.connect(_on_notification_timer_timeout)
	
	# Add all to hierarchy
	notification_panel.add_child(notification_label)
	notification_panel.add_child(notification_timer)
	
	# Add to scene tree
	add_to_scene_tree()
	
	# Mark as ready
	is_panel_ready = true
	
	# Debug message
	print("Notification panel initialized and added to scene tree")

func add_to_scene_tree():
	# Add panel to HUD if it exists, otherwise to this node
	var game_node = get_node_or_null("/root/Game")
	if game_node:
		var hud = game_node.get_node_or_null("HUD")
		if hud:
			hud.add_child(notification_panel)
			print("Added notification panel to HUD")
			return
	
	# Fallback: add to this node
	add_child(notification_panel)
	print("Added notification panel to NotificationHandler node")

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