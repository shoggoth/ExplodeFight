void main() {
    
    float d = distance(v_tex_coord, vec2(u_centre));
    
    if (d > u_distance)
        gl_FragColor = SKDefaultShading();
    else
        gl_FragColor = vec4(vec3(d), 1.0);
}
