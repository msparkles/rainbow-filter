// Fragment shader

struct VSOutput {
  @builtin(position) position: vec4<f32>,
  @location(0) uv: vec2<f32>,
};

@group(0) @binding(0)
var texture: texture_2d<f32>;
@group(0) @binding(1)
var sample: sampler;

struct Uniform {
    time: vec4<f32>, // everything but x is padding 
};
@group(1) @binding(0)
var<uniform> uniform: Uniform;

fn rgb2hsl(c: vec3<f32>) -> vec3<f32> { 
    let K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0); 
    let p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g)); 
    let q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r)); 
    
    let d = q.x - min(q.w, q.y); 
    let e = 1.0e-10;

    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
} 

fn hsl2rgb(c: vec3<f32>) -> vec3<f32> {
  let K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);

  return c.z * mix(K.xxx, clamp(p - K.xxx, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), c.y);
}

@fragment
fn fs_main(in: VSOutput) -> @location(0) vec4<f32> {
    let uv = vec2(in.uv.x, 1.0 - in.uv.y);
    var hsl = rgb2hsl(textureSample(texture, sample, uv).rgb);
    hsl.x += uniform.time.x / 4.0;
    hsl.x %= 360.0;

    return vec4(hsl2rgb(hsl), 1.0);
}

@vertex
fn vs_main(
    @builtin(vertex_index) index: u32,
) -> VSOutput {
    var result: VSOutput;

    var uv = vec2(f32((index << 1u) & 2u), f32(index & 2u));

    result.uv = uv;
    result.position = vec4(uv * 2.0f - 1.0f, 0.0f, 1.0f);

    return result;
}
