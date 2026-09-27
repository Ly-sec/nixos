float gh(float n) {
    return fract(sin(n) * 43758.5453);
}

vec4 animation(vec2 uv) {
    float p = umbriel_clamped_progress;
    float intensity = (1.0 - p) * (1.0 - p);

    float tick = floor(p * 60.0) + umbriel_random_seed.x * 1000.0;
    float r1 = gh(tick * 1.13);
    float r2 = gh(tick * 2.37);
    float r3 = gh(tick * 3.71);
    float r4 = gh(tick * 4.19);
    float r5 = gh(tick * 5.53);
    float r6 = gh(tick * 6.91);

    vec2 off_r = vec2(r1 - 0.5, r2 - 0.5) * intensity * 0.12;
    vec2 off_g = vec2(r3 - 0.5, r4 - 0.5) * intensity * 0.12;
    vec2 off_b = vec2(r5 - 0.5, r6 - 0.5) * intensity * 0.12;

    float slice = floor(uv.y * 20.0);
    float slice_offset = (gh(slice + tick) - 0.5) * intensity * 0.08;

    vec4 cr = umbriel_sample(uv + off_r + vec2(slice_offset * 0.7, 0.0));
    vec4 cg = umbriel_sample(uv + off_g + vec2(slice_offset * -0.5, 0.0));
    vec4 cb = umbriel_sample(uv + off_b + vec2(slice_offset * 0.3, 0.0));

    vec4 color;
    color.r = cr.r;
    color.g = cg.g;
    color.b = cb.b;
    color.a = max(max(cr.a, cg.a), cb.a);

    float big_glitch = step(0.85, gh(tick * 0.77));
    vec2 shift = vec2((gh(tick * 1.5) - 0.5) * 0.06 * big_glitch * intensity, 0.0);
    vec4 shifted = umbriel_sample(uv + shift);
    color = mix(color, shifted, big_glitch * intensity * 0.4);

    float scanline = 1.0 - sin(uv.y * umbriel_size.y * 3.14159) * 0.06 * intensity;
    color.rgb *= scanline;

    float alpha = smoothstep(0.0, 0.15, p);
    return color * alpha;
}
