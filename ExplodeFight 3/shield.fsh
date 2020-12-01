void main() {

    // Load the pixel from our original texture, and the same place in the gradient circle
    vec4 val = texture2D(u_texture, v_tex_coord);
    vec4 grad = texture2D(u_gradient, v_tex_coord);
     
    // [1 - ORIGINAL CHECK] If the original is transparent AND
    // [2 - HEALTH CHECK] The gradient image has a black value less than the remaining health AND
    // [3 - MASKING] The gradient pixel is not transparent
    if (val.a < 0.1 && grad.r < u_time * 0.001 && grad.a > 0.8) {
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
    } else {
        gl_FragColor = val;
    }
}
