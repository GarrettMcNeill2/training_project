# Assorted Notes

Hopefully these could assist those making videos about this repo (including me!)

## Terrain3D
Note that there are great Youtube tutorials for getting started with this stuff:

- [Video ref. 1](https://www.youtube.com/watch?v=i_IHnmf0pkk)
- [Video ref. 2](https://www.youtube.com/watch?v=oV8c9alXVwU)

Also note that, in order to achieve automatic slope-based shading of terrain
(a.k.a. autoshading), follow this tutorial:

[Texture Painting](https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html)

## Git and Godot
As per [this issue tag](https://github.com/godotengine/godot-proposals/issues/7925)
in the godot repo, they will include plugin manifests at a later date for the
engine. This would imply we wouldn't need to check in whole addons to our
project, significantly bloating the size of our repository. Until this is
implemented, we're sticking with the bone-headed move of "checking in 10000+
additions and 12 binaries when we install an addon." I hope you don't mind.

