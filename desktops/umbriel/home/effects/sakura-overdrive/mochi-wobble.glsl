const float RUSH_PI = 3.14159265359;
const float RUSH_TAU = 6.28318530718;

vec3 rush_blush() { return umbriel_palette_at(0.0).rgb; }
vec3 rush_fuchsia() { return umbriel_palette_at(0.25).rgb; }
vec3 rush_gold() { return umbriel_palette_at(0.5).rgb; }
vec3 rush_rose() { return umbriel_palette_at(0.75).rgb; }
vec3 rush_pearl() { return mix(rush_blush(), vec3(1.0), 0.68); }

void rush_overlay(
    inout vec4 under,
    vec3 straightColor,
    float opacity,
    float sourceAlpha
) {
    float coverage = smoothstep(0.01, 0.12, sourceAlpha);
    float a = clamp(opacity * coverage, 0.0, 1.0);
    under = vec4(straightColor * a, a) + under * (1.0 - a);
}

float rush_sakura_mask(vec2 px, float radius, float rotation) {
    if (max(abs(px.x), abs(px.y)) > radius) return 0.0;

    vec2 p = px / max(radius, 1.0);
    float field = 100.0;
    for (int i = 0; i < 5; i++) {
        float angle = rotation + float(i) * RUSH_TAU / 5.0;
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

void rush_add_sakura(
    inout vec4 color,
    float sourceAlpha,
    vec2 px,
    float radius,
    float rotation,
    float opacity
) {
    float flower = rush_sakura_mask(px, radius, rotation);
    float shade = clamp(length(px) / max(radius * 0.78, 1.0), 0.0, 1.0);
    vec3 petal = mix(rush_pearl(), rush_blush(), 0.16 + 0.34 * shade);
    rush_overlay(color, petal, flower * opacity * 0.92, sourceAlpha);

    float center = 1.0 - smoothstep(
        radius * 0.075,
        radius * 0.155,
        length(px)
    );
    rush_overlay(color, rush_gold(), center * opacity, sourceAlpha);
}

float rush_sparkle(vec2 px, float radius) {
    float vertical = (1.0 - smoothstep(0.7, 1.7, abs(px.x)))
        * (1.0 - smoothstep(radius * 0.15, radius, abs(px.y)));
    float horizontal = (1.0 - smoothstep(0.7, 1.7, abs(px.y)))
        * (1.0 - smoothstep(radius * 0.15, radius, abs(px.x)));
    float diamond = 1.0 - smoothstep(
        radius * 0.08,
        radius * 0.26,
        abs(px.x) + abs(px.y)
    );
    return max(max(vertical, horizontal), diamond);
}

float rush_trail_gate(float along, float head) {
    float behind = head - along;
    return smoothstep(-0.035, 0.060, behind)
        * (1.0 - smoothstep(0.52, 0.86, behind));
}

vec4 animation(vec2 uv) {
    float motion = umbriel_clamped_progress;
    float timeProgress = clamp(umbriel_linear_progress, 0.0, 1.0);
    if (timeProgress <= 0.0 || timeProgress >= 1.0) {
        return umbriel_sample(uv);
    }

    vec4 source = umbriel_sample(uv);
    vec4 color = source;
    vec2 size = max(umbriel_size, vec2(1.0));
    float direction = umbriel_direction < 0.0 ? -1.0 : 1.0;
    float along = direction > 0.0 ? uv.x : 1.0 - uv.x;
    float head = mix(-0.20, 1.28, motion);
    float gate = rush_trail_gate(along, head);
    float envelope = sin(RUSH_PI * timeProgress);
    envelope *= smoothstep(0.0, 0.10, timeProgress);

    float phase = umbriel_random_seed.x * RUSH_TAU;
    float y1 = 0.22 + 0.040 * sin(along * RUSH_TAU * 1.35 + phase);
    float y2 = 0.50 + 0.055 * sin(along * RUSH_TAU * 1.10 + phase + 2.1);
    float y3 = 0.78 + 0.035 * sin(along * RUSH_TAU * 1.55 + phase + 4.2);
    float d1 = abs(uv.y - y1) * size.y;
    float d2 = abs(uv.y - y2) * size.y;
    float d3 = abs(uv.y - y3) * size.y;

    float glow1 = 1.0 - smoothstep(2.0, 11.0, d1);
    float glow2 = 1.0 - smoothstep(2.0, 13.0, d2);
    float glow3 = 1.0 - smoothstep(2.0, 10.0, d3);
    float core1 = 1.0 - smoothstep(0.8, 2.3, d1);
    float core2 = 1.0 - smoothstep(0.8, 2.5, d2);
    float core3 = 1.0 - smoothstep(0.8, 2.1, d3);

    rush_overlay(
        color,
        rush_rose(),
        (glow1 * 0.28 + glow2 * 0.24 + glow3 * 0.20) * gate * envelope,
        source.a
    );
    rush_overlay(
        color,
        rush_fuchsia(),
        (core1 * 0.78 + core3 * 0.64) * gate * envelope,
        source.a
    );
    rush_overlay(
        color,
        rush_pearl(),
        core2 * gate * envelope * 0.90,
        source.a
    );
    rush_overlay(
        color,
        rush_gold(),
        min(core1 + core3, 1.0) * gate * envelope * 0.34,
        source.a
    );

    float flowerAlongA = head - 0.12;
    float flowerAlongB = head - 0.34;
    float flowerXA = direction > 0.0 ? flowerAlongA : 1.0 - flowerAlongA;
    float flowerXB = direction > 0.0 ? flowerAlongB : 1.0 - flowerAlongB;
    vec2 centerA = vec2(
        flowerXA,
        0.32 + 0.045 * sin(head * 8.0 + phase)
    );
    vec2 centerB = vec2(
        flowerXB,
        0.70 + 0.055 * sin(head * 6.0 + phase + 2.4)
    );

    rush_add_sakura(
        color,
        source.a,
        (uv - centerA) * size,
        22.0,
        phase + motion * 2.2,
        envelope * 0.92
    );
    rush_add_sakura(
        color,
        source.a,
        (uv - centerB) * size,
        15.0,
        -phase - motion * 1.7,
        envelope * 0.76
    );

    vec2 sparklePx = (uv - centerA) * size;
    float magentaSpark = rush_sparkle(
        sparklePx - vec2(direction * 1.8, 0.0),
        24.0
    );
    float goldSpark = rush_sparkle(
        sparklePx + vec2(direction * 1.8, 0.0),
        19.0
    );
    rush_overlay(
        color,
        rush_fuchsia(),
        magentaSpark * envelope * 0.68,
        source.a
    );
    rush_overlay(
        color,
        rush_gold(),
        goldSpark * envelope * 0.62,
        source.a
    );
    rush_overlay(
        color,
        rush_pearl(),
        rush_sparkle(sparklePx, 15.0) * envelope * 0.88,
        source.a
    );

    return color;
}
