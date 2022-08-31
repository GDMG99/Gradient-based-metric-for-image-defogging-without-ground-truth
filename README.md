# Contour-based metric for image defogging without ground truth

## Gerard deMas-Giménez, Pablo García-Gómez, Josep R. Casas and Santiago Royo

### Abstract
Fog, haze, or smoke are usual atmospheric phenomena that dramatically compromise the overall visibility of any scene, critically affecting features such as illumination, contrast, and contour detection of objects. The decrease in visibility compromises the performance of computer vision algorithms such as pattern recognition and segmentation, some of them very relevant for decision-making in the fields of security and autonomous vehicles. Several dehazing methods have been proposed. However, to the best of our knowledge, all proposed metrics in the literature compare the defogged image to its ground truth for evaluation of the defogging algorithms,  or need to estimate parameters through physical models. This fact hinders progress in the field as obtaining proper ground truth images is costly and time-consuming, and physical parameters greatly depend on the scene conditions. This paper aims to tackle this issue by proposing a contour-based metric for image defogging evaluation that does not need a ground truth image or a physical model. The proposed metric only requires the original hazy RGB image and the RGB image obtained after the defogging procedure. A comparison of the proposed metric with metrics already used in the NTIRE 2018 defogging challenge is performed to prove its effectiveness in a general situation, showing comparable results to conventional metrics.

In this repository you will find the MATLAB implementation of the Contour-based metric for image defogging without ground truth algorithm found in the paper.

## Algorithm
In this section we introduce our proposed contour-based metric for image defogging without the need of a ground truth step by step. If you want a more detailed explanation, please read the original paper.

The main effect that hazy weather has on a scene are decreased luminance and contrast, that dramatically reduce the contours of the scene. Maintaining defined contours in adverse weather conditions is key to proper object recognition and segmentation, which are the basis of several applications such as autonomous driving or survelliance. The visibility metric we present is based on contour detection for image defogging evaluation. Our approach compares the edges of the foggy image to the edges of its defogged counterpart, i. e. after the defogging procedure is done. Hence, there is no need for a ground truth. Besides that, our method does not need to estimate any atmospheric parameter, which is difficult from a single RGB image and, in general, requires the sky to be present in the image. 

Thus, as a first step, we need to obtain the edges of both images (original and defogged). There are several well-known image processing operators to perform such procedure. For our method, we used the well-known Sobel edge detector due to its simplicity. The horizontal and vertical derivatives are obtained by  respectively applying the horizontal and vertical kernels on the image, as it is shown in the following equation,

$$
    F_x=\begin{bmatrix}-1 & 0 & 1\\ -2 & 0 & 2\\ -1 & 0 & 1\end{bmatrix}\circledast I\quad ; \quad F_y=\begin{bmatrix}-1 & -2 & -1\\ 0 & 0 & 0 \\ 1 & 2 & 1\end{bmatrix}\circledast I,
$$

where $F_x$ and $F_y$ are the corresponding horizontal and vertical derivatives of the image $I$. The image integrating all contours is retrieved as follows,

$$
    F = \sqrt{F_x^2+F_y^2}.
$$

Note that in any image, most of the pixels do not represent an edge, yielding small values in the processed edge image. Hence, we define a threshold value for the edge values in order to differentiate the edges of interest from the background. 

Edge images are normalized to one, so our proposed threshold value is to use 5\% of the maximum edge value present in the image to still keep all the relevant information related to edges while disregarding the background data. This threshold will be further discussed after presenting the relative difference matrix. Such 5\% value could be optimized for a different dataset if needed. After obtaining the edges of each image, we perform the relative difference between the edge images of the fogged and its defogged counterpart pixel by pixel, as stated in the next equation,

$$
    RD(x,y) = \begin{cases}\dfrac{d_{e}(x,y)-f_e(x,y)}{f_e(x,y)}\quad d_e(x,y),f_e(x,y)>\text{threshold}\\0\quad \text{otherwise}\end{cases},
$$

where $RD(x,y)$ is the relative difference computed at pixel (x,y), $d_e(x,y)$ is the  defogged edge image and $f_e(x,y)$ is the fogged edge image. Let us take a moment to analyze the "*relative difference image*" so obtained. This image has the same dimensions as both input images. Each pixel stores the relative difference between the corresponding pixel of both input edge images. If the value of a pixel in the relative difference image is positive, the strength of the contours in the defogged image has improved, i. e. the edge value in the defogged image is larger than the edge value in the original image. Otherwise, if the value of a pixel in the relative difference image is negative, the strength of the contours has decreased after the defogging algorithm. Therefore, the value of the difference quantifies the improvement in edge strength obtained after the defogging process.

Once we compute the relative difference image, we perform the histogram of said image excluding the background pixels of the image, that is, the null values corresponding to those pixels below the threshold value. The vast majority of edges in this image are better defined when fog is not present on the scene because of the defogging algorithm, as we would expect. Negative values close to 0 in the histogram correspond to some regions that have not been really affected by fog, or that in such areas the defogging process has introduced small variations in the contour strength for these regions. These pixels, however, are quite residual compared to the rest.

At this point, the strategy of the edge-based metric becomes clear. However, we still need a scalar value to quantify the enhancement of the defogging procedure consistent with the information that can be graphically observed in the histogram. There are several options to obtain this numerical value. Our proposal consists on calculating the weighted ratio between the positive part of the histogram and the whole one. Mathematically,

$$
    R = \dfrac{\sum_{i=0}^\infty r_i^+\cdot h(r_i^+)-\sum_{i=0}^{\infty}|r_i^-|\cdot h(r_i^-)}{\sum_{i=0}^\infty r_i^+\cdot h(r_i^+)+\sum_{i=0}^{\infty}|r_i^-|\cdot h(r_i^-)}
$$

where $r_i^\pm$ is the value of the relative difference, either positive or negative, and $h(r_i^\pm)$ corresponds to the histogram value of $r_i^\pm$, so the total counts on the edge image of such a value. $R$ can take values from -1 to 1, being 1 when all the edges have been enhanced and -1 when the defogging procedure have worsened every edge of the image. The weighted character of the metric is used to strengthen the edges that have been greatly improved or worsened. If we compute the proposed metric value for the example images shown in Fig.~\ref{fig:comparison} we get $R=0.9732$. This is a reasonable result since we are comparing a fogged image directly with its fog-free ground truth, mimicking an ideal defogging algorithm.

 As we previously mentioned, the threshold value in the relative difference equation has been empirically fixed. We noted that setting a threshold above 8\% disregards low intensity edges, and decreases the value of the metric. On the other side, a threshold smaller than 5\% considers an edge almost any variation due to noise. We shall recall the reader that this threshold was introduced to separate the background pixels, where there are no contours, from the low intensity edges.

An additional remark must be made. As previously discussed, DNNs and especially GANs, are nowadays used to tackle defogging. GANs are very useful when it comes to generating new data that resembles the data distribution it has learned from. This means that these networks tend to generate new features in the images, which leads to new contours producing better results in our metric even if the defogging is poor. We believe that generating these "*ghost*" features in the image should directly discard the defogging method. Defogging is especially useful to increase the performance of object detection and image segmentation, which will ultimately execute an action in an autonomous vehicle. Executing an action due to a "*ghost*" feature could be extremely dangerous. So our metric works under the premise that no new features are added to the defogged image during the defogging procedure, and only already existing features are highlighted.


## Demo dataset
Apart from the implemented algorithm, the user may find a demo dataset as well. This dataset is part of the [O-Haze](https://data.vision.ee.ethz.ch/cvl/ntire18//o-haze/) dataset used in the [NTIRE 2018 defogging challenge](https://people.ee.ethz.ch/~timofter/publications/NTIRE2018_Dehazing_report_CVPRW-2018.pdf). If you use the images for academic porpuses make sure to cite the authors properly.
>`@inproceedings{O-HAZE_2018,
author = { Codruta O. Ancuti and Cosmin Ancuti and Radu Timofte and Christophe De Vleeschouwer},
title = {O-HAZE: a dehazing benchmark with real hazy and haze-free outdoor images},
booktitle =  {IEEE Conference on Computer Vision and Pattern Recognition, NTIRE Workshop },
series = {NTIRE CVPR'18},
year = {2018},
location = {Salt Lake City, Utah, USA},
}`