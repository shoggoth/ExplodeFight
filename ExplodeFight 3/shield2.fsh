void main() {
    
    // Load the pixel from our original texture, and the same place in the gradient circle
    vec2  uv = v_tex_coord;
    vec4  val = texture2D(u_texture, uv);
    float angle = u_amount * 6.2831853072;
    
    float d = distance(uv, vec2(0.5));
    float a = atan(uv.x, uv.y);
    
    if (d > 0.41 && d < 0.44 && a > 1)
        gl_FragColor = vec4(0.0, 1.0, 0.0, 0.0);
    else
        gl_FragColor = SKDefaultShading();
}
