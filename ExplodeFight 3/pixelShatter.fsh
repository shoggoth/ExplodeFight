
void main() {

    float a_split_count = 5.0;
    
    vec2  uv = v_tex_coord;
    float sc = 2.0 / a_split_count;
    
    if (uv.x > 0.75) discard;
    
    else if (mod(uv.y, sc) > sc * 0.5) discard;
    
    // Pixels shattering a la Robotron
    else gl_FragColor = texture2D(u_texture, vec2(uv.x, uv.y));
}
