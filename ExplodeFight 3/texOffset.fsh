
void main() {

    // Load the pixel from our original texture, and the same place in the gradient circle
    gl_FragColor = texture2D(u_texture, v_tex_coord + a_texOffset);
}
