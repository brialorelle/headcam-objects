# HeadCam Objects
## Repository for the development of methods for extracting object category information from infant egocentric videos

Folder Structure:
<ul>
  <li><b>analysis</b>: contains scripts for various analysis pipelines</li>
  <li><b>data</b>: contains various data files from points in the processing pipeline(annotated image information, segmented images in COCO-JSON format, .manifest files with annotations)
    <ul>
      <li>annotations: various annotated images from SAYCam set
        <ul>
          <li>basic_level_manual_labels: BL, GK, and NB went through and labeled the prominent object in each image using <a href="https://colab.research.google.com/drive/1xnI6jvErTYNaMabjuHsuq1HzfbVWNw_w"> this Colab Notebook</a> </li>
          <li>broad_category_segmentations: Used 10 category dictionary and had people go through and label each image with the categories that were present</li>
          <li>mturk_detections: pilot bounding box detections with intermediate and final dataframes created using <a href="https://colab.research.google.com/drive/11kWilpGUWw8Ds3lo60hj8whZJcqELEez"> this Colab Notebook</a>
          <li>faces_hands: annotation dataset from previous project; bounding boxes around faces and hands in dataset</li>
          <li>panoptic_segmentations_for_training: panoptic segmentations, jsons created using <a href="https://colab.research.google.com/drive/1a0g9QEnDoq7K4Hii5Jf73s2iFVBqLXUj"> this Colab Notebook</a>
            <ul>
              <li>pilot_segmentation.json: first pilot, 9 images with segmentations</li>
              <li>pilot_b_segmentations.json: second pilot, 90 images with segmentations</li>
              <li>pilot_b_good_segmentations.json: subset of second pilot with confidence thresholded, 60 images with segmentations</li>
              <li>pilot_big_segmentations.json: final pilot, 801 image subset of 984 images with segmentations</li>
              <li>combined_segmentations.json: final image set (combines final pilot with another set of final images), 3365 images with segmentations</li>
              <li>combined_good_segmentations.json: subset of final image set with confidence thresholded, 2215 images with segmentations</li>
              <li>rest of folders store the above data, but split into 80/20 training and testing sets
                <ul>
                  <li>training and testing data is split using <a href="https://colab.research.google.com/drive/1D0P9Zka_bMwsZQsvupot7JyGHfFHnlQa"> this Colab Notebook</a> and analysis using <a href="https://colab.research.google.com/drive/1TxJzjCNijwTJzMLsaKdOkfQ9VUou91kT"> this Colab Notebook</a></li>
                </ul> 
              </li>
            </ul>
          </li>
        </ul>
      </li>
      <li>category_lists: lists of categories we used to label images
        <ul>
          <li>categories.txt: initial full category list used as dictionary in MTurk pilot</li>
          <li>object_list.txt: basic level category list used for basic level manual annotations</li>
        </ul> 
      </li>
      <li>image_lists: various lists of image urls
      </li>
      <li>preprocessed_data: output from processing data using R</li>
      <li>saycam_images: includes a zip file of interesting images from SAYCam</li>
      <li>vedi_pilot: TODO</li>
    </ul>
  </li>
  <li> <b>writing</b>: workspace for papers associated with this project </li>

</ul>
