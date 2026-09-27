vec4 animation(vec2 uv) {
    float visible = umbriel_direction > 0.0
        ? umbriel_clamped_progress : 1.0 - umbriel_clamped_progress;
    float easedVisible = visible * visible * (3.0 - 2.0 * visible);
    float scale = mix(0.88, 1.0, easedVisible);
    vec2 sourceUv = (uv - 0.5) / scale + 0.5;
    vec4 source = umbriel_sample(sourceUv);

    float radius = mix(0.0, 0.82, easedVisible);
    float distanceFromCenter = length((uv - 0.5) * vec2(1.0, umbriel_size.y / max(umbriel_size.x, 1.0)));
    float mask = 1.0 - smoothstep(radius - 0.10, radius, distanceFromCenter);
    float ring = exp(-abs(distanceFromCenter - radius) * 72.0)
        * smoothstep(0.02, 0.16, visible)
        * smoothstep(0.02, 0.16, 1.0 - visible);
    vec3 tint = mix(umbriel_palette_at(0.0).rgb, umbriel_palette_at(0.5).rgb, uv.x);
    float alpha = source.a * clamp(mask + ring * 0.24, 0.0, 1.0);
    vec3 rgb = source.rgb * mask + tint * source.a * ring * 0.20;
    return vec4(rgb, alpha);
}
