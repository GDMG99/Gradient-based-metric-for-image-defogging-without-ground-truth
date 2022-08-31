# Contour-based metric for image defogging without ground truth

## Gerard deMas-Giménez, Pablo García-Gómez, Josep R. Casas and Santiago Royo

### Abstract
Fog, haze, or smoke are usual atmospheric phenomena that dramatically compromise the overall visibility of any scene, critically affecting features such as illumination, contrast, and contour detection of objects. The decrease in visibility compromises the performance of computer vision algorithms such as pattern recognition and segmentation, some of them very relevant for decision-making in the fields of security and autonomous vehicles. Several dehazing methods have been proposed. However, to the best of our knowledge, all proposed metrics in the literature compare the defogged image to its ground truth for evaluation of the defogging algorithms,  or need to estimate parameters through physical models. This fact hinders progress in the field as obtaining proper ground truth images is costly and time-consuming, and physical parameters greatly depend on the scene conditions. This paper aims to tackle this issue by proposing a contour-based metric for image defogging evaluation that does not need a ground truth image or a physical model. The proposed metric only requires the original hazy RGB image and the RGB image obtained after the defogging procedure. A comparison of the proposed metric with metrics already used in the NTIRE 2018 defogging challenge is performed to prove its effectiveness in a general situation, showing comparable results to conventional metrics.

In this repository you will find the MATLAB implementation of the Contour-based metric for image defogging without ground truth algorithm found in the paper.

![Comparison](/Images/contour_comparison.png)
*Edge comparison between a fogged image (left) and its fog-free ground truth (right). Both colour images are presented on top with their associated edge images below. Both images are part of the [O-Haze](https://data.vision.ee.ethz.ch/cvl/ntire18//o-haze/) dataset.*

## Usage
The algorithm is implemented in the `Contour_based_metric_woGT.m` on the `Demo_dataset`. The functions used in the file can be found at the `Functions_metric` folder. Please, if our metric is useful for your work, consider citing our paper.

>`Paper citation`

## Demo dataset
Apart from the implemented algorithm, the user may find a demo dataset as well. This dataset is part of the [O-Haze](https://data.vision.ee.ethz.ch/cvl/ntire18//o-haze/) dataset used in the [NTIRE 2018 defogging challenge](https://people.ee.ethz.ch/~timofter/publications/NTIRE2018_Dehazing_report_CVPRW-2018.pdf). If you use the images for academic porpuses make sure to cite the authors properly.
>`@inproceedings{O-HAZE_2018,
author = { Codruta O. Ancuti and Cosmin Ancuti and Radu Timofte and Christophe De Vleeschouwer},
title = {O-HAZE: a dehazing benchmark with real hazy and haze-free outdoor images},
booktitle =  {IEEE Conference on Computer Vision and Pattern Recognition, NTIRE Workshop },
series = {NTIRE CVPR'18},
year = {2018},
location = {Salt Lake City, Utah, USA},
}