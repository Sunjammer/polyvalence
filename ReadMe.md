# polyvalence
A cross-platform toolkit for Marathon Infinity.

### Motivation
* The [Marathon Trilogy](http://trilogyrelease.bungie.org/) is my favorite first person shooter series of the 90s. The games are free to download and play using the open source [Aleph One](https://github.com/Aleph-One-Marathon/alephone) engine. I used to *love* making levels for Marathon.
* The classic tools I'm familiar with, Pfhorte and [Forge](https://www.youtube.com/watch?v=E8yqfvNc0HM), are trapped in the dead world of PowerPC MacOS
* There are other open editor projects out there but they're either written in languages I'm not proficient in or in ways I don't feel comfortable with. 
* I like making editors and I think I'm okay at it.

### Concrete goals
* Back compat with M1 and M2, primary compat with MI
* CLI tools for extracting Marathon resource files into directories of intermediate, textual and binary representations, collated as "polyvalence projects" (or simply "projects").
* CLI tools for bundling projects into Marathon resource files with specific engine targets (again, M1, M2 or MI)
* Extensible editor shell
* Integrated editors for every facet of a project, in order of priority: 
    * Four-view level editor w. visual mode viewport
    * Campaign planner
    * Terminals
    * Shapes
    * Physics