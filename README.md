# underwater-image-enhancement-matlab
Underwater Image Enhancement using MATLAB - White Balance, CLAHE, Dark Channel Prior Dehazing
# Underwater Image Enhancement Using MATLAB

A complete MATLAB pipeline to enhance underwater images degraded by 
water absorption, scattering, and color distortion.

## Pipeline Stages
| Step | Method | Purpose |
|------|--------|---------|
| 1 | Input | Raw underwater image |
| 2 | White Balance | Shades of Gray method - fixes color cast |
| 3 | CLAHE | Adaptive histogram equalization - contrast |
| 4 | Dark Channel Prior | Dehazing / descattering |
| 5 | Unsharp Mask + Wiener | Sharpening and denoising |
| 6 | Gamma Correction | Brightness balancing |

## Results
| Metric | Original | Enhanced |
|--------|----------|----------|
| UIQM   | 0.1093   | 0.2698   |
| Entropy| 6.6410   | 6.7783   |

## Requirements
- MATLAB R2016b or later
- Image Processing Toolbox

## How to Run
1. Clone this repository
2. Open MATLAB and navigate to the project folder
3. Run `main.m`
4. Select your underwater image when prompted

## File Structure
- `main.m` — Master script, runs the full pipeline
- `whiteBalanceCorrection.m` — Shades of Gray white balance
- `applyCLAHE.m` — CLAHE contrast enhancement in LAB space
- `darkChannelDehaze.m` — Dark Channel Prior dehazing
- `sharpenAndDenoise.m` — Unsharp masking + Wiener filter
- `gammaCorrect.m` — Power-law gamma correction
- `evaluateMetrics.m` — PSNR, SSIM, UIQM metrics
- `computeUIQM.m` — Underwater Image Quality Measure

## References
- He et al. (2009) - Single Image Haze Removal Using Dark Channel Prior
- Panetta et al. (2016) - Human-Visual-System-Inspired Underwater Image Quality Measures
