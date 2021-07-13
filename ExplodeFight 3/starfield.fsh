#define FLIGHT_SPEED = 8.0;

#define DRAW_DISTANCE = 60.0; // Lower this to increase framerate
#define FADEOUT_DISTANCE = 10.0; // must be < DRAW_DISTANCE

#define STAR_SIZE = 0.6; // must be > 0 and < 1
#define STAR_CORE_SIZE = 0.14;

#define CLUSTER_SCALE = 0.02;
#define STAR_THRESHOLD = 0.775;

#define BLACK_HOLE_CORE_RADIUS = 0.2;
#define BLACK_HOLE_THRESHOLD = 0.9995;
#define BLACK_HOLE_DISTORTION = 0.03;

vec3 hsv2rgb(vec3 c) {
    
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(vec2 co){
    
    return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

float getDistance(vec3 chunkPath, vec3 localStart, vec3 localPosition) {
    
    return length(chunkPath + localPosition - localStart);
}

vec3 getRayDirection(vec2 fragCoord, vec3 cameraDirection, vec2 spriteSize) {
    
    vec2 uv = fragCoord / spriteSize;
    
    float screenWidth = 1.0;
    float fieldOfView = 1.05 / 2.0;
    float originToScreen = screenWidth / 2.0 / tan(fieldOfView);

    vec3 screenCenter = originToScreen * cameraDirection;
    vec3 baseX = normalize(cross(screenCenter, vec3(0, -1.0, 0)));
    vec3 baseY = normalize(cross(screenCenter, baseX));

    return normalize(screenCenter + (uv.x - 0.5) * baseX + (uv.y - 0.5) * spriteSize.y / spriteSize.x * baseY);
}

vec3 move(vec3 localPosition, vec3 rayDirection, vec3 directionBound) {
    
    vec3 directionSign = sign(rayDirection);
    vec3 amountVector = (directionBound - directionSign * localPosition) / abs(rayDirection);
    
    float amount = min(amountVector.x, min(amountVector.y, amountVector.z));
    
    return localPosition + amount * rayDirection;
}

// Makes sure that each component of localPosition is >= 0 and <= 1
vec3 moveInsideBox(vec3 localPosition, vec3 chunk, vec3 directionSign, vec3 direcctionBound) {
    
    float eps = 0.0000001;
    
    if (localPosition.x * directionSign.x >= direcctionBound.x - eps) {
        localPosition.x -= directionSign.x;
        chunk.x += int(directionSign.x);
    } else if (localPosition.y * directionSign.y >= direcctionBound.y - eps) {
        localPosition.y -= directionSign.y;
        chunk.y += int(directionSign.y);
    } else if (localPosition.z * directionSign.z >= direcctionBound.z - eps) {
        localPosition.z -= directionSign.z;
        chunk.z += int(directionSign.z);
    }
    
    return localPosition;
}

/*
bool hasStar(ivec3 chunk) {
    return texture2D(iChannel0, mod(CLUSTER_SCALE * (vec2(chunk.xy) + vec2(chunk.zx)) + vec2(0.724, 0.111), 1.0)).r > STAR_THRESHOLD
        && texture2D(iChannel0, mod(CLUSTER_SCALE * (vec2(chunk.xz) + vec2(chunk.zy)) + vec2(0.333, 0.777), 1.0)).r > STAR_THRESHOLD;
}

bool hasBlackHole(ivec3 chunk) {
    return rand(0.0001 * vec2(chunk.xy) + 0.002 * vec2(chunk.yz)) > BLACK_HOLE_THRESHOLD;
}

vec3 getStarToRayVector(vec3 rayBase, vec3 rayDirection, vec3 starPosition) {
    float r = (dot(rayDirection, starPosition) - dot(rayDirection, rayBase)) / dot(rayDirection, rayDirection);
    vec3 pointOnRay = rayBase + r * rayDirection;
    return pointOnRay - starPosition;
}

vec3 getStarPosition(ivec3 chunk, float starSize) {
    vec3 position = abs(vec3(rand(vec2(float(chunk.x) / float(chunk.y) + 0.24, float(chunk.y) / float(chunk.z) + 0.66)),
                             rand(vec2(float(chunk.x) / float(chunk.z) + 0.73, float(chunk.z) / float(chunk.y) + 0.45)),
                             rand(vec2(float(chunk.y) / float(chunk.x) + 0.12, float(chunk.y) / float(chunk.z) + 0.76))));
    
    return starSize * vec3(1.0) + (1.0 - 2.0 * starSize) * position;
}

vec4 getNebulaColor(vec3 globalPosition, vec3 rayDirection) {
    vec3 color = vec3(0.0);
    float spaceLeft = 1.0;
    
    const float layerDistance = 10.0;
    float rayLayerStep = rayDirection.z / layerDistance;
    
    const int steps = 4;
    for (int i = 0; i <= steps; i++) {
        vec3 noiseeval = globalPosition + rayDirection * ((1.0 - fract(globalPosition.z / layerDistance) + float(i)) * layerDistance / rayDirection.z);
        noiseeval.xy += noiseeval.z;
        
        
        float value = 0.06 * texture2D(iChannel0, fract(noiseeval.xy / 60.0)).r;
         
        if (i == 0) {
            value *= 1.0 - fract(globalPosition.z / layerDistance);
        } else if (i == steps) {
            value *= fract(globalPosition.z / layerDistance);
        }
        
        float hue = mod(noiseeval.z / layerDistance / 34.444, 1.0);
        
        color += spaceLeft * hsv2rgb(vec3(hue, 1.0, value));
        spaceLeft = max(0.0, spaceLeft - value * 2.0);
    }
    return vec4(color, 1.0);
}

vec4 getStarGlowColor(float starDistance, float angle, float hue) {
    float progress = 1.0 - starDistance;
    return vec4(hsv2rgb(vec3(hue, 0.3, 1.0)), 0.4 * pow(progress, 2.0) * mix(pow(sin(angle * 2.5), 6.0), 1.0, progress));
}

float atan2(vec2 value) {
    if (value.x > 0.0) {
        return atan(value.y / value.x);
    } else if (value.x == 0.0) {
        return 3.14592 * 0.5 * sign(value.y);
    } else if (value.y >= 0.0) {
        return atan(value.y / value.x) + 3.141592;
    } else {
        return atan(value.y / value.x) - 3.141592;
    }
}

vec3 getStarColor(vec3 starSurfaceLocation, float seed, float viewDistance) {
    const float DISTANCE_FAR = 20.0;
    const float DISTANCE_NEAR = 15.0;
    
    if (viewDistance > DISTANCE_FAR) {
        return vec3(1.0);
    }
    
    float fadeToWhite = max(0.0, (viewDistance - DISTANCE_NEAR) / (DISTANCE_FAR - DISTANCE_NEAR));
    
    vec3 coordinate = vec3(acos(starSurfaceLocation.y), atan2(starSurfaceLocation.xz), seed);
    
    float progress = pow(texture2D(iChannel0, fract(0.3 * coordinate.xy + seed * vec2(1.1))).r, 4.0);
    
    return mix(mix(vec3(1.0, 0.98, 0.9), vec3(1.0, 0.627, 0.01), progress), vec3(1.0), fadeToWhite);
}

vec4 blendColors(vec4 front, vec4 back) {
      return vec4(mix(back.rgb, front.rgb, front.a / (front.a + back.a)), front.a + back.a - front.a * back.a);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 movementDirection = normalize(vec3(0.01, 0.0, 1.0));
    
    vec3 rayDirection = getRayDirection(fragCoord, movementDirection);
    vec3 directionSign = sign(rayDirection);
    vec3 directionBound = vec3(0.5) + 0.5 * directionSign;
    
    vec3 globalPosition = vec3(3.14159, 3.14159, 0.0) + (iGlobalTime + 1000.0) * FLIGHT_SPEED * movementDirection;
    ivec3 chunk = ivec3(globalPosition);
    vec3 localPosition = mod(globalPosition, 1.0);
    moveInsideBox(localPosition, chunk, directionSign, directionBound);
    
    ivec3 startChunk = chunk;
    vec3 localStart = localPosition;
    
    fragColor = vec4(0.0);
    
    for (int i = 0; i < 200; i++) {
        move(localPosition, rayDirection, directionBound);
        moveInsideBox(localPosition, chunk, directionSign, directionBound);
        
        if (hasStar(chunk)) {
            vec3 starPosition = getStarPosition(chunk, 0.5 * STAR_SIZE);
            float currentDistance = getDistance(chunk - startChunk, localStart, starPosition);
            if (currentDistance > DRAW_DISTANCE && false) {
                break;
            }
            
            // This vector points from the center of the star to the closest point on the ray (orthogonal to the ray)
            vec3 starToRayVector = getStarToRayVector(localPosition, rayDirection, starPosition);
            // Distance between ray and star
            float distanceToStar = length(starToRayVector);
            distanceToStar *= 2.0;
            
            if (distanceToStar < STAR_SIZE) {
                float starMaxBrightness = clamp((DRAW_DISTANCE - currentDistance) / FADEOUT_DISTANCE, 0.001, 1.0);
                
                float starColorSeed = (float(chunk.x) + 13.0 * float(chunk.y) + 7.0 * float(chunk.z)) * 0.00453;
                if (distanceToStar < STAR_SIZE * STAR_CORE_SIZE) {
                    // This vector points from the center of the star to the point of the star sphere surface that this ray hits
                    vec3 starSurfaceVector = normalize(starToRayVector + rayDirection * sqrt(pow(STAR_CORE_SIZE * STAR_SIZE, 2.0) - pow(distanceToStar, 2.0)));
                    
                    fragColor = blendColors(fragColor, vec4(getStarColor(starSurfaceVector, starColorSeed, currentDistance), starMaxBrightness));
                    break;
                } else {
                    float localStarDistance = ((distanceToStar / STAR_SIZE) - STAR_CORE_SIZE) / (1.0 - STAR_CORE_SIZE);
                    vec4 glowColor = getStarGlowColor(localStarDistance, acos(starToRayVector.y / length(starToRayVector)), starColorSeed);
                    glowColor.a *= starMaxBrightness;
                    fragColor = blendColors(fragColor, glowColor);
                }
            }
        } else if (hasBlackHole(chunk)) {
            const vec3 blackHolePosition = vec3(0.5);
            float currentDistance = getDistance(chunk - startChunk, localStart, blackHolePosition);
            float fadeout = min(1.0, (DRAW_DISTANCE - currentDistance) / FADEOUT_DISTANCE);
                
            // This vector points from the center of the black hole to the closest point on the ray (orthogonal to the ray)
            vec3 coreToRayVector = getStarToRayVector(localPosition, rayDirection, blackHolePosition);
            float distanceToCore = length(coreToRayVector);
            if (distanceToCore < BLACK_HOLE_CORE_RADIUS * 0.5) {
                fragColor = blendColors(fragColor, vec4(vec3(0.0), fadeout));
                break;
            } else if (distanceToCore < 0.5) {
                rayDirection = normalize(rayDirection - fadeout * (BLACK_HOLE_DISTORTION / distanceToCore - BLACK_HOLE_DISTORTION / 0.5) * coreToRayVector / distanceToCore);
            }
        }
        
        if (length(vec3(chunk - startChunk)) > DRAW_DISTANCE) {
            break;
        }
    }
    
    if (fragColor.a < 1.0) {
        fragColor = blendColors(fragColor, getNebulaColor(globalPosition, rayDirection));
    }
}*/

void main(void) {
    
    vec2 uv = u_sprite_size;

    gl_FragColor = vec4(0.3, 0.4, 0.7, 1.0);
}
