vec4 screen(vec2 uv) {
    vec4 source = umbriel_sample(uv);
    vec4 primary = umbriel_palette_at(0.0);
    vec4 secondary = umbriel_palette_at(0.25);

    vec2 p = uv - 0.5;
    float edge = smoothstep(0.34, 0.78, length(p * vec2(1.0, 0.82)));
    float highlight = smoothstep(0.55, 1.0, dot(source.rgb, vec3(0.2126, 0.7152, 0.0722)));
    vec3 graded = mix(source.rgb, primary.rgb, 0.018);
    graded += secondary.rgb * highlight * 0.012;
    graded *= 1.0 - edge * 0.055;
    return vec4(graded, source.a);
}
