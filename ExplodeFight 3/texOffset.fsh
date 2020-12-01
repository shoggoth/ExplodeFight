
void main() {

    // Attributes are passed in here
    gl_FragColor = texture2D(u_texture, v_tex_coord + (a_texOffset * a_animation));
}
