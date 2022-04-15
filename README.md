# HeadCam Objects
## Repository for the development of methods for extracting object category information from infant egocentric videos

Folder Structure:
<ul>
  <li><b>analysis</b>: contains scripts for various analysis pipelines</li>
  <li><b>data</b>: contains various data files from points in the processing pipeline(annotated image information, segmented images in COCO-JSON format, .manifest files with annotations)
    <ul>
      <li>pilot_segmentation.json: first pilot, 9 images with segmentations</li>
      <li>pilot_b_segmentations.json: second pilot, 90 images with segmentations</li>
      <li>pilot_b_good_segmentations.json: subset of second pilot with confidence thresholded, 60 images with segmentations</li>
      <li>pilot_big_segmentations.json: final pilot, 801 image subset of 984 images with segmentations</li>
      <li>combined_segmentations.json: final image set (combines final pilot with another set of final images), 3365 images with segmentations</li>
      <li>combined_good_segmentations.json: subset of final image set with confidence thresholded, 2215 images with segmentations</li>
    </ul>
  </li>
  <li> <b>writing</b>: workspace for papers associated with this project </li>

</ul>
