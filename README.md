# Explode Fight III
master

## Current Tasks
- Find out why the explosion sound is getting called twice as often as it should be.
- Add a Level class and allow snapshots to be calculated so that rules can be implemented.
- Spawned entities have to be counted in the snapshot.
- Spawner preload and kill only those nodes which contain entities functionality.

## Questions
- Shoud I use a GKComponentSystem for rule updates to the level? It's not an entity after all. (Could add entity to the Scene as I did in the other branch possibly)

## Next Tasks
- Make a user-controlled entity and a mob entity or do this using components so that the behaviour can be switched for a demo attract phase.
- Think about how contact can be handled without subclassing an entity.
- Make placeholder sprites for the player and an enemy.
- Start adding mob experiments on the mob/ branches.
- Make this build on TVOS as well. Look at the button class and get the focus rings to work. The frameworks will have to have new targets as well.

### Completed Tasks
- Add rules for a demo: maintain the number of Mobs at 10 until 100 total have been spawned.
- Allow mobs to be cleanly destroyed on contact with a bullet, update facts on mob deaths.
- Check spawner performance with 250 mobs.
- Lifecycle state machine with deaths on __exp/deadstate__.
- Rework spawners on branch __exp/spawner__.
- Decide if we need to calculate the distances like the DemoBots does, leave it as a callable function outside the init for now. (moved to BaseSKScene).
- SKLabelNode replacement with sprite or tilemap optimisations.
- Make move, fire and possibly render components.
- Check if the player entity can be given an agent in the editor. (Causes scene to be unable to load Xcode 12.4)
- Shotting experiments on branch __exp/shoot__.
- Rules and state machine experiments on branch __exp/rules__.
- Rules and state machine experiments on branch __exp/mechanics__.
- Spawn experiments on branch __exp/spawner__.
- Sprite atlas performance experiments (branch off from the old one that has many robots) on branch __exp/spawner__.
- Button experiments on branch __exp/buttons__.
- Shader and explosion experiments on __exp/shaders__.
- Touch joystick experiments on __exp/joystick__.
- Abstract out a base class for the scenes involved in the attract phase, allow them to rotate with timing or select or start the game from any displayed phase quickly.
- Extend SKScene to clone a node with a specified name and then remove it from its parent.
- Move configuration components from splash scene to somewhere more appropriate.
- Device screen size independance. Placing of components such as HUD bits with expanded playfield on larger devices.
- User defaults and static configuration along with templates as a reminder.
- See what other things I had working in Royal Flush and move them into here should they be useful.
- Get the robot animation back in and remind myself of how animations and sprites are loaded from sks files.
- Make the viewcontroller load an SKScene rather than a GKScene to avoid the problems with the sprite editor.
- Look at making SceneManager functions an extension, perhaps on SKView.
- Move the spawner and the other functions to the framework from RF.
- Explosion shaders inception.

### Notes
- Where are EFI and EFII? Never made it lads.

### Resources
https://code.bitbebop.com/spritekit-game-aspect-ratio-resolution/ - Device screen size independance example.
https://kenney.nl - Free game assets  
https://developer.apple.com/library/archive/documentation/General/Conceptual/GameplayKit_Guide/StateMachine.html - State machine info  

### Story
Robotron & crystal quest crossover with retro influences and references to some of the older games on the commodore and the SNES.  
Decided to save the Lovecraft related content for another game coming in the future.

### Monster Animals
- (tba) Shoggoth - eyes fall off on damage and can be picked up. Rather like the dumpfers in cq.
- Zapstar - a tribute to Minter

### Level/enemy/chieve ideas
- Stay awhile... stay forever
- Weirding module
- Do-gooder project
- Friendship ended with Mudasir

### Achievements
- Tekeli-li - collect 5 shoggoth eyes in a level.
