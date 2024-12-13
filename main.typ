#set text(size: 14pt)
#show figure: set text(weight: "light", size: 12pt)

= Lightweight Model Design

- Objective: Minimize latency and memory usage for resource-constrained devices.
- Strategies:
  - Depthwise separable convolutions.
  - Reduced parameter count and FLOPs (floating-point operations).
  - Model tuning using hyperparameters:
    - Width Multiplier (α): Adjusts layer width.
    - Resolution Multiplier (ρ): Scales input image resolution.


= MobileNet Overview

- MobileNet is a lightweight convolutional neural network designed for mobile and embedded vision applications.
- Developed by Google to balance performance and computational efficiency.
- Utilizes depth-wise separable convolutions to reduce computation.

= Standard Convolution
#figure(
  image("image/standard-conv.png"),
  caption: [Standard convolution with 8x8x256 output],
)
== Steps involved:
- Applying a 3D kernel across spatial dimensions.
- Combining depth channels for feature extraction.

== Equation:
$
  y(h', w', c') = sum_(c = 1)^(C) sum_(m = 1)^(M) sum_(n = 1)^(N) x(h' + m, w' + n, c) dot k_(c') (m, n, c)
$
#text(style: "italic")[where:]
#block(inset: (x: 1.2em, y: 0em))[
  - $x$: Input feature map.
  - $k_i$: convolution kernel.
  - $y$: Output feature map.
]
== Metrics
- Input: $H dot W dot C$
- Output: $H' dot W' dot C'$
- Parameters: $M dot N dot C dot C'$
- Operations: $(H' dot W' dot C') dot (M dot N dot C)$

= Depth-wise Separable Convolution
== Idea
Break a standard convolution into two parts:
1. Depth-wise Convolution: Apply a single filter per input channel.
2. Point-wise Convolution: Use a 1x1 convolution to combine features across channels.

== Advantages:
- Reduces computation and parameters.
- Speeds up inference.

== Equation
- Depth-wise Convolution
#figure(
  image("image/depth-wise-conv.png"),
  caption: [Depth-wise convolution, use 3 kernels to transform a 12x12x3 image to a 8x8x3 image],
)
$
  y (h', w', c) = sum_(m = 1)^(M) sum_(n = 1)^(N) x(h' + m, w' + n, c) dot k_c (m, n, 1)
$
#text(style: "italic")[where:]
#block(inset: (x: 1.2em, y: 0em))[
  - $x$: Input feature map.
  - $k_i$: convolution kernel.
  - $y$: Output feature map.
]

- Metrics
  - Input: $H dot W dot C$
  - Output: $H' dot W' dot C$
  - Parameters: $M dot N dot C$
  - Operations: $(H' dot W' dot C) dot (M dot N)$

- Point-wise Convolution Equation:
#figure(
  image("image/point-wise-conv.png"),
  caption: [Point-wise convolution with 256 kernels, outputting an image with 256 channels],
)
$ y(h', w', c') = sum_(c = 1)^(C) y(h', w', c) dot k_(c')(1, 1, c) $
#text(style: "italic")[where:]
#block(inset: (x: 1.2em, y: 0em))[
  - $x$: Input feature map.
  - $k_i$: convolution kernel.
  - $y$: Output feature map.
]

- Metrics
  - Input: $H' dot W' dot C$
  - Output: $H' dot W' dot C'$
  - Parameters: $C dot C'$
  - Operations: $(H' dot W' dot C') dot C$

== Combined Metrics:
- Input: $H dot W dot C$
- Output: $H' dot W' dot C'$
- Parameters: $M dot N dot C + C dot C'$
- Operations: $(H' dot W' dot C) dot (M dot N + C')$

== Compare to Standard Convolution
=== Parameters
$
  "Params (Depthwise Separable)" / "Params (Standard)"
  &= (M dot N dot C + C dot C') / (M dot N dot C dot C') \
  &= 1 / (C') + 1 / (M dot N)
$

=== Operations
$
  "Ops (Depthwise Separable)" / "Ops (Standard)"
  &= ((H' dot W' dot C) dot (M dot N + C')) / ((H' dot W' dot C') dot (M dot N dot C)) \
  &= 1 / (C') + 1 / (M dot N)
$

Convolution significantly reduces both parameter count and operation count, approximately by a factor of:
$
  "Reduction Factor "= 1 / (C') + 1 / (M dot N)
$

= MobileNet V1

- Introduced depth-wise separable convolutions to replace standard convolutions.
- Achieved significant reductions in:
  - Model size (parameters).
  - Computation (FLOPs).

= MobileNet V2

- Improvement over V1 with better accuracy and efficiency.
- Introduced the Inverted Residual Block:
  - Expands input with point-wise convolution.
  - Applies depth-wise convolution.
  - Uses point-wise linear projection to compress the output.

- Linear Bottlenecks prevent information loss from non-linearities.

Comparison:
- MobileNet V2 achieves higher accuracy with fewer parameters compared to V1.

= Applications of MobileNet

- Real-time object detection on mobile devices.
- Image classification for embedded systems.
- Facial recognition in AR/VR systems.
- Autonomous driving and robotics.

= Conclusion

- MobileNet is a pioneering approach to designing lightweight neural networks.
- Depth-wise separable convolutions enable efficient computation.
- MobileNet V2 builds on V1 with improved architecture for better accuracy.
