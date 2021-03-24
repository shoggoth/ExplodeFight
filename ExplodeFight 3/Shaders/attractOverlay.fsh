void main(void) {
    
    float   currTime = u_time;
    vec2    uv = v_tex_coord;
    vec2    centre = vec2(0.5);
    
    vec3    circleColour = vec3(0.8, 0.5, 0.7);
    vec3    posColour = vec3(uv, 0.5 + 0.5 * sin(currTime)) * circleColour;
    
    float   illu = pow(1.0 - distance(uv, centre), 4.0) * 1.2;
    
    illu *= (2.0 + abs(0.4 + cos(currTime * -20.0 + 50.0 * distance(uv, centre)) / 1.5));
    
    gl_FragColor = vec4(posColour * illu * 2.0, illu * 2.0) * v_color_mix.a;
}
