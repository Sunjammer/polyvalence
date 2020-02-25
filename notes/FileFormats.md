# LICENSING ###################################################################

   To the extent possible under law, I, Alison Sanderson, have waived all
   copyright and related or neighboring rights to this Document as described
   by the Creative Commons Zero license linked below.

   <http://creativecommons.org/publicdomain/zero/1.0/>

   All of the information in this Document is original research. Marathon and
   Forge are owned by Bungie, Inc. QuickDraw, QuickTime and Macintosh are owned
   by Apple. Aleph One (also referred to as A1 in this Document) is owned by
   Bungie, Inc. et al. Igni Ferroque, Ferro, and Atque are owned by Gregory
   Smith (treellama.) Maraiah is owned by Project Golan. Any other copyrights
   belong to their respective owners.

# CONTENTS ####################################################################

   | Title         | Description                                              |
   | -----         | -----------                                              |
   | LICENSING     | The license this document is under.                      |
   | CONTENTS      | This table of contents.                                  |
   | TERMINAL CODE | Info on terminal definition files.                       |
   | CHUNK TYPES   | Chunk types used throughout Marathon.                    |
   | STRUCTURES    | Structure types used throughout Marathon.                |
   | ENUMERATIONS  | Names for integers used in Marathon's structures.        |
   | FLAGS         | Names for bit field flags used in Marathon's structures. |

   You can scroll through sections of this document by searching for `/^# /`.
   Specific sections can be searched by their name here.


# TERMINAL CODE ###############################################################

   The terminal definition format is extremely straightforward.
   Terminal commands begin lines and are in the format:

```
   #COMMAND_NAME parameters
```

   In Forge and Maraiah, commands need not be uppercase.
   Atque does require all commands to be uppercase.

   Comments also begin lines (they can't be after the beginning of one) and
   will disable any text proceeding them. They are formed like:

```
   ; comment content here
```

   Terminals are numbered, and this is used in the map to determine which
   terminal to display when a computer is used.

## Blocks ##

### Terminal Blocks ###

   The number for the terminal being currently defined is set with
   the `#TERMINAL` and `#ENDTERMINAL` commands. These are formed as:

```
   #TERMINAL number
   #ENDTERMINAL number
```

   For example, defining a terminal numbered "1" would be:

```
   #TERMINAL 1

   ; terminal's contents here

   #ENDTERMINAL 1
```

### Sections ###

   There are four possible sections in a terminal, which are between
   the `#TERMINAL` and `#ENDTERMINAL` blocks:

```
   #UNFINISHED
   #FINISHED
   #FAILURE
   #SUCCESS
```

   These all mark the start of where the terminal will display, depending on
   the current status of your mission.

   | Name         | Will display when                                         |
   | ----         | -----------------                                         |
   | `UNFINISHED` | your objective has not been met or no other block exists  |
   | `FINISHED`   | you have succeeded or failed                              |
   | `FAILURE`    | you have failed your objective                            |
   | `SUCCESS`    | you have succeeded in your objective                      |

   Sections must have an end, which is defined with:

```
   #END
```

   Between sections may be any amount of regular commands.
   There are two kinds of these normal commands: Text commands, and interactive
   commands.

## Text Commands ##

   All text commands may have (but do not require) text following them,
   which may be formatted.

   Line breaks will break in-game, but unbroken lines will automatically wrap.
   It is generally best to just put all of your text onto one line, even if
   this destroys your sanity. Use a text editor with line wrapping for this.

   Example:

```
   #PICT 10007
   ~text interface terminal malfunction error ~2992dud

   welcome to mabmap i am durandal the most pretty ai in ever i made the pfhor ded and won all the everything you should go shoot some things I put here because reasons
```

### Formatting ###

   Text effects are designated by a '$' and then one of the following:

   | $-code | Effect                                                          |
   | ------ | ------                                                          |
   | `I/i`  | enables/disables italic text                                    |
   | `B/b`  | enables/disables bold text                                      |
   | `U/u`  | enables/disables underlined text                                |
   | `Cn`   | changes the text color, where "n" is a number 0 through 9       |

   For more information on colors, see section ENUMERATIONS, Terminal Color.

   Example:

```
   $C1$BoOooO$IooOOoo$i$b$C0 ... $C6did I $Uspook$u you?$C0
```

### Text Command Overview ###

   Text commands include:

```
   #PICT pict_id alignment
   #LOGON pict_id
   #LOGOFF pict_id
   #INFORMATION
   #CHECKPOINT goal_id
   #BRIEFING level_number
```

### `#PICT` ###

```
   #PICT pict_id alignment
```

   `#PICT` is the most basic and most used command throughout M2 and Infinity.

   It displays a picture to the specified alignment and text to the other side.

   It will:
   * Wait for input before proceeding.
   * Display 45 characters per line, and display up to 22 lines on one page.
   * Display text aligned to the left on the right side of the screen.

   If alignment is specified as RIGHT, text is aligned to the right
   on the left of the screen. If alignment is specified as CENTER, no text may
   be displayed, only an image. If no alignment is specified, it will default
   to an image on the left and text on the right.

   Example:

```
   #PICT 10007
   ~text interface terminal malfunction error ~2992dud

   hellote this is example text from durnadle prettiest ai in ever thank u for reading goodbye
```

### `#LOGON`, `#LOGOFF` ###

```
   #LOGON pict_id
   #LOGOFF pict_id
```

   `#LOGON` and `#LOGOFF` are generally used first and last in a terminal.

   These two display a PICT in the middle of the screen and text below the
   image if you supply it. They both do things to the screen borders.

   They will:
   * Automatically continue, an input will interrupt it.
   * Only display one line of text, at most 72 characters.
   * Display text aligned to the center in the middle of the screen.

   Example:

```
   #LOGON 1600
   <CMND PRAMA &681g1>
   ; ... content ...
   #LOGOFF 1600
   ehhg.431.4122//<PFGR ZNE6 &49c2>
```

### `#INFORMATION` ###

```
   #INFORMATION
```

   `#INFORMATION` will just display text, and is mostly used in Marathon 1.

   It will:
   * Wait for input before proceeding.
   * Display 72 characters per line, and display up to 22 lines on one page.
   * Display text aligned to the left on the left side of the screen.

   Example:

```
   #INFORMATION
   you suck at videogames love durandal
   p.s. if you don't win i'm erasing your home planet from existence
```

### `#CHECKPOINT` ###

```
   #CHECKPOINT goal_id
```

   `#CHECKPOINT` may only be used in M1, unless you're using Aleph One 1.1+.

   This shows a map centered on the specified goal point, with the goal
   circled, on the left of the screen.

   The map will only show polygons connected to the polygon the goal is in,
   so if you have a separated area where the goal point is, it will only
   display that. It will also not display secret areas and any polygons
   proceding them.

   It will:
   * Wait for input before proceeding.
   * Display 45 characters per line, and display up to 22 lines on one page.
   * Display text aligned to the left on the right side of the screen.

   Example:

```
   #CHECKPOINT 7
   go shoot these things so i can claim this victory as mine forever and tell you about the things that i totally shot for approximately 200 years
```

### `#BRIEFING` ###

```
   #BRIEFING level_number
```

   BRIEFING may only be used in Marathon 1. It is identical to INFORMATION,
   but after you're done reading, it will teleport you to the specified level.

## Interactive Commands ##

   Interactive commands are all actions carried out by the game that
   do not all effect the active terminal.

### Interactive Command Overview ###

   Interactive commands include:

```
   #INTERLEVEL TELEPORT level_number
   #INTRALEVEL TELEPORT polygon_tag
   #TAG tag
   #SOUND sound_number
   #STATIC duration
```

### `#INTERLEVEL TELEPORT` ###

```
   #INTERLEVEL TELEPORT level_number
```

   `#INTERLEVEL TELEPORT` exits the terminal and teleports you to the
   specified level. If the level number is "256", this ends the game.

   Example:

```
   #INTERLEVEL TELEPORT 7
```

### `#INTRALEVEL TELEPORT` ###

```
   #INTRALEVEL TELEPORT polygon_tag
```

   `#INTRALEVEL TELEPORT` exits the terminal and teleports you to the centroid
   of the specified polygon within the map.

   Example:

```
   #INTRALEVEL TELEPORT 77
```

### `#TAG` ###

```
   #TAG tag
```

   `#TAG` activates all lights and platforms with the specified tag.

   Example:

```
   #TAG 77
```

### `#SOUND` ###

```
   #SOUND sound_number
```

   `#SOUND` plays the specified sound from the Sounds file or from the
   Scenario/Map file.

   Example:

```
   #SOUND 77
```

### `#STATIC` ###

```
   #STATIC duration
```

   `#STATIC` fills the terminal with TV static for the specified duration in
   1/30ths seconds. Aleph One only.

   Example:

```
   #STATIC 60
```


# CHUNK TYPES #################################################################

## Scenarios (`.sceA`, `.scen`) ##

   | Name   | Description                                                     |
   | ----   | -----------                                                     |
   | `PNTS` | Array of Points                                                 |
   | `LINS` | Array of Lines                                                  |
   | `SIDS` | Array of Sides                                                  |
   | `POLY` | Array of Polygons                                               |
   | `LITE` | Array of Lights                                                 |
   | `NOTE` | Not analyzed (annotations)                                      |
   | `OBJS` | Array of Objects                                                |
   | `p'th` | No test data (' is $8C) (guardpaths)                            |
   | `Minf` | Static Map Info                                                 |
   | `plac` | Not analyzed (item placement)                                   |
   | `door` | No test data (extra door data)                                  |
   | `plat` | No test data (platform static data)                             |
   | `EPNT` | Array of Endpoints                                              |
   | `medi` | Not analyzed (media)                                            |
   | `ambi` | Not analyzed (ambient sounds)                                   |
   | `bonk` | No test data (random sounds)                                    |
   | `term` | Array of Terminals                                              |
   | `iidx` | Not analyzed (map indices)                                      |

   Map files can be identified by the Minf chunk.

   Map files will always have either a PNTS or EPNT chunk, depending on what
   the map (and editor) use. PNTS are plain and have no more information than
   the actual position, while EPNT has flags and some extra stuff to help the
   engine load quicker (not that it needs it.)

## Images (`.imgA`, `.imgs`) ##

   | Name   | Description                                                     |
   | ----   | -----------                                                     |
   | `PICT` | Picture Resource                                                |
   | `clut` | Unused?                                                         |

   Images can be identified by the PICT chunk.

## Physics (`.phyA`, `.phys`) ##

   Not analyzed

## Shapes (`.shpA`, `.shps`, `.ShPa`) ##

   Not analyzed

## Sounds (`.sndA`, `.sndz`) ##

   Not analyzed

## Save Game (`.sgaA`) ##

   Not analyzed

## Film (`.filA`) ##

   Not analyzed


# STRUCTURES ##################################################################

   All integers here are big-endian unless specified.

## Wad ##

### Wad File ###

   Wad files are structured like:
   * Wad Header
   * Entries/Chunks
   * Directory

   It *must* be in this order because the engine assumes that the data directly
   after the 128th byte is entry data.

### Wad Header ###

   The Wad header is always at the very beginning of the file, except when
   it's a MacBin file or an AppleSingle file, in which case it's at the start
   of the resource fork. You'll have to account for that yourself. An example
   of a proper header loader that handles both is attached.

   The Wad Header is 128 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Wad Version                                       | WadVer     |
   | u16     | Data Version                                      | DataVer    |
   | u8[64]  | Original filename, null byte terminated           | OrigName   |
   | u32     | Checksum of entire file with this value as 0      | CRC        |

   If WadVer is greater than or equal to VerDir:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | Directory offset                                  | DirOfs     |
   | u16     | Number of entries in this file                    | NumEntries |
   | u16     | Bytes to skip for each directory entry            | AppData    |
   | u16     | Size of chunks                                    | ChunkSize  |
   | u16     | Size of directory entries                         | EntrySize  |

   ChunkSize and EntrySize may be zero, in which case it will default to
   16 and 10 respectively. They exist for forward compatibility with Wad
   patching, although are actually pointless and serve no practical purpose.

   If WadVer is greater than or equal to VerOver:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | Checksum of the file we are modifying (if any)    | ParentCRC  |

### Directory Entry ###

   Following this structure is AppData bytes (N), supposed to be used by
   editor applications for storing arbitrary extra data, and will be ignored by
   the engine.

   Directory Entry is 8 bytes if WadVer is VerBase, or EntrySize+AppData bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | Offset to start of data (from start of file)      | Offset     |
   | u32     | Length of entry data                              | Size       |

   If WadVer is greater than or equal to VerDir:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Index of entry                                    | Index      |
   | u8[N]   | Application specified data                        | AppData    |

### Chunk ###

   Most Wad entries are made up of tagged data formats, the engine assumes
   this for every entry and so every entry has at least one chunk.
   These are similar to IFF or PNG chunks.

   Chunk is 12 bytes if WadVer is VerBase, or ChunkSize bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u8[4]   | Chunk name (no null byte)                         | Ident      |
   | u32     | Absolute file offset of next chunk (-file header) | Offset     |
   | u32     | Size of chunk (not including the header)          | Size       |

   If WadVer is greater than or equal to VerDir:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | TODO                                              |            |

## Map ##

### LtFn ###

   Light function specification.

   LtFn is 14 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Function index                                    |            |
   | u16     | Period                                            |            |
   | u16     | Delta period                                      |            |
   | u16     | Intensity (high)                                  |            |
   | u16     | Intensity (low)                                   |            |
   | u16     | Delta intensity (high)                            |            |
   | u16     | Delta intensity (low)                             |            |

### SideTex ###

   Just stores a texture and an offset.

   SideTex is 6 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | i16     | X offset                                          | OffsX      |
   | i16     | Y offset                                          | OffsY      |
   | u16     | Texture ID (shape descriptor)                     | TextureId  |

### Point ###

   A geometric point.

   Point is 4 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | i16     | X position                                        | X          |
   | i16     | Y position                                        | Y          |

### Endpoint ###

   More advanced point structure.

   Endpoint is 16 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Endpoint flags                                    |            |
   | i16     | Highest adjacent floor height                     |            |
   | i16     | Lowest adjacent ceiling height                    |            |
   | Point   | Position                                          |            |
   | Point   | Transformed position                              |            |
   | u16     | Supporting polygon index                          |            |

### Line ###

   A geometric line segment.

   Line is 32 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Beginning endpoint                                |            |
   | u16     | Terminating endpoint                              |            |
   | u16     | Line flags                                        |            |
   | u16     | Length                                            |            |
   | u16     | Highest adjacent floor height                     |            |
   | u16     | Highest adjacent ceiling height                   |            |
   | u16     | Index of polygon side in front                    |            |
   | u16     | Index of polygon side in back                     |            |
   | u16     | Index of polygon owner in front                   |            |
   | u16     | Index of polygon owner in back                    |            |

### Side ###

   One side of a line segment.

   Side is 64 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Side type                                         |            |
   | u16     | Side flags                                        |            |
   | SideTex | Primary texture                                   |            |
   | SideTex | Secondary texture (TODO: explain magic)           |            |
   | SideTex | Transparent texture (not drawn if empty)          |            |
   | Point   | Collision top-left                                |            |
   | Point   | Collision top-right                               |            |
   | Point   | Collision bottom-left                             |            |
   | Point   | Collision bottom-right                            |            |
   | u16     | Control panel type                                |            |
   | i16     | Control panel permutation                         |            |
   | u16     | Primary texture transfer mode                     |            |
   | u16     | Secondary texture transfer mode                   |            |
   | u16     | Transparent texture transfer mode                 |            |
   | i32     | Ambient delta (used by engine???)                 |            |

### Polygon ###

   A geometric polygon, essentially Doom's "sector," but must be convex.

   Polygon is 128 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Polygon type                                      |            |
   | u16     | Polygon flags                                     |            |
   | i16     | Permutation (see polygon types)                   |            |
   | u16     | Vertex count                                      |            |
   | u16[8]  | Endpoint indices (clockwise)                      |            |
   | u16[8]  | Line indices                                      |            |
   | u16     | Floor texture (shape descriptor)                  |            |
   | u16     | Ceiling texture (shape descriptor)                |            |
   | i16     | Floor height                                      |            |
   | i16     | Ceiling height                                    |            |
   | u16     | Floor lightsource index                           |            |
   | u16     | Ceiling lightsource index                         |            |
   | i32     | Area (exponent of 2)                              |            |
   | u16     | First object in polygon                           |            |
   | u16     | First exclusion zone                              |            |
   | u16     | Number of line exclusion zones                    |            |
   | u16     | Number of point exclusion zones                   |            |
   | u16     | Floor transfer mode                               |            |
   | u16     | Ceiling transfer mode                             |            |
   | u16[8]  | Adjacent polygon indices                          |            |
   | u16     | Index of first neighboring polygon                |            |
   | u16     | Number of neighboring polygons                    |            |
   | i16     | Center X                                          |            |
   | i16     | Center Y                                          |            |
   | u16[8]  | Side indices                                      |            |
   | i16     | Floor origin X                                    |            |
   | i16     | Floor origin Y                                    |            |
   | i16     | Ceiling origin X                                  |            |
   | i16     | Ceiling origin Y                                  |            |
   | u16     | Media index                                       |            |
   | u16     | Media lightsource index                           |            |
   | u16     | Sound for polygon                                 |            |
   | u16     | Ambient sound for polygon                         |            |
   | u16     | Random sound for polygon                          |            |

### Light ###

   Light is 77 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Light type                                        |            |
   | u16     | Light flags                                       |            |
   | i16     | Initial phase                                     |            |
   | LtFn[6] | Primary/secondary/becoming active, and inactive   |            |
   | u16     | Tag                                               |            |

### Object ###

   Object is 16 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Saved object group                                |            |
   | u16     | Saved object index                                |            |
   | u16     | Facing angle                                      |            |
   | u16     | Polygon index                                     |            |
   | i16     | X                                                 |            |
   | i16     | Y                                                 |            |
   | i16     | Z                                                 |            |
   | u16     | Map object flags                                  |            |

### Static Map Info ###

   Static Map Info is 88 bytes.

   | Type    | Description                                     | Name         |
   | ----    | -----------                                     | ----         |
   | u16     | Environment Code                                | EnvCode      |
   | u16     | Physics model                                   | PhysicsId    |
   | u16     | Music number                                    | MusicId      |
   | u16     | Mission Flags                                   | MissionFlags |
   | u16     | Environment Flags                               | EnvFlags     |
   | 8 bytes | Unused                                          |              |
   | u8[66]  | Level name                                      | Name         |
   | u32     | Entry point flags                               | EntryFlags   |

## Terminal ##

### Terminal ###

   Terminal text can be encoded with some weird xor bullshit for some reason.
   You can decode it and encode it with the same method:

```c
   for(i = 0; i < len / 4; i++) {p += 2; *p++ ^= 0xFE; *p++ ^= 0xED;}
   for(i = 0; i < len % 4; i++) *p++ ^= 0xFE;
```

   * Terminal Header
   * Terminal Groups
   * Text Faces
   * Terminal text (null byte terminated)

### Terminal Header ###

   Terminal Header is 10 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Total length of terminal (including header)       | Size       |
   | u16     | Terminal flags                                    | Flags      |
   | u16     | Lines per page (almost always 22)                 | PageLines  |
   | u16     | Number of terminal groups                         | NumGroups  |
   | u16     | Number of text faces                              | NumFaces   |

### Terminal Group ###

   Terminal Group is 12 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | TODO                                              |            |
   | u16     | Terminal group type                               |            |
   | i16     | Permutation                                       |            |
   | u16     | Index into text for the start of this group       |            |
   | u16     | Length of this group's text                       |            |
   | u16     | TODO                                              |            |

### Text Face ###

   Text Face is 6 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Index into the text for the start of this face    |            |
   | u16     | TODO                                              |            |
   | u16     | Terminal color                                    |            |

## Images ##

### Picture Resource ###

   Pictures are formed with a header and then a variable number of operations.
   In other words, a small state machine is used to form an image through
   effects and various fill instructions. QuickDraw is horrifying. This is the
   native image format. It's a fucking metafile.

   * Picture Header
   * Picture Opcodes

### Picture Header ###

   All QuickDraw PICTs begin with a basic 10 byte header as follows.

   | Type    | Ignored | Description                             | Name       |
   | ----    | :-----: | -----------                             | ----       |
   | u16     | Yes     | Size                                    | Size       |
   | u16     | Yes     | Y start                                 | Top        |
   | u16     | Yes     | X start                                 | Left       |
   | u16     | No      | Height                                  | Height     |
   | u16     | No      | Width                                   | Width      |

### CopyBits ###

   If direct copy:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | Relative base address (ignored)                   | BaseAddr   |

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Row bytes (upper 2 bits are CopyBits Flags)       | Pitch      |
   | u16     | Y start                                           | Top        |
   | u16     | X start                                           | Left       |
   | u16     | Y end                                             | Bottom     |
   | u16     | X end                                             | Right      |

   If PICT2:
   * PixMap

   Else:
   * assume pack type is default and bit depth is 1

   If packed pixmap:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u32     | Identifier of color table (ignored in A1)         | ClutId     |
   | u16     | Color table flags                                 | ClutFlags  |
   | u16     | Number of color table entries (N)                 | ClutNum    |
   | Clut[N] | Color lookup table                                | Clut       |

   The following are ignored in Aleph One:

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Source y start                                    | SrcTop     |
   | u16     | Source x start                                    | SrcLeft    |
   | u16     | Source y end                                      | SrcBottom  |
   | u16     | Source x end                                      | SrcRight   |
   | u16     | Destination y start                               | DstTop     |
   | u16     | Destination x start                               | DstLeft    |
   | u16     | Destination y end                                 | DstBottom  |
   | u16     | Destination x end                                 | DstRight   |
   | u16     | Transfer mode                                     | XferMode   |

   If clip:
   * Clip Region (skipped the same way as opcode $0001 in A1)

   Image data follows.

### PixMap ###

   PixMap is 36 bytes.

   | Type    | Ignored | Description                             | Name       |
   | ----    | :-----: | -----------                             | ----       |
   | u16     | Yes     | Version (unused)                        | Version    |
   | u16     | No      | Packing type                            | PackType   |
   | u32     | Yes     | Packed size                             | PackSize   |
   | u32     | Yes     | Horizontal DPI                          | HorzDPI    |
   | u32     | Yes     | Vertical DPI                            | VertDPI    |
   | u16     | Yes     | Pixel type                              | Format     |
   | u16     | No      | Pixel bit depth                         | BitDepth   |
   | u16     | Yes     | Number of components                    | Components |
   | u16     | Yes     | Component depth                         | CompDepth  |
   | u32     | Yes     | Plane offset                            | PlaneOffs  |
   | u32     | Yes     | Color table id                          | ClutId     |
   | 4 bytes | Yes     | Unused                                  |            |

### Clut ###

   Clut is 8 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | i16     | Index (if device mapping, used as value)          | Index      |
   | u16     | Red magnitude                                     | R          |
   | u16     | Green magnitude                                   | G          |
   | u16     | Blue magnitude                                    | B          |

### Header Op ###

   Header Op is 24 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Header version                                    | Version    |
   | 2 bytes | Unused                                            |            |
   | u32     | Horizontal resolution                             | Width      |
   | u32     | Vertical resolution                               | Height     |
   | u16     | Y start                                           | Top        |
   | u16     | X start                                           | Left       |
   | u16     | Y end                                             | Bottom     |
   | u16     | X end                                             | Right      |
   | 4 bytes | Unused                                            |            |

### QuickTime Image ###

   TODO

   * 68 bytes

   if matte:
   * U32: matte ID size
   * matte id size - 4 bytes

   * U32: id size
   * char[4]: codec type
   * 36 bytes
   * U32: data size
   * 38 bytes
   * image data follows
   * some other bullshit

# ENUMERATIONS ################################################################

   Here is a list of names and descriptions for enumerations used throughout
   this document. The names may not match those used in the original engine
   and are re-named for clarity of purpose.

### Picture Opcode ###

   Operations used in QuickDraw images. Aleph One ignores most of these, so
   it's only necessary to document what's ignored and how to process CopyBits.
   (If you're interested in the QuickDraw format, Apple has legacy documents
   still available on the Internet.)

   Opcodes `$0100` through `$7FFF` are skipped by seeking forward by
   the most significant byte's value times two.

   Opcodes `$8000` through `$8100` are reserved and therefore ignored.

   Any unspecified opcodes are not worth skipping, and the state machine should
   exit upon reading them.

   | Value   | Ignored | Extra data                     | Name                |
   | -----   | :-----: | ----------                     | ----                |
   | `$0000` | No      | None                           | No-op               |
   | `$0001` | Yes     | u16 size, (size&~1)-2 bytes    | Clip                |
   | `$0002` | Yes     | 8B                             | BkPat               |
   | `$0003` | Yes     | 2B                             | TxFont              |
   | `$0004` | Yes     | 2B                             | TxFace              |
   | `$0005` | Yes     | 2B                             | TxMode              |
   | `$0006` | Yes     | 4B                             | SpExtra             |
   | `$0007` | Yes     | 4B                             | PnSize              |
   | `$0008` | Yes     | 2B                             | PnMode              |
   | `$0009` | Yes     | 8B                             | PnPat               |
   | `$000A` | Yes     | 8B                             | FillPat             |
   | `$000B` | Yes     | 4B                             | OvSize              |
   | `$000C` | Yes     | 4B                             | Origin              |
   | `$000D` | Yes     | 2B                             | TxSize              |
   | `$000E` | Yes     | 4B                             | FgColor             |
   | `$000F` | Yes     | 4B                             | BgColor             |
   | `$0010` | Yes     | 8B                             | TxRatio             |
   | `$0011` | Yes     | 2B                             | VersionOp           |
   | `$0015` | Yes     | 2B                             | PnLocHFrac          |
   | `$0016` | Yes     | 2B                             | ChExtra             |
   | `$001A` | Yes     | 6B                             | RGBFgCol            |
   | `$001B` | Yes     | 6B                             | RGBBkCol            |
   | `$001C` | Yes     | None                           | HiliteMode          |
   | `$001D` | Yes     | 6B                             | HiliteColor         |
   | `$001E` | Yes     | None                           | DefHilite           |
   | `$001F` | Yes     | 6B                             | OpColor             |
   | `$0020` | Yes     | 8B                             | Line                |
   | `$0021` | Yes     | 4B                             | LineFrom            |
   | `$0022` | Yes     | 6B                             | ShortLine           |
   | `$0023` | Yes     | 2B                             | ShortLineFrom       |
   | `$002D` | Yes     | 10B                            | LineJustify         |
   | `$002E` | Yes     | 8B                             | GlyphState          |
   | `$0030` | Yes     | 8B                             | FrameRect           |
   | `$0031` | Yes     | 8B                             | PaintRect           |
   | `$0032` | Yes     | 8B                             | EraseRect           |
   | `$0033` | Yes     | 8B                             | InvertRect          |
   | `$0034` | Yes     | 8B                             | FillRect            |
   | `$0038` | Yes     | None                           | FrameSameRect       |
   | `$0039` | Yes     | None                           | PaintSameRect       |
   | `$003A` | Yes     | None                           | EraseSameRect       |
   | `$003B` | Yes     | None                           | InvertSameRect      |
   | `$003C` | Yes     | None                           | FillSameRect        |
   | `$0098` | No      | CopyBits                       | PackBitsRect        |
   | `$0099` | No      | CopyBits                       | PackBitsRgn         |
   | `$009A` | No      | 4B, CopyBits                   | DirectBitsRect      |
   | `$009B` | No      | 4B, CopyBits                   | DirectBitsRgn       |
   | `$00A0` | Yes     | 2B                             | ShortComment        |
   | `$00A1` | Yes     | 2B, u16 size, (size&~1) bytes  | LongComment         |
   | `$00FF` | No      | 2B                             | OpEndPic            |
   | `$02FF` | Yes     | 2B                             | Version             |
   | `$0C00` | Yes     | Header Op                      | HeaderOp            |
   | `$8200` | No      | QuickTime Image                | CompressedQuickTime |

### CopyBits Pixel Depth ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 1     | Color mapped bit                                    | Pal1       |
   | 2     | Color mapped dibit                                  | Pal2       |
   | 4     | Color mapped nibble                                 | Pal4       |
   | 8     | Color mapped byte                                   | Pal8       |
   | 16    | X1RGB5                                              | X1RGB5     |
   | 32    | RGB8 (if NoPad) or XRGB8                            | RGB8       |

### Pack Type ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Always pack                                         | Default    |
   | 1     | Never pack                                          | None       |
   | 2     | Never pack, no padding channel in 32bpp mode        | NoPad      |
   | 3     | Only pack in 16bpp mode                             | RLE16      |
   | 4     | Only pack in 32bpp mode, no padding channel         | RLE32      |

### Polygon Type ###

   | Value | Description                           | Permutation | Name       |
   | ----- | -----------                           | ----------- | ----       |
   | 0     | Normal                                | None        |            |
   | 1     | Items may not pass                    | None        |            |
   | 2     | Monsters may not pass                 | None        |            |
   | 3     | Hill (for King of the Hill)           | None        |            |
   | 4     | Base (for Capture The Flag et al)     | Team        |            |
   | 5     | Platform                              | Plat index  |            |
   | 6     | Light on trigger                      | Light index |            |
   | 7     | Platform on trigger                   | Poly index  |            |
   | 8     | Light off trigger                     | Poly index  |            |
   | 9     | Platform off trigger                  | Poly index  |            |
   | 10    | Teleporter                            | Poly index  |            |
   | 11    | Zone border                           | None        |            |
   | 12    | Goal point                            | None        |            |
   | 13    | Activates all monsters in zone        | None        |            |
   | 14    | Ditto (TODO)                          | None        |            |
   | 15    | Ditto (TODO)                          | None        |            |
   | 16    | Ditto (TODO)                          | None        |            |
   | 17    | Must be explored to complete level    | None        |            |
   | 18    | Teleports to next level if success    | None        |            |
   | 19    | Minor ouch (TODO)                     | None        |            |
   | 20    | Major ouch (TODO)                     | None        |            |
   | 21    | Glue                                  | None        |            |
   | 22    | Glue trigger                          | None        |            |
   | 23    | Superglue                             | None        |            |

### Control Panel Type ###

   | Value | Description                           | Permutation | Name       |
   | ----- | -----------                           | ----------- | ----       |
   | 0     | Oxygen refuel                         | None        |            |
   | 1     | Health charger                        | None        |            |
   | 2     | Health charger (2x)                   | None        |            |
   | 3     | Health charger (3x)                   | None        |            |
   | 4     | Light switch                          | Light index |            |
   | 5     | Platform switch                       | Plat index  |            |
   | 6     | Tag switch                            | Tag or -1   |            |
   | 7     | Pattern buffer (save station)         | None        |            |
   | 8     | Computer terminal                     | None        |            |

### Side Type ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Full side                                           |            |
   | 1     | High side                                           |            |
   | 2     | Low side                                            |            |
   | 3     | Composite side                                      |            |
   | 4     | Split side                                          |            |

### Saved Object Group ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Monster                                             |            |
   | 1     | Object                                              |            |
   | 2     | Item                                                |            |
   | 3     | Player                                              |            |
   | 4     | Goal                                                |            |
   | 5     | Sound source (facing is sound volume)               |            |

### Transfer Mode ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Normal                                              |            |
   | 1     | Fade to black                                       |            |
   | 2     | Invisibility                                        |            |
   | 3     | Invisibility (subtle)                               |            |
   | 4     | Pulsate (polygons only)                             |            |
   | 5     | Wobble (polygons only)                              |            |
   | 6     | Wobble (fast, polygons only)                        |            |
   | 7     | Static                                              |            |
   | 8     | 50% static                                          |            |
   | 9     | Sky                                                 |            |
   | 10    | Smear                                               |            |
   | 11    | Static (fade out)                                   |            |
   | 12    | Static (pulsating)                                  |            |
   | 13    | Fold-in                                             |            |
   | 14    | Fold-out                                            |            |
   | 15    | Horizontal slide                                    |            |
   | 16    | Horizontal slide (fast)                             |            |
   | 17    | Vertical slide                                      |            |
   | 18    | Vertical slide (fast)                               |            |
   | 19    | Wander                                              |            |
   | 20    | Wander (fast)                                       |            |
   | 21    | Big sky                                             |            |

### Light Type ###

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Normal light                                        |            |
   | 1     | Strobe light                                        |            |
   | 2     | Media light                                         |            |

### Wad Version ###

   Used to determine how the engine loads the Wad file.

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Marathon 1 data (no directory entry)                | VerBase    |
   | 1     | Marathon 1 data (has directory entry)               | VerDir     |
   | 2     | Marathon 2 data (supports overlays)                 | VerOver    |
   | 4     | Marathon Infinity data                              | VerMI      |

### Data Version ###

   Used to determine how the engine loads map data.

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Marathon 1 data                                     | DataM1     |
   | 1     | Marathon 2 data                                     | DataM2     |

### Terminal Group Type ###

   | Value | Description                           | Permutation | Name       |
   | ----- | -----------                           | ----------- | ----       |
   | 0     | Logon                                 | None        | Logon      |
   | 1     | Unfinished (conditions incomplete)    | None        | Unfinished |
   | 2     | Success (success condition)           | None        | Success    |
   | 3     | Failure (failure condition)           | None        | Failure    |
   | 4     | Information (no image attached)       | None        | Info       |
   | 5     | End terminal                          | None        | End        |
   | 6     | Changes level                         | Level id    | TeleInter  |
   | 7     | Teleports to polygon                  | Polygon id  | TeleIntra  |
   | 8     | Shows goal point                      | Goal id     | Checkpoint |
   | 9     | Plays a sound                         | Sound id    | Sound      |
   | 10    | Movie (not implemented)               | Movie id    | Movie      |
   | 11    | Music (not implemented)               | Track id    | Track      |
   | 12    | Show image                            | Pict id     | Pict       |
   | 13    | Logoff                                | None        | Logoff     |
   | 14    | Camera (not implemented)              | Object id   | Camera     |
   | 15    | Static (TV static effect)             | 1/30 secs   | Static     |
   | 16    | Activate tag                          | Tag number  | Tag        |

### Terminal Color ###

   These are the default colors. These can be overridden with mods.

   | Value | Description                                         | Name       |
   | ----- | -----------                                         | ----       |
   | 0     | Light Green                                         | Color0     |
   | 1     | White                                               | Color1     |
   | 2     | Red                                                 | Color2     |
   | 3     | Dark Green                                          | Color3     |
   | 4     | Light Blue                                          | Color4     |
   | 5     | Yellow                                              | Color5     |
   | 6     | Dark Red                                            | Color6     |
   | 7     | Dark Blue                                           | Color7     |
   | 8     | No color                                            | Color8     |
   | 9     | No color                                            | Color9     |

# FLAGS #######################################################################

### Endpoint Flags ###

   | Value   | Description                                      | Name        |
   | -----   | -----------                                      | ----        |
   | `$0001` | Point belongs to a solid line                    | Solid       |
   | `$0002` | All polys with this point have the same height   | SameHeight  |
   | `$0004` | Point belongs to a transparent line or side      | Transparent |

### Line Flags ###

   | Value   | Description                                      | Name        |
   | -----   | -----------                                      | ----        |
   | `$0200` | Line has a transparent side                      | TransSide   |
   | `$0400` | TODO                                             | TODO        |
   | `$0800` | TODO                                             | TODO        |
   | `$1000` | Line shows only sky                              | Landscape   |
   | `$2000` | Both sides are see-through                       | Transparent |
   | `$4000` | Can't be walked through                          | Solid       |

### Side Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | Button is switched                                |            |
   | `$0002` | Control panel                                     |            |
   | `$0004` | Repair switch                                     |            |
   | `$0008` | Switch uses an item                               |            |
   | `$0010` | Switch must be lit up to use                      |            |
   | `$0020` | Switch can be destroyed                           |            |
   | `$0040` | Switch can only be hit by projectiles             |            |
   | `$0080` | Switch item is optional                           |            |

### Polygon Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$4000` | TODO                                              | Detached   |

### Map Object Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | Initially invisible (warp-in)                     | Invisible  |
   | `$0002` | Reversed Z coordinate (from ceiling)              | Ceiling    |
   | `$0004` | TODO                                              | Blind      |
   | `$0008` | TODO                                              | Deaf       |
   | `$0010` | TODO                                              | Floating   |
   | `$0020` | Net-game only, only works on items                | NetOnly    |

### Mission Flags ###

   | Value   | Description                                    | Name          |
   | -----   | -----------                                    | ----          |
   | `$0001` | Kill a certain percentage of monsters          | Extermination |
   | `$0002` | Must explore marked polygons                   | Exploration   |
   | `$0004` | Must grab marked items                         | Retrieval     |
   | `$0008` | Must flip marked switches                      | Repair        |
   | `$0010` | Must keep certain percent of BoBs alive        | Rescue        |
   | `$0020` | TODO                                           | M1Exploration |
   | `$0040` | TODO                                           | M1Rescue      |
   | `$0080` | TODO                                           | M1Repair      |

### Environment Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | Makes most weapons not work and oxygen depletes   | Vacuum     |
   | `$0002` | Motion sensor is fucked                           | Magnetic   |
   | `$0004` | Friendly S'pht, strips items and health           | Rebellion  |
   | `$0008` | Low gravity                                       | LowGrav    |
   | `$0010` | Handles glue like Marathon 1                      | M1Glue     |
   | `$0020` | The floor damages you                             | LavaFloor  |
   | `$0040` | Friendly S'pht                                    | Rebellion2 |
   | `$0080` | Level has music                                   | Music      |
   | `$0100` | Terminals stop time (Solo only)                   | TermPause  |
   | `$0200` | M1 monster activation limits                      | M1Monster  |
   | `$0400` | Weapon pickups on TC, lo-G grenades               | M1Weps     |
   | `$2000` | Net-play map                                      | NetPlay    |
   | `$4000` | Solo map                                          | Solo       |

### Light Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | TODO                                              |            |
   | `$0002` | TODO                                              | Stateless  |

### Entry Point Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | Solo                                              | Solo       |
   | `$0002` | Co-op                                             | CoOp       |
   | `$0004` | Carnage                                           | Carnage    |
   | `$0008` | Kill The Man With The Ball                        | KTMWTB     |
   | `$0010` | King of the Hill                                  | KOTH       |
   | `$0020` | Defense                                           | Defense    |
   | `$0040` | Rugby                                             | Rugby      |
   | `$0080` | Capture The Flag                                  | CTF        |

### Terminal Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$0001` | Text is encoded                                   | Encoded    |

### CopyBits Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$4000` | Unused                                            |            |
   | `$8000` | Is PICT2                                          | PICT2      |

### Color Table Flags ###

   | Value   | Description                                       | Name       |
   | -----   | -----------                                       | ----       |
   | `$8000` | Use automatic device mapping for indices          | DeviceMap  |

EOF.