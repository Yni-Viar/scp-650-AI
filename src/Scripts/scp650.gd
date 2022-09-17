extends Node


#const vel_speed = 0
const rot_speed = 0.01 #rotation
const gravity = 0.3 #gravity speed

var vel = Vector3() #velocity
var timer = 0 
var waiting
var pose
var add_pos = Vector3(0, 0, 2) #need for spawning next to the player

# Called when the node enters the scene tree for the first time.
func _ready(): #used from SkanerSoft's script
	randomize()
	waiting = 5
	Common.scp650 = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var state = $AnimationPlayer.current_animation #state is determined as animation
	timer += delta
	pose = randi() % 8 #random pose
	
	if state == 'Default':
		if self.transform.origin.distance_to(Common.player.transform.origin) < 4:
			print(waiting)
			timer = 0
		else:
			if timer > waiting:
				pass #first look
	
	if state != 'Default':
		if self.transform.origin.distance_to(Common.player.transform.origin) < 4:
			timer = 0
		else:
			if timer > waiting: #now teleport to player
				self.translation = Common.player.transform.origin + add_pos
				match pose:
					0:
						set_state('Pose 1')
					1:
						set_state('Pose 4')
					2:
						set_state('Pose 5')
					3:
						set_state('Pose 6')
					4:
						set_state('Pose 7')
					5:
						set_state('Pose 8')
					6:
						set_state('Pose 9')
					7:
						set_state('Pose 10')
	


func set_state(s): #animation state (from SkanerSoft)
	if $AnimationPlayer.current_animation == s:
		return
	$AnimationPlayer.play(s, 0.3)
	timer = 0
