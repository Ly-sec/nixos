vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;
    float envelope = sin(3.14159265359 * progress);
    vec4 source = umbriel_sample(uv);

    float along = umbriel_direction >= 0.0 ? uv.x : 1.0 - uv.x;
    float bandCenter = mix(-0.18, 1.18, progress);
    float track = along + uv.y * 0.16;
    float roseBand = exp(-pow((track - bandCenter) * 9.0, 2.0));
    float pearlBand = exp(-pow((track - bandCenter - 0.035) * 18.0, 2.0));
    vec3 rose = umbriel_palette_at(0.0).rgb;
    vec3 gold = umbriel_palette_at(0.5).rgb;
    vec3 light = rose * roseBand * 0.026 + gold * pearlBand * 0.014;
    return vec4(source.rgb + light * source.a * envelope, source.a);
}
