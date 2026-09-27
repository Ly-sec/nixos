float crescent_fill(float distanceField, float aa) {
    return 1.0 - smoothstep(-aa, aa, distanceField);
}

float crescent_glint(vec2 p, float aa) {
    float vertical = (1.0 - smoothstep(0.35, 0.35 + aa, abs(p.x)))
        * (1.0 - smoothstep(5.2, 6.5, abs(p.y)));
    float horizontal = (1.0 - smoothstep(0.35, 0.35 + aa, abs(p.y)))
        * (1.0 - smoothstep(3.0, 4.2, abs(p.x)));
    float core = 1.0 - smoothstep(1.0, 1.0 + aa, length(p));
    return max(core, max(vertical, horizontal));
}

vec4 crescent_solid(vec3 rgb, float alpha) {
    float a = clamp(alpha, 0.0, 1.0);
    return vec4(rgb * a, a);
}

vec4 crescent_over(vec4 paint, vec4 under) {
    return paint + under * (1.0 - paint.a);
}

vec4 cursor(vec2 uv) {
    vec4 source = umbriel_sample(uv);
    vec3 blush = umbriel_palette_count > 0
        ? umbriel_palette_at(0.0).rgb : vec3(0.953, 0.694, 0.824);
    vec3 fuchsia = umbriel_palette_count > 0
        ? umbriel_palette_at(0.25).rgb : vec3(0.784, 0.278, 0.686);
    vec3 blossom = mix(blush, vec3(1.0), 0.58);

    vec2 p = (uv - umbriel_pointer) * umbriel_size;
    float aa = 0.70 / max(umbriel_scale, 1.0);
    float outer = length(p) - 19.0;
    float cutout = 17.2 - length(p - vec2(4.2, -0.8));
    float moonDistance = max(outer, cutout);
    float moon = crescent_fill(moonDistance, aa);
    float aura = exp(-max(moonDistance, 0.0) * max(moonDistance, 0.0) / 22.0)
        * 0.045;

    vec2 glintPoint = p - vec2(18.5, -14.5);
    float glint = crescent_glint(glintPoint, aa);
    float pulse = 0.88 + 0.12 * sin(umbriel_time * 2.8);
    float glintCore = 1.0 - smoothstep(0.45, 1.1, length(glintPoint));

    vec3 underRgb = min(
        source.rgb + mix(fuchsia, blush, 0.55) * aura * source.a,
        vec3(source.a)
    );
    vec4 result = vec4(underRgb, source.a);
    vec4 paint = crescent_solid(mix(fuchsia, blush, 0.76), moon * 0.80);
    paint = crescent_over(crescent_solid(blossom, glint * pulse * 0.92), paint);
    paint = crescent_over(crescent_solid(fuchsia, glintCore * 0.28), paint);
    return crescent_over(paint, result);
}
