// Adapted from flowering-vine, copyright (c) 2026 Barrulus.
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#define ring_size umbriel_size
#define ring_width 2.0
#define ring_padding 3.0
#define ring_radius vec4(0.0)

float ring_distance(vec2 coords) {
    vec2 half_size = ring_size * 0.5;
    float radius = min(ring_radius.x, min(half_size.x, half_size.y));
    vec2 q = abs(coords - half_size) - half_size + radius;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}

// Compact animated cherry branches that remain usable on tiled windows.
const float VINE_SPEED = 0.56;
const float GROWTH_SECONDS = 12.0;
const float SPROUT_SPACING = 112.0;
const float BLOOM_DRIFT = 6.0;
const float VINE_OUTSET = 3.0;
const float VINE_INSET = 17.0;

float vine_hash(float p) { return fract(sin(p * 127.1 + 311.7) * 43758.5453); }

vec3 vine_blush() { return umbriel_palette_at(0.0).rgb; }
vec3 vine_fuchsia() { return umbriel_palette_at(0.25).rgb; }
vec3 vine_gold() { return umbriel_palette_at(0.5).rgb; }
vec3 vine_rose() { return umbriel_palette_at(0.75).rgb; }
vec3 vine_wine() { return mix(vine_rose(), vec3(0.035, 0.008, 0.028), 0.58); }
vec3 vine_pearl() { return mix(vine_blush(), vec3(1.0), 0.58); }

float vine_offset() {
    return min(ring_width * 0.55, min(ring_width + ring_padding, VINE_OUTSET) * 0.40);
}

vec4 vine_radii() {
    return clamp(ring_radius, 0.0, min(ring_size.x, ring_size.y) * 0.5) + vine_offset();
}

float vine_length() {
    vec2 size = ring_size + 2.0 * vine_offset();
    return 2.0 * (size.x + size.y) - (2.0 - 1.57079632679) * dot(vine_radii(), vec4(1.0));
}

// True arclength along a rounded reference contour through the middle of the
// braid. Unlike radial projection, straight-edge coordinates do not shear.
float vine_perimeter(vec2 coords) {
    vec2 p = coords + vine_offset();
    vec2 size = ring_size + 2.0 * vine_offset();
    vec4 r = vine_radii(); // TL, TR, BR, BL
    const float quarter = 1.57079632679;
    float top = size.x - r.x - r.y;
    float right_start = top + quarter * r.y;
    float br_start = right_start + size.y - r.y - r.z;
    float bottom_start = br_start + quarter * r.z;
    float bl_start = bottom_start + size.x - r.z - r.w;
    float left_start = bl_start + quarter * r.w;
    float tl_start = left_start + size.y - r.w - r.x;
    if (p.x >= size.x - r.y && p.y <= r.y)
        return top + r.y * atan(max(p.x - size.x + r.y, 0.00001), max(r.y - p.y, 0.00001));
    if (p.x >= size.x - r.z && p.y >= size.y - r.z)
        return br_start + r.z * atan(max(p.y - size.y + r.z, 0.00001), max(p.x - size.x + r.z, 0.00001));
    if (p.x <= r.w && p.y >= size.y - r.w)
        return bl_start + r.w * atan(max(r.w - p.x, 0.00001), max(p.y - size.y + r.w, 0.00001));
    if (p.x <= r.x && p.y <= r.x)
        return tl_start + r.x * atan(max(r.x - p.y, 0.00001), max(r.x - p.x, 0.00001));
    vec4 distances = abs(vec4(p.y, p.x - size.x, p.y - size.y, p.x));
    float nearest = min(min(distances.x, distances.y), min(distances.z, distances.w));
    if (nearest == distances.x) return clamp(p.x - r.x, 0.0, top);
    if (nearest == distances.y) return right_start + clamp(p.y - r.y, 0.0, size.y - r.y - r.z);
    if (nearest == distances.z) return bottom_start + clamp(size.x - r.z - p.x, 0.0, size.x - r.z - r.w);
    return left_start + clamp(size.y - r.w - p.y, 0.0, size.y - r.w - r.x);
}

// Inverse arclength: pixel position and UNIT tangent. A flower uses this rigid
// local frame, preserving round petals through the corners and perimeter seam.
vec4 vine_frame(float along) {
    float s = mod(along, vine_length());
    float offset = vine_offset();
    vec2 size = ring_size + 2.0 * offset;
    vec4 r = vine_radii();
    const float quarter = 1.57079632679;
    for (int side = 0; side < 4; side++) {
        float line;
        float radius;
        vec2 start;
        vec2 tangent;
        vec2 center;
        if (side == 0) {
            line = size.x - r.x - r.y; radius = r.y;
            start = vec2(r.x, 0.0); tangent = vec2(1.0, 0.0); center = vec2(size.x - r.y, r.y);
        } else if (side == 1) {
            line = size.y - r.y - r.z; radius = r.z;
            start = vec2(size.x, r.y); tangent = vec2(0.0, 1.0); center = vec2(size.x - r.z, size.y - r.z);
        } else if (side == 2) {
            line = size.x - r.z - r.w; radius = r.w;
            start = vec2(size.x - r.z, size.y); tangent = vec2(-1.0, 0.0); center = vec2(r.w, size.y - r.w);
        } else {
            line = size.y - r.w - r.x; radius = r.x;
            start = vec2(0.0, size.y - r.w); tangent = vec2(0.0, -1.0); center = vec2(r.x, r.x);
        }
        if (s <= line) return vec4(start + tangent * s - offset, tangent);
        s -= line;
        if (s <= quarter * radius || side == 3) {
            float angle = (float(side) - 1.0) * quarter + clamp(s / max(radius, 0.0001), 0.0, quarter);
            return vec4(center + radius * vec2(cos(angle), sin(angle)) - offset, -sin(angle), cos(angle));
        }
        s -= quarter * radius;
    }
    return vec4(r.x - offset, -offset, 1.0, 0.0);
}

float vine_height(float along, float perimeter, float t, float strand) {
    float u = along / perimeter;
    float turns = max(floor(perimeter / 145.0), 1.0);
    float phase = 6.28318530718 * turns * u - t * 0.95;
    // Hug the client; inward petals are continued by the matching window pass.
    float center = vine_offset();
    return center + ring_width * 0.31 * sin(phase + strand * 3.14159265359)
        + 0.55 * sin(6.28318530718 * u * (turns * 2.0 + 1.0) + t * 0.53);
}

float vine_segment(vec2 p, vec2 a, vec2 b) {
    vec2 v = b - a;
    return length(p - a - v * clamp(dot(p - a, v) / max(dot(v, v), 0.001), 0.0, 1.0));
}

vec2 vine_branch(float f, float height, float lean, float reach) {
    // Quadratic curve; a sprout grows along it rather than stretching the stem.
    vec2 a = vec2(0.0, height);
    vec2 b = vec2(lean * 0.12, height + reach * 0.65);
    vec2 c = vec2(lean, height + reach);
    return mix(mix(a, b, f), mix(b, c, f), f);
}

vec4 vine_over(vec4 under, vec3 color, float alpha) {
    alpha = clamp(alpha, 0.0, 1.0);
    return vec4(color * alpha + under.rgb * (1.0 - alpha), alpha + under.a * (1.0 - alpha));
}

vec4 vine_leaf(vec2 p, vec2 origin, vec2 direction, float size, float seed, float aa) {
    if (size < 0.1) return vec4(0.0);
    vec2 axis = normalize(direction);
    vec2 q = vec2(dot(p - origin, axis), dot(p - origin, vec2(-axis.y, axis.x)));
    float f = q.x / size;
    float width = size * 0.32 * pow(max(sin(clamp(f, 0.0, 1.0) * 3.14159265359), 0.0), 0.85);
    float cover = smoothstep(0.0, 0.08, f) * (1.0 - smoothstep(0.92, 1.0, f))
        * (1.0 - smoothstep(max(width - aa, 0.0), width + aa, abs(q.y)));
    float midrib = exp(-abs(q.y) * 2.7);
    float side_veins = pow(0.5 + 0.5 * sin(q.x * 2.2 - abs(q.y) * 2.6), 8.0);
    vec3 color = mix(vine_wine(), mix(vine_rose(), vine_fuchsia(), 0.24), 0.18 + 0.24 * seed);
    color *= 0.80 + 0.20 * smoothstep(-1.5, 1.5, q.y);
    color = mix(color, vine_blush(), midrib * 0.16);
    color *= 1.0 - side_veins * 0.12;
    return vec4(color, cover);
}

vec4 ring_color(vec2 coords) {
    if (ring_width <= 0.0 || min(ring_size.x, ring_size.y) <= 0.0) return vec4(0.0);
    float d = ring_distance(coords);
    float aa = 0.6 / max(umbriel_scale, 0.01);
    float extent = min(ring_width + ring_padding, VINE_OUTSET);
    // Border host clips the client; the window pass draws that same inner half.
    if (d <= -VINE_INSET || d >= extent) return vec4(0.0);
    float perimeter = vine_length();
    float along = vine_perimeter(coords);
    float t = umbriel_time * VINE_SPEED;
    vec4 paint = vec4(0.0);

    // Two gently moving stems weave over and under one another around the client.
    for (int strand = 0; strand < 2; strand++) {
        float center = vine_height(along, perimeter, t, float(strand));
        float distance = abs(d - center);
        float stem = 1.0 - smoothstep(0.72, 0.72 + aa, distance);
        float sheen = exp(-abs(d - center + 0.34) * 3.0);
        vec3 branch = mix(vine_wine(), mix(vine_wine(), vine_rose(), 0.28), float(strand));
        branch = mix(branch, vine_blush(), sheen * 0.14);
        paint = vine_over(paint, branch, stem * 0.94);
    }

    float cells = max(floor(perimeter / SPROUT_SPACING), 4.0);
    float spacing = perimeter / cells;
    // Move the lookup with the flowers so attachments remain continuous across
    // corners and the closing seam. Each sprout keeps its own growth clock.
    float drift = mod(umbriel_time * BLOOM_DRIFT + 5.0 * sin(t * 0.38), perimeter);
    float cell = floor((along - drift) / spacing);
    for (int neighbour = -1; neighbour <= 1; neighbour++) {
        float index = cell + float(neighbour);
        float id = mod(index, cells);
        float seed = vine_hash(id + 11.0);
        float wander = spacing * 0.13 * sin(t * 0.43 + seed * 19.0);
        float root_along = (index + 0.25 + seed * 0.5) * spacing + drift + wander;
        vec4 frame = vine_frame(root_along);
        vec2 relative = coords - frame.xy;
        vec2 normal = vec2(frame.w, -frame.z);
        vec2 p = vec2(dot(relative, frame.zw), dot(relative, normal) + vine_offset());
        if (abs(p.x) > 31.0) continue;
        float period = GROWTH_SECONDS + vine_hash(id + 51.0) * 7.0;
        float age = mod(umbriel_time + seed * period, period) / period;
        float visibility = smoothstep(0.0, 0.05, age) * (1.0 - smoothstep(0.86, 1.0, age));
        float growth = smoothstep(0.03, 0.32, age);
        float opening = smoothstep(0.28, 0.57, age);
        float root = vine_height(root_along, perimeter, t, step(0.5, seed));
        float facing = vine_hash(id + 103.0) < 0.5 ? -1.0 : 1.0;
        // Inward shoots extend over content; outward ones stay compact so they
        // remain visible when the window is against a screen edge.
        float room = facing < 0.0 ? VINE_INSET + root - 4.0 : extent - root - 4.0;
        float reach = facing * min(7.0 + vine_hash(id + 27.0) * 4.0, max(room, 0.0));
        float lean = (seed - 0.5) * 10.0 + sin(t * 0.9 + seed * 30.0) * 1.2;
        vec2 previous = vec2(0.0, root);
        float stem_distance = 1000.0;
        for (int segment = 1; segment <= 5; segment++) {
            vec2 next = vine_branch(float(segment) * growth / 5.0, root, lean, reach);
            stem_distance = min(stem_distance, vine_segment(p, previous, next));
            previous = next;
        }
        float sprout = (1.0 - smoothstep(0.42, 0.42 + aa, stem_distance)) * visibility * growth;
        paint = vine_over(paint, mix(vine_wine(), vine_rose(), 0.22), sprout);

        for (int leaf = 0; leaf < 2; leaf++) {
            float n = float(leaf);
            float location = 0.30 + n * 0.33;
            float unfolding = smoothstep(location, location + 0.24, growth);
            vec2 origin = vine_branch(location, root, lean, reach);
            float side = leaf == 0 ? -1.0 : 1.0;
            vec2 direction = vec2(side * (0.9 + seed * 0.2), facing * (0.48 + 0.18 * sin(t + seed * 12.0 + n)));
            float size = (4.5 + vine_hash(id + n * 23.0) * 2.0) * unfolding;
            vec4 foliage = vine_leaf(p, origin, direction, size, fract(seed + n * 0.4), aa);
            paint = vine_over(paint, foliage.rgb, foliage.a * visibility);
        }

        // Some shoots remain leafy, giving open flowers room between them.
        if (seed > 0.24) {
            vec2 tip = vine_branch(growth, root, lean, reach);
            vec2 q = p - tip;
            float angle = atan(q.y, q.x + 0.00001) + seed * 12.0 + 0.12 * sin(t + seed * 9.0);
            float lobe = pow(0.5 + 0.5 * cos(angle * 5.0), 0.72);
            float size = (3.8 + seed * 1.4) * opening + 0.5 * growth;
            float edge = size * mix(0.68, 0.55 + lobe * 0.45, opening);
            float flower = (1.0 - smoothstep(edge - aa, edge + aa, length(q))) * visibility * growth;
            vec3 petal = mix(vine_blush(), vine_pearl(), 0.26 + 0.34 * seed);
            float rim = smoothstep(size * 0.12, max(size * 0.94, 0.001), length(q));
            petal = mix(petal, mix(vine_fuchsia(), petal, 0.34), rim);
            paint = vine_over(paint, petal, flower);
            float center = (1.0 - smoothstep(1.0, 1.0 + aa, length(q))) * opening * visibility;
            paint = vine_over(paint, vine_gold(), center);
        }
    }

    float envelope = smoothstep(-VINE_INSET, -VINE_INSET + 2.0 * aa, d)
        * (1.0 - smoothstep(max(extent - 2.0 * aa, 0.0), extent, d));
    return vec4(clamp(paint.rgb / max(paint.a, 0.0001), 0.0, 1.0), paint.a * envelope);
}

// Blend premultiplied content with the same straight-RGBA flowers as the border.
vec4 postprocess(vec3 coords) {
    vec4 source = umbriel_sample(coords.xy);
    vec2 p = coords.xy * ring_size;
    if (min(min(p.x, p.y), min(ring_size.x - p.x, ring_size.y - p.y)) > VINE_INSET)
        return source;
    vec4 flowers = ring_color(p);
    float depth = max(-ring_distance(p), 0.0);
    flowers.a *= mix(1.0, 0.78, smoothstep(3.0, VINE_INSET, depth));
    return vec4(source.rgb * (1.0 - flowers.a) + flowers.rgb * flowers.a * source.a, source.a);
}

vec4 window(vec2 uv) { return postprocess(vec3(uv, 0.0)); }
