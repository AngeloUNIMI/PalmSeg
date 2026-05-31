<div align="center">

# ✋ PalmSeg

### Palmprint Segmentation and ROI Extraction for Touchless Biometrics

[![MATLAB](https://img.shields.io/badge/MATLAB-R2018%2B-orange?logo=mathworks)](https://www.mathworks.com/products/matlab.html)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Repository](https://img.shields.io/badge/GitHub-AngeloUNIMI%2FPalmSeg-181717?logo=github)](https://github.com/AngeloUNIMI/PalmSeg)
[![Topic](https://img.shields.io/badge/Topic-Palmprint%20Segmentation-green)](https://github.com/AngeloUNIMI/PalmSeg)

**MATLAB source code for palmprint segmentation and region-of-interest extraction**  
Used in the IEEE TIFS 2019 and IEEE CIVEMSA 2019 palmprint recognition works.

</div>

---

## 🌟 Overview

**PalmSeg** provides a complete MATLAB pipeline for processing palmprint images acquired in less-constrained or touchless scenarios.

The code extracts the palm shape, detects anatomical landmarks, estimates palm orientation, and crops a normalized palmprint **region of interest (ROI)** that can be used by recognition systems such as **PalmNet**.

<div align="center">

```text
Input palm image
       │
       ▼
Palm segmentation
       │
       ▼
Valley-point detection
       │
       ▼
Orientation and centroid estimation
       │
       ▼
ROI extraction
       │
       ▼
Normalized palmprint ROI
```

</div>

---

## 🧠 What PalmSeg Does

PalmSeg is designed to support palmprint recognition pipelines by producing consistent ROI crops from hand images.

Main processing steps include:

- **Palm and hand segmentation** from the input image
- **Finger-valley localization** for geometric alignment
- **Palm center and orientation estimation**
- **Adaptive ROI extraction** based on hand geometry
- **Graphic result generation** for visual inspection
- **Dataset-specific parameter configuration**

---

## 📁 Repository Structure

```text
PalmSeg/
│
├── launch_PalmSeg.m                         # Main MATLAB script
├── LICENSE                                  # GPL-3.0 license
├── README.md                                # Project documentation
│
├── Functions_Preproc/                       # Pre-processing utilities
├── Functions_ROI/                           # ROI extraction functions
├── Functions_Segm/                          # Segmentation functions
├── params/                                  # Dataset-specific parameter files
├── util/                                    # General utilities
│
└── images/
    └── Tongji_Contactless_Palmprint_Dataset/ # Example dataset folder structure
```

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/AngeloUNIMI/PalmSeg.git
cd PalmSeg
```

### 2. Prepare the dataset

Place your palmprint images inside the `images/` directory, for example:

```text
images/Tongji_Contactless_Palmprint_Dataset/
```

The default script expects bitmap images:

```matlab
ext = 'bmp';
dirWorkspace = './images/';
```

You can modify these values in `launch_PalmSeg.m` if your images use another extension or folder layout.

### 3. Select the dataset configuration

PalmSeg uses dataset-specific parameter files stored in `params/`.

Examples include:

```text
params/params_CASIA_PalmprintV1.m
params/params_IITD_Palmprint_V1.m
params/params_REST_hand_database.m
params/params_Tongji_Contactless_Palmprint_Dataset.m
```

The main script loads parameters according to the selected dataset name:

```matlab
run(['./params/params_' dbname '.m']);
```

### 4. Run PalmSeg

Open MATLAB in the repository folder and run:

```matlab
launch_PalmSeg
```

---

## 📤 Output

For each processed dataset, PalmSeg can generate:

| Output | Description |
|---|---|
| `SegInfos/` | Text files containing segmentation and ROI information |
| `ROIs_possible/` | Extracted candidate palmprint ROI images |
| `Results/` | Graphic outputs and logs |
| `*_results_graphic.pdf` | Visual summary of segmentation and ROI extraction results |
| Log files | Per-run processing information |

Typical output folders are created under:

```text
images/<dataset_name>/SegInfos/
images/<dataset_name>/ROIs_possible/
Results/<dataset_name>/
```

---

## 🖼️ Visual Output

When graphic output is enabled, PalmSeg produces visual summaries combining segmentation and ROI extraction results.

```text
Original image  →  Segmented hand shape  →  Detected ROI  →  Saved ROI image
```

These outputs are useful for quickly verifying whether the segmentation and alignment parameters are appropriate for a specific dataset.

---

## 🧪 Supported Datasets

PalmSeg includes parameter files for multiple palmprint datasets used in the related research works.

| Dataset | Notes |
|---|---|
| CASIA Palmprint Database | Contactless palmprint dataset |
| IITD Palmprint Database | Touchless palmprint images |
| REST Hand Database | Hand images for biometric analysis |
| Tongji Contactless Palmprint Dataset | Contactless palmprint images |

Dataset download pages:

- CASIA: http://www.cbsr.ia.ac.cn/english/Palmprint%20Databases.asp
- IITD: http://www4.comp.polyu.edu.hk/~csajaykr/IITD/Database_Palm.htm
- REST: http://www.regim.org/publications/databases/regim-sfax-tunisian-hand-database2016-rest2016/
- Tongji: http://sse.tongji.edu.cn/linzhang/cr3dpalm/cr3dpalm.htm

---

## 🔗 Related Repository

PalmSeg can be used as a pre-processing and ROI extraction stage for:

```text
PalmNet: Gabor-PCA Convolutional Networks for Touchless Palmprint Recognition
```

Repository:

```text
https://github.com/AngeloUNIMI/PalmNet
```

---

## 📚 Scientific References

If you use this software, please cite the related works.

```bibtex
@article{genovese2019palmnet,
  author  = {A. Genovese and V. Piuri and K. N. Plataniotis and F. Scotti},
  title   = {PalmNet: Gabor-PCA Convolutional Networks for Touchless Palmprint Recognition},
  journal = {IEEE Transactions on Information Forensics and Security},
  year    = {2019}
}
```

```bibtex
@inproceedings{genovese2019civemsa,
  author    = {A. Genovese and V. Piuri and K. N. Plataniotis and F. Scotti},
  title     = {Touchless Palmprint Recognition},
  booktitle = {IEEE International Conference on Computational Intelligence and Virtual Environments for Measurement Systems and Applications},
  year      = {2019}
}
```

---

## 👥 Authors

**Angelo Genovese**, **Vincenzo Piuri**, and **Fabio Scotti**  
Department of Computer Science  
Università degli Studi di Milano, Italy

**Konstantinos N. Plataniotis**  
Department of Electrical Engineering  
University of Toronto, Canada

---

## 📄 License

This project is released under the **GNU General Public License v3.0**.

See the [LICENSE](LICENSE) file for details.

---

<div align="center">

### ✋ PalmSeg

**Palmprint segmentation and ROI extraction for touchless biometric recognition**

</div>
