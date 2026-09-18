// Dissolve the window by opening a field of organic circular holes.

vec2 hole_random(vec2 cell) {
    vec2 seed = vec2(
        dot(cell, vec2(127.1, 311.7)),
        dot(cell, vec2(269.5, 183.3))
    );
    return fract(sin(seed) * 43758.5453123);
}

float hole_mask(vec2 uv, float visible) {
    const float spacing = 72.0;
    const float jitter = 0.70;

    vec2 logical = (uv - 0.5) * max(umbriel_size, vec2(1.0));
    vec2 point = logical / spacing;
    vec2 base = floor(point);
    vec2 local = fract(point);
    float feather = 1.35 / spacing;
    float mask = 1.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 offset = vec2(float(x), float(y));
            vec2 id = base + offset;
            vec2 random_value = hole_random(id);
            vec2 center = offset + 0.5
                + (random_value - 0.5) * jitter;

            float close_start = 0.02 + 0.12 * random_value.x;
            float close_end = 0.72 + 0.22 * random_value.y;
            float closed = smoothstep(close_start, close_end, visible);
            closed = pow(closed, 0.55);

            float size_seed = fract(
                random_value.x * 17.0 + random_value.y * 29.0
            );
            float size_curve = mix(0.45, 2.20, size_seed);
            float hole_open = pow(1.0 - closed, size_curve);
            float radius = mix(-feather, 1.30, hole_open);
            float outside = smoothstep(
                radius - feather,
                radius + feather,
                length(local - center)
            );
            mask = min(mask, outside);
        }
    }

    return mask;
}

vec4 animation(vec2 uv) {
    float visible = 1.0 - clamp(umbriel_linear_progress, 0.0, 1.0);
    return umbriel_sample(uv) * hole_mask(uv, visible);
}
