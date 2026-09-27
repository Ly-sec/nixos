const float SAKURA_ANIMATION_TAU = 6.28318530718;

vec3 animation_blush() {
    return umbriel_palette_at(0.0).rgb;
}

vec3 animation_fuchsia() {
    return umbriel_palette_at(0.25).rgb;
}

vec3 animation_gold() {
    return umbriel_palette_at(0.5).rgb;
}

vec3 animation_rose() {
    return umbriel_palette_at(0.75).rgb;
}

vec3 animation_wine() {
    return mix(animation_rose(), vec3(0.035, 0.008, 0.028), 0.70);
}

vec3 animation_dusty_rose() {
    return mix(animation_blush(), animation_rose(), 0.48);
}

vec3 animation_petal_white() {
    return mix(animation_blush(), vec3(1.0), 0.58);
}

vec4 animation_soft_sample(vec2 uv, float radiusPx) {
    if (radiusPx < 0.25) {
        return umbriel_sample(uv);
    }

    vec2 size = max(umbriel_size, vec2(1.0));
    vec2 offset = vec2(radiusPx) / size;
    vec2 lo = vec2(0.0);
    vec2 hi = vec2(1.0);
    vec4 color = umbriel_sample(uv) * 0.25;
    color += umbriel_sample(clamp(uv + vec2(offset.x, 0.0), lo, hi)) * 0.125;
    color += umbriel_sample(clamp(uv - vec2(offset.x, 0.0), lo, hi)) * 0.125;
    color += umbriel_sample(clamp(uv + vec2(0.0, offset.y), lo, hi)) * 0.125;
    color += umbriel_sample(clamp(uv - vec2(0.0, offset.y), lo, hi)) * 0.125;
    color += umbriel_sample(clamp(uv + offset, lo, hi)) * 0.0625;
    color += umbriel_sample(clamp(uv - offset, lo, hi)) * 0.0625;
    color += umbriel_sample(clamp(uv + vec2(offset.x, -offset.y), lo, hi)) * 0.0625;
    color += umbriel_sample(clamp(uv + vec2(-offset.x, offset.y), lo, hi)) * 0.0625;
    return color;
}

void animation_paint(inout vec4 under, vec3 rgb, float alpha) {
    float a = clamp(alpha, 0.0, 1.0);
    under = vec4(rgb * a, a) + under * (1.0 - a);
}

float animation_life(float progress, float begin, float peak, float end) {
    return smoothstep(begin, peak, progress)
        * (1.0 - smoothstep(peak, end, progress));
}

float animation_sakura_mask(vec2 px, float radius, float rotation) {
    vec2 p = px / max(radius, 1.0);
    float field = 100.0;

    for (int i = 0; i < 5; i++) {
        float angle = rotation + float(i) * SAKURA_ANIMATION_TAU / 5.0;
        vec2 outward = vec2(cos(angle), sin(angle));
        vec2 sideways = vec2(-outward.y, outward.x);
        vec2 petal = vec2(dot(p, sideways), dot(p, outward));
        petal -= vec2(0.0, 0.32);
        float ellipse = length(petal / vec2(0.215, 0.43)) - 1.0;
        float notch = length(
            (petal - vec2(0.0, 0.405)) / vec2(0.085, 0.070)
        ) - 1.0;
        field = min(field, max(ellipse, -notch));
    }

    return 1.0 - smoothstep(-0.025, 0.035, field);
}

void animation_add_sakura(
    inout vec4 color,
    vec2 px,
    float radius,
    float rotation,
    float opacity
) {
    float flower = animation_sakura_mask(px, radius, rotation);
    float shade = clamp(length(px) / max(radius * 0.78, 1.0), 0.0, 1.0);
    vec3 petalColor = mix(
        animation_petal_white(),
        animation_dusty_rose(),
        0.18 + 0.34 * shade
    );
    animation_paint(color, petalColor, flower * opacity * 0.94);

    float center = 1.0 - smoothstep(
        radius * 0.075,
        radius * 0.155,
        length(px)
    );
    animation_paint(color, animation_gold(), center * opacity * 0.96);

    vec2 gleamOffset = vec2(-0.035, -0.045) * radius;
    float gleam = 1.0 - smoothstep(
        radius * 0.018,
        radius * 0.060,
        length(px - gleamOffset)
    );
    animation_paint(color, animation_petal_white(), gleam * opacity);
}

float animation_sparkle_mask(vec2 px, float radius) {
    float vertical = (1.0 - smoothstep(0.7, 1.8, abs(px.x)))
        * (1.0 - smoothstep(radius * 0.20, radius, abs(px.y)));
    float horizontal = (1.0 - smoothstep(0.7, 1.8, abs(px.y)))
        * (1.0 - smoothstep(radius * 0.20, radius, abs(px.x)));
    float diamond = 1.0 - smoothstep(
        radius * 0.10,
        radius * 0.28,
        abs(px.x) + abs(px.y)
    );
    return max(max(vertical, horizontal), diamond);
}

void animation_add_sparkle(
    inout vec4 color,
    vec2 px,
    float radius,
    float opacity
) {
    float sparkle = animation_sparkle_mask(px, radius);
    animation_paint(color, animation_petal_white(), sparkle * opacity);
    float core = 1.0 - smoothstep(0.0, 2.2, length(px));
    animation_paint(color, animation_gold(), core * opacity);
}

void animation_add_magic_circle(
    inout vec4 color,
    vec2 px,
    float radius,
    float rotation,
    float opacity
) {
    float r = length(px);
    float angle = atan(px.y, px.x) - rotation;
    float outer = 1.0 - smoothstep(2.0, 4.0, abs(r - radius));
    float inner = 1.0 - smoothstep(1.0, 2.3, abs(r - radius * 0.82));
    float blossomRadius = radius * (0.60 + 0.075 * cos(5.0 * angle));
    float blossomLine = 1.0 - smoothstep(1.0, 2.5, abs(r - blossomRadius));
    float rays = 1.0 - smoothstep(0.0, 0.035, abs(sin(5.0 * angle)));
    rays *= smoothstep(radius * 0.22, radius * 0.28, r);
    rays *= 1.0 - smoothstep(radius * 0.53, radius * 0.62, r);
    float dashes = 0.5 + 0.5 * sin(20.0 * angle + rotation * 7.0);
    dashes = smoothstep(0.30, 0.72, dashes);

    animation_paint(color, animation_dusty_rose(), outer * opacity * 0.70);
    animation_paint(color, animation_petal_white(), inner * opacity * 0.80);
    animation_paint(color, animation_gold(), blossomLine * opacity * 0.90);
    animation_paint(color, animation_fuchsia(), rays * opacity * 0.42);
    animation_paint(color, animation_gold(), outer * dashes * opacity * 0.70);
}

vec4 animation_opening(vec2 uv, float progress) {
    vec2 size = max(umbriel_size, vec2(1.0));
    float shortSide = min(size.x, size.y);
    vec2 seedOffset = (umbriel_random_seed.xy - 0.5) * vec2(0.045, 0.035);
    vec2 center = vec2(0.50, 0.52) + seedOffset;
    vec2 px = (uv - center) * size;
    float r = length(px);
    float angle = atan(px.y, px.x);

    float growth = smoothstep(0.035, 0.90, progress);
    float maximum = 0.58 * length(size) + 64.0;
    float spiral = (
        18.0 * sin(
            2.0 * angle - 8.0 * progress
            + umbriel_random_seed.z * SAKURA_ANIMATION_TAU
        )
        + 7.0 * sin(5.0 * angle + umbriel_random_seed.w * SAKURA_ANIMATION_TAU)
    ) * (1.0 - growth);
    float front = mix(-36.0, maximum, growth) + spiral;
    float reveal = 1.0 - smoothstep(front - 9.0, front + 9.0, r);
    float blurPx = 6.0 * (1.0 - growth);
    vec4 color = animation_soft_sample(uv, blurPx) * reveal;

    float ribbonLife = animation_life(progress, 0.045, 0.34, 0.92);
    float edgeDistance = abs(r - front);
    float wideRibbon = 1.0 - smoothstep(5.0, 15.0, edgeDistance);
    float brightRibbon = 1.0 - smoothstep(1.5, 5.0, edgeDistance);
    float pearlRibbon = 1.0 - smoothstep(0.4, 1.9, edgeDistance);
    float ribbonGlint = smoothstep(
        0.15,
        0.82,
        0.5 + 0.5 * sin(9.0 * angle + 24.0 * progress)
    );
    animation_paint(color, animation_dusty_rose(), wideRibbon * ribbonLife * 0.42);
    animation_paint(color, animation_fuchsia(), brightRibbon * ribbonLife * 0.72);
    animation_paint(color, animation_petal_white(), pearlRibbon * ribbonLife * 0.94);
    animation_paint(
        color,
        animation_gold(),
        brightRibbon * ribbonGlint * ribbonLife * 0.62
    );

    float circleLife = animation_life(progress, 0.010, 0.15, 0.50);
    float circleRadius = mix(
        18.0,
        shortSide * 0.34,
        smoothstep(0.02, 0.52, progress)
    );
    animation_add_magic_circle(
        color,
        px,
        circleRadius,
        1.7 * progress + umbriel_random_seed.x * SAKURA_ANIMATION_TAU,
        circleLife
    );

    vec2 jitterA = (umbriel_random_seed.zw - 0.5) * vec2(0.025, 0.030);
    vec2 jitterB = (umbriel_random_seed.yx - 0.5) * vec2(0.025, 0.030);
    float bloomA = animation_life(progress, 0.10, 0.25, 0.62);
    float bloomB = animation_life(progress, 0.18, 0.33, 0.70);
    float bloomC = animation_life(progress, 0.26, 0.41, 0.78);
    float bloomD = animation_life(progress, 0.34, 0.49, 0.86);
    animation_add_sakura(
        color,
        (uv - (vec2(0.22, 0.27) + jitterA)) * size,
        mix(9.0, 48.0, smoothstep(0.12, 0.31, progress)),
        0.25 + progress,
        bloomA
    );
    animation_add_sakura(
        color,
        (uv - (vec2(0.77, 0.32) + jitterB)) * size,
        mix(8.0, 39.0, smoothstep(0.19, 0.38, progress)),
        -0.35 - 0.8 * progress,
        bloomB
    );
    animation_add_sakura(
        color,
        (uv - (vec2(0.31, 0.76) - jitterB)) * size,
        mix(7.0, 34.0, smoothstep(0.26, 0.45, progress)),
        0.70 + 0.6 * progress,
        bloomC
    );
    animation_add_sakura(
        color,
        (uv - (vec2(0.72, 0.72) - jitterA)) * size,
        mix(7.0, 30.0, smoothstep(0.33, 0.52, progress)),
        -0.10 - progress,
        bloomD
    );

    float sparkleLife = animation_life(progress, 0.43, 0.66, 0.94);
    animation_add_sparkle(
        color,
        (uv - (vec2(0.16, 0.61) + jitterA)) * size,
        24.0,
        sparkleLife
    );
    animation_add_sparkle(
        color,
        (uv - (vec2(0.84, 0.54) + jitterB)) * size,
        18.0,
        sparkleLife * 0.82
    );
    animation_add_sparkle(
        color,
        (uv - (vec2(0.56, 0.19) - jitterA)) * size,
        13.0,
        sparkleLife * 0.70
    );
    return color;
}

vec4 animation_closing(vec2 uv, float progress) {
    vec2 size = max(umbriel_size, vec2(1.0));
    float shortSide = min(size.x, size.y);
    vec2 center = vec2(0.50, 0.50)
        + (umbriel_random_seed.zw - 0.5) * vec2(0.025, 0.020);
    vec2 px = (uv - center) * size;
    float r = length(px);
    float angle = atan(px.y, px.x);
    float rotation = 0.35 + umbriel_random_seed.x * SAKURA_ANIMATION_TAU
        + 1.35 * progress;

    float lobe = 0.78 + 0.22 * cos(5.0 * (angle - rotation));
    float flowerField = r / lobe;
    float closingMotion = smoothstep(0.06, 0.94, progress);
    float threshold = mix(length(size) + 80.0, -32.0, closingMotion);
    float keep = 1.0 - smoothstep(
        threshold - 8.0,
        threshold + 8.0,
        flowerField
    );
    float blurPx = 6.0 * closingMotion;
    vec4 color = animation_soft_sample(uv, blurPx) * keep;

    float edgeLife = animation_life(progress, 0.035, 0.40, 0.95);
    float petalEdge = 1.0 - smoothstep(
        2.0,
        9.0,
        abs(flowerField - threshold)
    );
    float edgeSpark = smoothstep(
        0.22,
        0.86,
        0.5 + 0.5 * sin(15.0 * angle - 30.0 * progress)
    );
    animation_paint(color, animation_wine(), petalEdge * edgeLife * 0.52);
    animation_paint(color, animation_fuchsia(), petalEdge * edgeLife * 0.74);
    animation_paint(
        color,
        animation_petal_white(),
        petalEdge * edgeSpark * edgeLife * 0.88
    );
    animation_paint(
        color,
        animation_gold(),
        petalEdge * edgeSpark * edgeLife * 0.44
    );

    float sealLife = animation_life(progress, 0.010, 0.14, 0.42);
    float sealRadius = mix(
        shortSide * 0.18,
        shortSide * 0.43,
        smoothstep(0.01, 0.34, progress)
    );
    animation_add_magic_circle(
        color,
        px,
        sealRadius,
        rotation + 1.6 * progress,
        sealLife
    );

    vec2 wind = vec2(110.0, -145.0) * progress / size;
    vec2 jitterA = (umbriel_random_seed.xy - 0.5) * vec2(0.025, 0.030);
    vec2 jitterB = (umbriel_random_seed.wz - 0.5) * vec2(0.025, 0.030);
    float scatterA = animation_life(progress, 0.17, 0.36, 0.84);
    float scatterB = animation_life(progress, 0.25, 0.44, 0.90);
    float scatterC = animation_life(progress, 0.33, 0.52, 0.94);
    animation_add_sakura(
        color,
        (uv - (vec2(0.25, 0.70) + jitterA + wind)) * size,
        mix(44.0, 24.0, progress),
        rotation + 0.7,
        scatterA
    );
    animation_add_sakura(
        color,
        (uv - (vec2(0.68, 0.61) + jitterB + wind * 1.25)) * size,
        mix(36.0, 19.0, progress),
        rotation - 0.8,
        scatterB
    );
    animation_add_sakura(
        color,
        (uv - (vec2(0.47, 0.30) - jitterA + wind * 1.55)) * size,
        mix(30.0, 15.0, progress),
        rotation + 1.8,
        scatterC
    );

    float sparkleLife = animation_life(progress, 0.39, 0.64, 0.96);
    animation_add_sparkle(
        color,
        (uv - (vec2(0.18, 0.40) + wind * 0.8)) * size,
        21.0,
        sparkleLife
    );
    animation_add_sparkle(
        color,
        (uv - (vec2(0.79, 0.72) + wind * 1.4)) * size,
        16.0,
        sparkleLife * 0.82
    );
    animation_add_sparkle(
        color,
        (uv - (center + wind * 0.45)) * size,
        27.0,
        sparkleLife * 0.74
    );
    return color;
}

vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;
    bool opening = umbriel_direction > 0.0;
    if (progress <= 0.0) {
        return opening ? vec4(0.0) : umbriel_sample(uv);
    }
    if (progress >= 1.0) {
        return opening ? umbriel_sample(uv) : vec4(0.0);
    }
    return opening
        ? animation_opening(uv, progress)
        : animation_closing(uv, progress);
}
