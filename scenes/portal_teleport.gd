extends Area3D

@onready var destination = $"..".portal_destination
@onready var parent : Node3D = $".."
	
	
func _on_teleport_zone_entered(body : PhysicsBody3D):
	#Only tp if the body is moving towards the portal
	if body.velocity.dot(parent.transform.basis.z) < 0:
		#Compute the local offset to the center of the entrance portal
		var portal_rot_axis = parent.transform.basis.z.cross(Vector3.FORWARD).normalized()
		var portal_rot_angle = acos(parent.transform.basis.z.dot(Vector3.FORWARD))
		var local_offset = (body.global_position - parent.global_position).rotated(portal_rot_axis, portal_rot_angle)
		
		#Convert this offset to a local offset to the other portal and move
		var destination_rot_axis = Vector3.FORWARD.cross(destination.transform.basis.z).normalized()
		var destination_rot_angle = acos(destination.transform.basis.z.dot(Vector3.FORWARD))
		var destination_offset = local_offset.rotated(destination_rot_axis, destination_rot_angle)
		body.global_position = destination.global_position + destination_offset
		
		#Compute the local rotation to the entrance portal
		var rot_to_portal = parent.global_transform.basis.inverse() * body.global_transform.basis
		var new_rot = destination.global_transform.basis.rotated(Vector3.UP, deg_to_rad(180)) * rot_to_portal
		
		body.global_basis = new_rot


