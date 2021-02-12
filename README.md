# Explode Fight III
exp/shoot

## Current Tasks
- Have some different types of weapon depending on what is set in the FireComponent parameter.
- Decide on how I am going to change the type of bullet fired and the type of the weapon it's fired from.
- See if contact detection can be done without physics body (already thought about this in the SKAction section, it seems).
- Decide which of the methods I have thought of already are worth investigating and if there are others that I haven't thought of.

### Done
- Discover why the bullet is offset from the centre in the current weapon setup. (Just an oddity in the sprite graphic I think)

### SKAction driven
- I think this might be the most efficient.
- Can collision be detected and the node be removed after the collision but before the end of the action?

### Physics driven
- Might this be less efficient?
- Could this be saved for missile projectiles?

### GKAgent driven
- Somewhat more complex possibly?
- Has the advantage that it will allow in flight changes to the missile trajectory
- Might be useful for 'smart' weaponry.

### DONE
