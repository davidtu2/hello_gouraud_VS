# version 120 
// 
// David Tu
// david.tu2@csu.fullerton.edu
//
//

// These are passed in from the CPU program
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform vec4 light0_position;
uniform vec4 light0_color;
uniform vec4 light1_position;
uniform vec4 light1_color;

// These are variables that we wish to send to our fragment shader
// In later versions of GLSL, these are 'out' variables.
varying vec4 myColor;

vec4 ComputeLight(const in vec3 direction, const in vec4 lightcolor, const in vec3 normal, const in vec3 halfvec, const in vec4 mydiffuse, const in vec4 myspecular, const in float myshininess){
  float nDotL = dot(normal, direction);
  vec4 lambert = mydiffuse * lightcolor * max(nDotL, 0.0);

  float nDotH = dot(normal, halfvec);
  vec4 phong = myspecular * lightcolor * pow(max(nDotH, 0.0), myshininess);

  vec4 retval = lambert + phong;
  return retval;
}

void main() {
  gl_Position = projectionMatrix * modelViewMatrix * gl_Vertex;

  //Calculating the color of the vertex
  vec4 ambient = vec4(0.2, 0.2, 0.2, 1.0);
  vec4 diffuse = vec4(0.5, 0.5, 0.5, 1.0);
  vec4 specular = vec4(1.0, 1.0, 1.0, 1.0);
  float shininess = 100;
  const vec3 eyepos = vec3(0, 0, 0);

  vec4 _mypos = modelViewMatrix * gl_Vertex;
  vec3 mypos = _mypos.xyz/_mypos.w;
  vec3 eyedirn = normalize(eyepos - mypos);

  vec4 _normal = normalMatrix * vec4(vec3(gl_Normal), 0.0);
  vec3 normal = normalize(_normal.xyz);

  vec3 position0 = light0_position.xyz/light0_position.w;
  vec3 direction0 = normalize(position0 - mypos);
  vec3 half0 = normalize(direction0 + eyedirn);
  vec4 color0 = ComputeLight(direction0, light0_color, normal, half0, diffuse, specular, shininess);

  vec3 position1 = light1_position.xyz/light1_position.w;
  vec3 direction1 = normalize(position1 - mypos);
  vec3 half1 = normalize(direction1 + eyedirn);
  vec4 color1 = ComputeLight(direction1, light1_color, normal, half1, diffuse, specular, shininess);

  myColor = ambient + color0 + color1;
}
