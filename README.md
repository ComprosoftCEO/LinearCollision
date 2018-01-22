# Linear Collision
## Photon in a Gauntlet of Doom

<br/>

## About
You are a photon trapped in a colorful maze. Your goal is to collect the four colored orbs scattered throughout the maze (red, yellow, green, and blue), then exit through the portal that appears. However, it is not that easy. Enemy photons are constantly shooting across the maze, threatening to destory you if you touch one of them. In addition, the clock is ticking down, and if it runs out it's Game Over. How far can you get in the Gauntlet of Doom?

<br/>

## How to Play
Press __Start__ to Play the game. Using the __Control Pad__, navigate around the maze to collect the 4 energy orbs and make it to the exit portal. You can also press the __A__ button at any time to turn invisible, but you have a limited number of invisibility power-ups (as indicated by a counter on the status bar). You get one invisibility power-up for every level that you clear. If you hit an enemy photon, the energy orbs are reset and you respawn in your origional position. When the clock runs out, it is Game Over.

_Challenge: See if you can discover the secret cheat code..._

<br/>

## How to Compile
Linear Collision uses NESASM3.exe to compile the assembly code into a NES rom.

To compile, run compile.bat on Windows, or compile.sh on Linux. When compiling on Linux, make sure [Wine](https://www.winehq.org/) is installed so that NESASM3 runs properly.

<br/>

## Source Layout
The source code is broken into logical folders to help make it easier to understand.
* __Audio__ - Music and sound, along with Metal Slime's sound engine code
* __Data__ - Raw binary data (like map layouts, title screen, text, etc.)
* __Macros__ - Not code, but used by NESASM3 to generate code, similar to C++ templates or the C preprocessor
* __Scripts__ - Additional code files to aid the main game
* __Utilities__ - Programs that aid the development of Linear Collision

<br/>

## Utilities
Various programs in the Utilities directory were used to aid the development of Linear Collision. Below is a breif summary of each one:
* __Build Maze__ - Used to generate the Raw tile data for the origional map (before multiple map support was added)
* __Demo__ - Gameplay demo programmed using GameMaker 8 to playtest the game before development
* __GenerateLookupTable__ - Aids the creation of a lookup table used by the map loader to generate the map outline.
    * Maps are stored in binary, so the lookup table is used to convert binary into tiles that outline the map.
* __MapBuilder__ - Very powerful tool to develop a Linear Collision map.
  * _You can use this to create your own in-game map layouts._
* __TextToHex__ - Convert text characters into the character data ASCII characters
* __Tile Generator__ - I used this to build the title screen using GameMaker's tile layout utility

<br/>

## Cartridge Details
In case you want to burn a physical NES cartridge, Linear Collision uses NES Mapper 0 (NROM) with 32K of program data and 8K of character data. However, only 4K of the character data is used.

<br/>

## Special Thanks To:
* [Nerdy Nights Tutorials](http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=7155)
* [NES Dev Wiki](http://wiki.nesdev.com/w/index.php/Nesdev_Wiki)
* Metal Slime's [Sound Engine Tutorial](http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=22487)
* David Estrada for composing the music and sound
* My family for support
