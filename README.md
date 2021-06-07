# Explode Fight III
master

## Current Tasks
- Pickups and level end postamble
- Redo game and level state machines.
- Add mob info protocol for use with spawning. Make an enum as well with the predefined types of mob already part populated.

## Next Tasks
- Player warp-in state
- Start adding mob experiments on the mob/ branches.
- Add and remove physics properties on recycle and explode.
- Make this build on TVOS as well. Look at the button class and get the focus rings to work. The frameworks will have to have new targets as well.

## Bugs

## Questions
- Shoud I use a GKComponentSystem for rule updates to the level? It's not an entity after all. (Could add entity to the Scene as I did in the other branch possibly)

### Completed Tasks
- Look at reference nodes for interstitials https://stackoverflow.com/questions/36388900/add-skreferencenode-programmatically
- Fix interstit root node crash bug - it seems to be the level label that is causing the crash
- Interstitial root node needed so that if bonus etc is in progress when game over, it can be removed.
- Use the warp sprite to implement the pixel shatter explode as it doesn't seem to alter the physics bounds like a scale does and can be made non-linear.
- Hi Score display 
- Game over, player respawn, life counter and hi score submit
- Need a state machine in the GameScene to stop the gameover state being called while the animation is running still.
- Spawner preload and kill only those nodes which contain entities functionality.
- Create a warpable sprite. __mob/warp__
- Make the reveal text a little more generic
- Spawn pattern protocol and enum (in playground: Developer).
- See if we can do without the GKScene loading.
- Add a Level class and allow snapshots to be calculated so that rules can be implemented.
- Look at irregularities with spawning and recycling with animations and scaling.
- Explode with particle sytem instead of the pixel shatter and make the particle exploder use the spawner mechanism.
- Address the shader compile delay on the first explosion.
- Address texture atlas and explosion shader oddities.
- Add rules for end level and interstial scene / overlay.
- Alter weapon firing source position
- Add online high score table and chieve example.
- Make scoring work and have the scoring count up
- Make pausing work
- Make placeholder sprites for the player and an enemy.
- Think about how contact can be handled without subclassing an entity.
- Make a user-controlled entity and a mob entity or do this using components so that the behaviour can be switched for a demo attract phase.
- User control via GKAgent (movement and shooting). Rejig Mob and Player movement components, possibly remove the subclasses of GKAgent2D
- Sound manager
- Find out why the explosion sound is getting called twice as often as it should be.
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

### Monster Animals
- Zapstar - a tribute to Laser Zone
- GreyFace
- Yip-Yap
- DZ - Digital Zombie

### Level/enemy/chieve ideas
- Stay awhile... stay forever
- Weirding module
- Do-gooder project
- Friendship ended with Mudasir
- Discordian recipe items
- An open letter to Jochen Mass

### Achievements
- Early adopter - play a pre-release version of the game (for testing also).
