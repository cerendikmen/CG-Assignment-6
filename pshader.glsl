#version 330
// control
uniform bool hasNormals;
uniform bool useDiffuseTexture;
uniform bool useNormalMap;
uniform bool setDiffuseToZero;
uniform bool setSpecularToZero;

// 0: with lighting, 1: diffuse texture only,
// 2: normal map texture only, 3: final normal only
uniform int renderMode;

// material parameters
uniform vec4 diffuseUniform;
uniform vec3 specularUniform;
uniform mat3 normalToCamera;
uniform mat4 posToCamera;
uniform float glossiness;

// how deep the normal mapped bumps are
uniform float normalMapScale;

// texture samplers
uniform sampler2D diffuseSampler;
uniform sampler2D normalSampler;

// lighting information, in camera space
uniform int  numLights;
uniform vec3 lightIntensities[8];
uniform vec3 lightDirections[8];

// interpolated inputs from vertex shader
in vec3 positionVarying;
in vec3 normalVarying;
in vec4 colorVarying;
in vec3 tangentVarying;
in vec2 texCoordVarying;

// output color
out vec4 outColor;

// inputs for shadow mapping
in vec2 shadowUV[3]; // location of the current fragment in the lights space
in float lightDist[3];
uniform sampler2D shadowSampler[3];
uniform bool shadowMaps;
uniform float shadowEps;

void main()
{
	vec4 diffuseColor = diffuseUniform * colorVarying;
	vec3 specularColor = specularUniform;

	if (useDiffuseTexture)
	{
		// YOUR CODE HERE (R1)
		// Fetch the diffuse material color at the texture coordinates of the fragment.
		// This is just one line of code.
		diffuseColor = texture2D(diffuseSampler,texCoordVarying);


	}

	// diffuse only?
	if (renderMode == 1)
	{
		outColor = vec4(diffuseColor.rgb, 1);
		return;
	}

	// R5: What space does the normal lie in before and after this transform?
	vec3 mappedNormal = normalize( normalToCamera * normalVarying );

	if (useNormalMap)
	{
		// YOUR CODE HERE (R2)
		// Fetch the object space normal from the normal map and scale it.
		// Then transform to camera space and assign to mappedNormal.
		// Don't forget to normalize!
		vec3 normalFromTexture = normalize(vec3(2*texture2D(normalSampler, texCoordVarying) -1));
		mappedNormal = normalToCamera * normalFromTexture;
		

		if (renderMode == 2)
		{
			outColor = vec4(normalFromTexture*0.5+0.5, 1);
			return;
		}
	}

	if (renderMode == 3)
	{
		outColor = vec4(mappedNormal*0.5+0.5, 1);
		return;
	}
					
	vec3 N = mappedNormal;

	// YOUR CODE HERE (R4)
	// Compute the to-viewer vector V which you'll need in the loop
	// below for Blinn-Phong specular computation.
	// R5: In which space does V lie in?
	vec3 V = vec3(0,0,0);
	V = normalize(-positionVarying);

	// add the contribution of all lights to the answer
	vec3 answer = vec3(0,0,0);

	for (int i = 0; i < numLights; ++i)
	{
		// YOUR CODE HERE (R3)
		// Compute the contribution of this light to diffuse shading.
		// This is just one row of code.
		vec3 diffuse = vec3(0,0,0);
		diffuse += vec3(diffuseColor)* max(0, dot(normalVarying,lightDirections[i]))* lightIntensities[i];

		// YOUR CODE HERE (R4)
		// Compute the contribution of this light to Blinn-Phong (half-angle) specular shading.
		vec3 specular = vec3(0, 0, 0);
		vec3 h = normalize(lightDirections[i] + V);
		specular += specularColor* pow(max(0, dot(h, normalVarying)),glossiness) *lightIntensities[i];

		if (setDiffuseToZero)
			diffuse = vec3(0, 0, 0);

		if (setSpecularToZero)
			specular = vec3(0, 0, 0);

		vec3 Li = lightIntensities[i] * (diffuse + specular);

		if (shadowMaps) {
			// YOUR SHADOWS HERE: use lightDist and shadowUV, maybe modify Li
			// this point is shadowed is some point is closer to the light than this
			// (try also adding a small bias value to either of those and see what happens; somehow analugous to the epsilon in ray tracing)
		}	

		answer += Li;
	}
	outColor = vec4(answer, 1);
}
