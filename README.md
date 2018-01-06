#UnityUtils

Visual effects and utility classes for unity development.

##Decal

A simple decal projector.


####Required 
  * Deferred rendering path.  

####TODO  
  * Forward support, maybe  

####Usage:  
  1. Create material with Decal.shader;  
  2. Assign material to a unity default cube.

##IntersectionHighlight(WIP)

Highlights transparent material's border if it clips with geography. 

####Usage
  * Create transparent material with shader.  

##Transparent Shadowcaster

Casts shadow according to texture alpha.  

####Usage 
  1. Create transparent material with shader.  
  2. Set fallback shader to your own shader to use it's normal passes.  

##ZBuffer Outline

Image effect that draws outline according to zbuffer.  

####Usage
  1. Drag DepthBasedOutline.cs to target camera.  
    
> OutlineThreshold: pixel with zbuffer delta larger than threshold will be considered a outline pixel, thus rendered with OutlineColor.  

[Markdown Editor](https://stackedit.io/editor)