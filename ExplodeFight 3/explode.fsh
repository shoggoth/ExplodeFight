
void main() {
    
    const vec2 explode_factor = a_explodeAmount;

    gl_FragColor = texture2D(u_texture, vec2(v_tex_coord.x * explode_factor.x, v_tex_coord.y * explode_factor.y));
}
