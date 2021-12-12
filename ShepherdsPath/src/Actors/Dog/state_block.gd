extends DogState

var leftright: int = 1;

func get_start_point():
    dog.flock_middle

# leftright must be either 1 or -1
func get_point(leftright: int) -> Vector3:
    var dist: float =  Apphandler.player_position.distance_to(dog.flock_middle)
    var p: Vector3 =Apphandler.player_position + Apphandler.player_position.direction_to(dog.flock_middle) * (dist * 0.5)
    p = Apphandler.player_position + (p-Apphandler.player_position).rotated(Vector3(0,1,0),0.6 * leftright)
    p.y = dog.global_transform.origin.y
    return p

    

func override_process(delta: float):
    var p: Vector3 = get_point(leftright)
    dog.get_node("DebugCube").global_transform.origin = p
    dog.look_at(p, Vector3.UP)
    dog.rotate_y(PI) # rotate 180 deg because it's facing the wrong direction ;(
    dog.translate(Vector3.BACK * delta * speed)
    if dog.global_transform.origin.distance_squared_to(p) < 1:
        leftright = -leftright