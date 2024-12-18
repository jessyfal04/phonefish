extends CharacterBody2D

var speed : int = 20000;
var coolDownCatch : float = 0;

var gravity : float = speed / 5;
var inertie : Vector2 = Vector2.ZERO;
var accDeltaRotation : float = 0;
var angleRotationAnimation : float = 0;
var angleRotationCursor : float = 0;

var ploufPlayed : bool = false;

func _physics_process(delta : float) -> void:
	var sprite2D : Sprite2D = $"Sprite2D";
	
	if Input.is_action_pressed("mouseClicked"):
		($"GPUParticles2D" as GPUParticles2D).emitting = true;
		accDeltaRotation += delta * 2;
		
		var deltaDir : Vector2 = get_global_mouse_position() - position;
		if deltaDir.length() >= 64:
			#Inertie
			inertie = deltaDir.normalized() * speed;
			
			#The fish sprite follow the cursor
			angleRotationCursor = atan2(inertie.y, inertie.x);
			sprite2D.rotation = angleRotationCursor;
			
			if !ploufPlayed:
				ploufPlayed = true;
				($"Plouf" as AudioStreamPlayer2D).play();
		
	else:
		#Not clicked, reduce the inertie
		inertie /= 1+delta;
		
		accDeltaRotation += delta;
		($"GPUParticles2D" as GPUParticles2D).emitting = false;
		ploufPlayed = false;
		
	
	#Velocity, intertie and gravity
	var velocity_ : Vector2 = Vector2.ZERO;
	velocity_.y += gravity * delta;
	velocity_ += inertie * delta;
	velocity = velocity_;
	move_and_slide();
	
	#Periodic Rotation
	angleRotationAnimation = sin(accDeltaRotation * PI / 3) * 10;
	sprite2D.rotation = angleRotationCursor;
	sprite2D.rotation_degrees += angleRotationAnimation;
	if (sprite2D.rotation >= PI/2 or sprite2D.rotation <= -PI/2):
		sprite2D.flip_v = true;
	else:
		sprite2D.flip_v = false;
	
	if coolDownCatch > 0:
		coolDownCatch = max(coolDownCatch - delta, 0);
		sprite2D.self_modulate = Color("white") * (1-coolDownCatch) + Color("#a29bfe") * coolDownCatch;
		
	if (Input.is_action_pressed("catch")):
		Input.action_release("catch");
		catch();

func catch() -> void:
	if coolDownCatch <= 0:
		coolDownCatch = 1.0;
		var listNodes : Array = ($"AreaCatch" as Area2D).get_overlapping_bodies();
		for node2D : Node2D in listNodes:
			if node2D.is_in_group("star"):
				node2D.call("die");
				$"..".call("modifyScore", 1);
			elif node2D.is_in_group("urchin"):
				node2D.call("die", false);
				
func _on_area_damage_body_entered(body : Node2D) -> void:
	if body.is_in_group("urchin"):
		body.call("die", true);
		$"..".call("modifyScore", -1);
