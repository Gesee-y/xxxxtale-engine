# xxxxtale Engine

An Undertale engine in Godot. This was my first real project.  
This engine serves as a base for any Undertale fangame, letting you focus on your patterns and stories instead of worrying about how to make a turn-based fight.

## Little introduction

I actually love undertale fangames. I always find fascinating how much we can do with little things.
This engine is actually the 3rd one I made.
The first was UnderDelta which aimed to be a fully featured undertale/deltarune engine but after some refactor, it became ____tale, but the codebase was unmaintanable and too heavy so I remade the engine from scratch and here it is.
**xxxxtale**!!!

## Features

- **Overworld template**
- **Cutscene template**
- **Battle/Attacks template**
- **Flexible attacks with pre-attack events, pre-pattern events, and post-attack events**
- **Everything as a resource**: Your battles, weapons, characters, etc., are all customizable resources.
- **Battle management**: Continuity between battles allows a highly flexible way to describe how you want your battles to go.
- **Efficient turn-based systems**: Using multiple triggers to manage the different states of the fight.
- **Serialization**: Save files are serialized to ensure no everyday hacker can play with the files.
- **Example games**: The engine comes witg 3 fangames, you can inspect the code, hack it and fully master the engine.
- **Ton of template resources**: Create your own characters, typers, weapon, battle style, dialogue management and even spells.
- **multi-characters battle**: This engine can go beyond the boundaries of a traditional undertale fangame by introducing multiple characters in a fight, each choosing its actions.
- **Easy dialogue system**: No hardcoding here—load your dialogues from a separate file in a completely human-readable way.
   * Example: 
```txt
Sans: Hit me all ya want, I am more determined than you think.

{END}

Sans: Ya know kid, I always wondered why you continue killing.

{END}

Sans: Turn Text 3

{END}

Sans: Turn Text 4

{END}
```
- **Objects as CSV**: Load your objects from CSV files. Created a new kind of weapon? Just add it in the CSV file and you're done.

- **Custom collision system**: Instead of relying on Godot's collision systems, which may not suit the intensity of your fangame, a custom collision system has been implemented specifically for Undertale.

- **Powerful text writer**: Comes with its own little DSL to create powerful text and even trigger events from them. Example: `{sans:smile}Don't worry buddo{P:2},{S:1}I got your [color:red]spine[/color]`.

## Fangames made with xxxxtale

- **[Fallen Stars Sans fight + Hard mode](https://youtu.be/tv8iYBQ3W-g?si=_I3WD6hH8E8Rq6Gn)**: A deep fight against a tired Sans. He doesn't want to win or lose... He just wants the suffering to end.![Fallen stars](https://github.com/Gesee-y/xxxxtale-engine/blob/main/Github/Screenshot_20250924_083010_YouTube.jpg)
- **[Dusttale Sans Fight](https://youtu.be/6e9UGBO0o40?si=GjAImG_nfify46gk)**: A brutal battle against a Sans who got too much LOVE. In the end, he realizes that no matter if he gets LOVE or chooses love, he will still feel despair.![Dusttale](https://github.com/Gesee-y/xxxxtale-engine/blob/main/Github/Screenshot_20250924_083351_YouTube.jpg)
- **[Gaster blaster fight]()**: A funny test fight I made for fun.![GB FIGHT!](https://github.com/Gesee-y/xxxxtale-engine/blob/main/Github/Screenshot_20250924_083559_VLC.jpg)

## License

This project is under the MIT License. Feel free to do whatever you want with it.

## Contact

If you ever feel like reaching me, you can email me at gesee37@gmail.com. 
