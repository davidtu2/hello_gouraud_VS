David Tu
david.tu2@csu.fullerton.edu

This is a program which draws a teapot with two light sources which was originally based on Professor Shafae's hello_glsl program.
The shaders used in this program uses the Gouraud method of shading, which has the vertex shader calculate the color of every vertex and then passes this color to the fragment shader for interpolation.
This results in fragments nearest to the vertex having the very similar color and than the fragments furthest from it, which will have a darker color.
This is different from the Phong method of shading in which the color is calculated per fragment in the fragment shader and not per vertex.
So, the shading results using the Gouraud method ends up looking very similar to Phong's method but less realistic.
In order to do this, the vertex shader for the Gouraud method of shading, gouraud.vert.glsl, needs to calculate a color. In this example, I will be using blinn-phong to calculate the color per vertex.

To use blinn-phong, some variables are needed, which are described below:
-We need to determine the eye direction, eyedirn, by subtracting the eye position, (0, 0, 0), with the transformed vertex, mypos, and then normalizing it. This gives us the vector from the vertex to the eye position.
-Using the same method just described, we need to determine the direction to the light source, direction, by using the positions of the light, light_position, and the vertex, mypos.
-Using the vectors we just computed, eyedirn and direction, we will be able to calculate the halfway vector between them, half, by adding the two vectors and normalizing the result.
-The normal vector, normal, is also needed. This can be obtained by normalizing the transformed normal, _normal.

Once we have these vectors (eyedirn, direction, half and normal), we can finally use blinn-phong to compute the lights. All of the computations are done in the ComputeLight function, which also requires the given variables: light_color, diffuse, specular and shininess.

Within the ComputeLight function, the lambert and phong portions of the blinn-phong equation are calculated as follows, where nDotL is the dot product between the vectors, normal and direction, and nDotH is the dot product between the vectors, normal and half:
  lambert = diffuse * light_color * max(nDotL, 0.0)
  phong = specular * light_color * pow(max(nDotH, 0.0), shininess)
Once lambert and phong are computed, they are added to the final color, myColor, along with the passed variable, ambient. The final color is then passed to the fragment shader for interpolation.
