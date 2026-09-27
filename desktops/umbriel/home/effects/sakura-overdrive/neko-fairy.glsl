float twinkle_ray(float across, float along, float reach, float aa) {
    float width = 0.68 * (1.0 - clamp(abs(along) / reach, 0.0, 1.0)) + 0.14;
    return (1.0 - smoothstep(width, width + aa, abs(across)))
        * (1.0 - smoothstep(reach - aa, reach, abs(along)));
}

float twinkle_shape(vec2 p, float size, float aa) {
    float vertical = twinkle_ray(p.x, p.y, size, aa);
    float horizontal = twinkle_ray(p.y, p.x, size * 0.68, aa);
    float core = 1.0 - smoothstep(0.65, 0.65 + aa, length(p));
    return max(core, max(vertical, horizontal));
}

vec4 twinkle_solid(vec3 rgb, float alpha) {
    float a = clamp(alpha, 0.0, 1.0);
    return vec4(rgb * a, a);
}

vec4 twinkle_over(vec4 paint, vec4 under) {
    return paint + under * (1.0 - paint.a);
}

vec4 cursor(vec2 uv) {
    vec4 source = umbriel_sample(uv);
    vec3 blush = umbriel_palette_count > 0
        ? umbriel_palette_at(0.0).rgb : vec3(0.976, 0.698, 0.824);
    vec3 fuchsia = umbriel_palette_count > 0
        ? umbriel_palette_at(0.25).rgb : vec3(0.949, 0.369, 0.831);
    vec3 blossom = mix(blush, vec3(1.0), 0.72);

    vec2 p = (uv - umbriel_pointer) * umbriel_size;
    float angle = umbriel_time * 1.45;
    vec2 at = vec2(cos(angle) * 14.0, sin(angle) * 9.0);
    vec2 q = p - at;
    float pulse = 0.5 + 0.5 * sin(umbriel_time * 3.2 + 0.7);
    float size = 4.7 + 1.2 * pulse;
    float alpha = 0.72 + 0.22 * pulse;
    float aa = 0.82 / max(umbriel_scale, 1.0);
    float star = twinkle_shape(q, size, aa);
    float glow = exp(-dot(q, q) / 30.0) * (0.060 + 0.035 * pulse);

    vec3 underRgb = min(
        source.rgb + mix(fuchsia, blush, 0.28) * glow * source.a,
        vec3(source.a)
    );
    vec4 under = vec4(underRgb, source.a);
    vec4 paint = twinkle_solid(blossom, star * alpha);
    float pin = 1.0 - smoothstep(0.25, 0.25 + aa, length(q));
    paint = twinkle_over(twinkle_solid(fuchsia, pin * 0.52), paint);
    return twinkle_over(paint, under);
}
