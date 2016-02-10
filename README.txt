# ME-C3100 Computer Graphics, Fall 2015
# Lehtinen / Kemppinen, Ollikainen, Puomio
#
# Assignment 6: Real-Time Shading

Student name: Ceren Dikmen
Student number:520069
Hours spent on requirements (approx.):15
Hours spent on extra credit (approx.):0

# First, a 10-second poll about this assignment period:

Did you go to exercise sessions? Yes

Did you work on the assignment using Aalto computers, your own computers, or both? Aalto computers

# Which parts of the assignment did you complete? Mark them 'done'.
# You can also mark non-completed parts as 'attempted' if you spent a fair amount of
# effort on them. If you do, explain the work you did in the problems/bugs section
# and leave your 'attempt' code in place (commented out if necessary) so we can see it.

R1       Sample diffuse texture (1p): done
R2        Sample normal texture (1p): done
R3  Blinn-Phong diffuse shading (2p): done
R4 Blinn-Phong specular shading (2p): done
R5     Normal transform insight (4p): done

# Did you do any extra credit work? No

(Describe what you did and, if there was a substantial amount of work involved, how you did it. Also describe how to use/activate your extra features, if they are interactive.)

# Are there any known problems/bugs remaining in your code? No

(Please provide a list of the problems. If possible, describe what you think the cause is, how you have attempted to diagnose or fix the problem, and how you would attempt to diagnose or fix it if you had more time or motivation. This is important: we are more likely to assign partial credit if you help us understand what's going on.)

# Did you collaborate with anyone in the class? No

(Did you help others? Did others help you? Let us know who you talked to, and what sort of help you gave or received.)

# Any other comments you'd like to share about the assignment or the course so far? 

(Was the assignment too long? Too hard? Fun or boring? Did you learn something, or was it a total waste of time? Can we do something differently to help you learn? Please be brutally honest; we won't take it personally.)

--------------------------------------------------------------------
R5

lightDir before the loop : world (object) space
	 after the loop  : camera space

normal before the transform : world (object) space
       after the transform  : camera space
V : camera space

In App.cpp we are converting lightDir into the camera space and in pshader.glsl we are converting mappedNormal into the camera space 
because When calculating diffuse/specular lighting, we want our direction/position vectors to all reside in the same coordinate space, 
otherwise we're doing calculations between different spaces which generates wrong results.

For R3:

Basically, if we want to use the world space coordinates instead of the camera space coordinates, 
we need to leave lightDir and mappedNormal in the world space removing the loop, which converts
lightDir to the camera space from the world space, and the line, which multiplies normalFromTexture with normalToCamera, from the code.

For R4:

In addition to the changes in R3, we need to consider about the to-viewer vector V.   



