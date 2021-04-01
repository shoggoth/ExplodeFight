
void main() {
    
    const float split_count = 2;
    const float explode_factor = a_explodeAmount;
    const float explode_mod = 1.0;
    const float x = mod(v_tex_coord.x * split_count, explode_mod);
    const float d = x - 1.0;
    
    if (abs(d) < explode_factor) discard;
    const float tt = floor(v_tex_coord.x * split_count) / split_count;
    const float tc = x / (1.0 - explode_factor) / split_count;
    gl_FragColor = texture2D(u_texture, vec2(tc + tt, v_tex_coord.y));
}
