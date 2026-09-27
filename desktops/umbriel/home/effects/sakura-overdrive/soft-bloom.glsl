const float FOCUS_TAU = 6.28318530718;

vec3 focus_blush() { return umbriel_palette_at(0.0).rgb; }
vec3 focus_fuchsia() { return umbriel_palette_at(0.25).rgb; }
vec3 focus_gold() { return umbriel_palette_at(0.5).rgb; }
vec3 focus_rose() { return umbriel_palette_at(0.75).rgb; }
vec3 focus_pearl() { return mix(focus_blush(), vec3(1.0), 0.66); }
vec3 focus_wine() { return mix(focus_rose(), vec3(0.035, 0.008, 0.028), 0.58); }

void focus_paint(inout vec4 under, vec3 rgb, float alpha) {
    float a = clamp(alpha, 0.0, 1.0);
    under = vec4(rgb * a, a) + under * (1.0 - a);
}

float focus_box_distance(vec2 px, vec2 size, float inset) {
    vec2 halfSize = size * 0.5;
    vec2 extent = max(halfSize - vec2(inset), vec2(1.0));
    vec2 q = abs(px - halfSize) - extent;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

float focus_perimeter_length(vec2 size, float inset) {
    vec2 inner = max(size - vec2(2.0 * inset), vec2(1.0));
    return 2.0 * (inner.x + inner.y);
}

float focus_perimeter_at(vec2 px, vec2 size, float inset) {
    float width = max(size.x - 2.0 * inset, 1.0);
    float height = max(size.y - 2.0 * inset, 1.0);
    float top = abs(px.y - inset);
    float right = abs(px.x - (size.x - inset));
    float bottom = abs(px.y - (size.y - inset));
    float left = abs(px.x - inset);
    float nearest = min(min(top, right), min(bottom, left));

    if (nearest == top) return clamp(px.x - inset, 0.0, width);
    if (nearest == right) return width + clamp(px.y - inset, 0.0, height);
    if (nearest == bottom) {
        return width + height + clamp(size.x - inset - px.x, 0.0, width);
    }
    return 2.0 * width + height + clamp(size.y - inset - px.y, 0.0, height);
}

vec4 focus_frame(float along, vec2 size, float inset) {
    float width = max(size.x - 2.0 * inset, 1.0);
    float height = max(size.y - 2.0 * inset, 1.0);
    float perimeter = 2.0 * (width + height);
    float s = mod(along, perimeter);

    if (s <= width) return vec4(inset + s, inset, 1.0, 0.0);
    s -= width;
    if (s <= height) return vec4(size.x - inset, inset + s, 0.0, 1.0);
    s -= height;
    if (s <= width) return vec4(size.x - inset - s, size.y - inset, -1.0, 0.0);
    s -= width;
    return vec4(inset, size.y - inset - s, 0.0, -1.0);
}

float focus_sakura_mask(vec2 px, float radius, float rotation) {
    if (max(abs(px.x), abs(px.y)) > radius) return 0.0;

    vec2 p = px / max(radius, 1.0);
    float field = 100.0;

    for (int i = 0; i < 5; i++) {
        float angle = rotation + float(i) * FOCUS_TAU / 5.0;
        vec2 outward = vec2(cos(angle), sin(angle));
        vec2 sideways = vec2(-outward.y, outward.x);
        vec2 petal = vec2(dot(p, sideways), dot(p, outward)) - vec2(0.0, 0.32);
        float ellipse = length(petal / vec2(0.215, 0.43)) - 1.0;
        float notch = length((petal - vec2(0.0, 0.405)) / vec2(0.085, 0.070)) - 1.0;
        field = min(field, max(ellipse, -notch));
    }

    return 1.0 - smoothstep(-0.025, 0.035, field);
}

void focus_add_sakura(
    inout vec4 color,
    vec2 px,
    float radius,
    float rotation,
    float opacity
) {
    float flower = focus_sakura_mask(px, radius, rotation);
    float shade = clamp(length(px) / max(radius * 0.78, 1.0), 0.0, 1.0);
    vec3 petal = mix(focus_pearl(), focus_blush(), 0.18 + 0.30 * shade);
    focus_paint(color, petal, flower * opacity * 0.94);
    float center = 1.0 - smoothstep(radius * 0.075, radius * 0.155, length(px));
    focus_paint(color, focus_gold(), center * opacity);
}

float focus_sparkle(vec2 px, float radius) {
    float vertical = (1.0 - smoothstep(0.6, 1.6, abs(px.x)))
        * (1.0 - smoothstep(radius * 0.18, radius, abs(px.y)));
    float horizontal = (1.0 - smoothstep(0.6, 1.6, abs(px.y)))
        * (1.0 - smoothstep(radius * 0.18, radius, abs(px.x)));
    float center = 1.0 - smoothstep(
        radius * 0.08,
        radius * 0.25,
        abs(px.x) + abs(px.y)
    );
    return max(max(vertical, horizontal), center);
}

vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;
    if (progress <= 0.0 || progress >= 1.0) return umbriel_sample(uv);

    vec4 source = umbriel_sample(uv);
    if (umbriel_direction < 0.0) return source;

    vec2 size = max(umbriel_size, vec2(1.0));
    vec2 px = uv * size;
    float inset = min(4.0, min(size.x, size.y) * 0.18);
    float distanceToPath = focus_box_distance(px, size, inset);
    if (abs(distanceToPath) > 18.0 && source.a < 0.001) return source;

    float perimeter = focus_perimeter_length(size, inset);
    float along = focus_perimeter_at(px, size, inset);
    float normalizedAlong = along / perimeter;
    float motion = smoothstep(0.02, 0.92, progress);
    float gaining = 1.0;
    float travel = motion;
    float start = 0.08;
    float head = fract(start + travel);

    float behind = gaining > 0.5
        ? mod(head - normalizedAlong + 1.0, 1.0)
        : mod(normalizedAlong - head + 1.0, 1.0);
    float trail = 1.0 - smoothstep(0.0, 0.22, behind);
    float circularDelta = abs(normalizedAlong - head);
    circularDelta = min(circularDelta, 1.0 - circularDelta);
    float headLight = exp(-pow(circularDelta / 0.026, 2.0));
    float envelope = smoothstep(0.0, 0.14, progress)
        * (1.0 - smoothstep(0.72, 1.0, progress));
    float wideLine = 1.0 - smoothstep(2.5, 9.0, abs(distanceToPath));
    float pearlLine = 1.0 - smoothstep(0.6, 2.8, abs(distanceToPath));
    float strength = mix(0.42, 1.0, gaining);

    vec4 color = source;
    vec3 trailColor = mix(focus_wine(), focus_fuchsia(), gaining);
    focus_paint(color, trailColor, wideLine * trail * envelope * strength * 0.72);
    focus_paint(color, focus_pearl(), pearlLine * headLight * envelope * strength * 0.96);
    focus_paint(color, focus_gold(), wideLine * headLight * envelope * strength * 0.58);

    vec4 headFrame = focus_frame(head * perimeter, size, inset);
    vec2 headTowardCenter = normalize(size * 0.5 - headFrame.xy);
    vec2 flowerCenter = headFrame.xy + headTowardCenter * 12.0;
    float flowerOpacity = envelope * mix(0.34, 0.96, gaining);
    focus_add_sakura(
        color,
        px - flowerCenter,
        mix(6.0, 10.0, envelope),
        0.45 + 1.8 * progress + umbriel_random_seed.y * FOCUS_TAU,
        flowerOpacity
    );

    float secondAlong = (head - mix(-0.075, 0.075, gaining)) * perimeter;
    vec4 secondFrame = focus_frame(secondAlong, size, inset);
    vec2 secondTowardCenter = normalize(size * 0.5 - secondFrame.xy);
    vec2 secondCenter = secondFrame.xy + secondTowardCenter * 9.0;
    focus_add_sakura(
        color,
        px - secondCenter,
        7.0,
        -0.6 - 1.2 * progress + umbriel_random_seed.z * FOCUS_TAU,
        flowerOpacity * 0.68
    );

    float sparkle = focus_sparkle(px - flowerCenter, 12.0);
    focus_paint(
        color,
        focus_pearl(),
        sparkle * headLight * envelope * mix(0.35, 0.92, gaining)
    );
    return color;
}
