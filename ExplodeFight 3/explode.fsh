
void main() {
    
    const vec2 ef = a_explodeAmount;                                    // Explode scale factor.
    
    const vec2 tc = v_tex_coord * ef;
    const vec2 ns = vec2(1, 1);                                         // Number of splits.
    const vec2 tw = vec2(1.0 / (ns.x + 1), 1.0 / (ns.y + 1));           // Textured band width.
    const vec2 sw = vec2((ef.x - 1.0) / ns.x, (ef.y - 1.0) / ns.y);     // Spacing band width.

    const vec2 m = vec2(mod(tc.x, tw.x + sw.x), mod(tc.y, tw.y + sw.y));
    if (m.x > tw.x || m.y > tw.y) discard;
    
    const vec2 d = vec2(floor(tc.x / (tw.x + sw.x)) * (1.0 / (ns.x + 1)), floor(tc.y / (tw.y + sw.y)) * (1.0 / (ns.y + 1)));
    
    //gl_FragColor = vec4(d.x * 0.25 + 0.5, 0.0, 0.0, 1.0);
    //gl_FragColor = texture2D(u_texture, tc);
    gl_FragColor = texture2D(u_texture, vec2(m.x + d.x, m.y + d.y));
    gl_FragColor = texture2D(u_texture, vec2(m.x + d.x, v_tex_coord.y * ef.y));
    //gl_FragColor = texture2D(u_texture, vec2(v_tex_coord.x * ef.x, v_tex_coord.y * ef.y));
}
