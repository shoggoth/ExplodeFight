void main() {
    // bring both speed and strength into the kinds of ranges we need for this effect
    float speed = u_time * u_speed * 0.05;
    float strength = u_strength / 100.0;

    // take a copy of the current texture coordinate so we can modify it
    vec2 coord = v_tex_coord;

    // offset the coordinate by a small amount in each direction, based on wave frequency and wave strength
    coord.x += sin((coord.x + speed) * u_frequency) * strength;
    coord.y += cos((coord.y + speed) * u_frequency) * strength;

    // use the color at the offset location for our new pixel color
    gl_FragColor = texture2D(u_texture, coord) * v_color_mix.a;
}
/*
vec2 SineWave( vec2 p )
    {
    // convert Vertex position <-1,+1> to texture coordinate <0,1> and some shrinking so the effect dont overlap screen
    p.x=( 0.55*p.x)+0.5;
    p.y=(-0.55*p.y)+0.5;
    // wave distortion
    float x = sin( 25.0*p.y + 30.0*p.x + 6.28*tx) * 0.05;
    float y = sin( 25.0*p.y + 30.0*p.x + 6.28*ty) * 0.05;
    return vec2(p.x+x, p.y+y);
    }

void main()
    {
    gl_FragColor = texture2D(s_baseMap,SineWave(v_texCoord));
    }
*/
