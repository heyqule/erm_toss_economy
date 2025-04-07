# ERM Protoss Economy
This mod is an internal library to share protoss economy features between protoss enemy mods. It provides a workflow to get biter egg if the player doesn't play with biter enemy at all.  

This mod does not add prototype or handle game logic by itself.  It's done in the enemy mod that uses this.

# Features:
- Added protoss crystal item.
- Added recipe to duplicate protoss crystal (Electromagnetic Plant).
- Added recipe to convert crystal to biter egg (Biochamber).
- Added recipe to produce uranium-238 with larva egg (New Assembly machine: Plasma Assembling Machine)
- Added technology to unlock playable protoss units.
- Added Nexus for player to build nexus units.
- Added zealot, dragoon, darktemplar, scout, corsair, arbiter as playable units.
- Added protoss damage research to upgrade their damage (10 x 20%).

# Implementation Guide
See erm_protoss's prototypes/economy.lua

