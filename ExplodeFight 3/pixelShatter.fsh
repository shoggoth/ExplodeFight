
void main() {

    float a_split_count = 5.0;
    
    vec2  st = v_tex_coord;
    float sc = 1.0 / a_split_count;
    
    if (mod(st.y, sc * 2.0) > sc) discard;

    // Pixels shattering a la Robotron
    else {
        float offset = floor(st.y / sc) * (1.0 / (a_split_count + 1));
        float coords = mod(st.y, sc) * (a_split_count / ceil(a_split_count * 0.5));
        float t = offset + coords;
        gl_FragColor = texture2D(u_texture, vec2(st.x, t));
    }
}
