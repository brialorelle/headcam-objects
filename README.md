# HeadCam Objects
## Repository for the development of methods for extracting object category information from infant egocentric videos.

Folder Structure:
<ul>
  <li><b>analysis</b>: contains scripts for various analysis pipelines.
    <ul>
      <li>basic_level_manual_labels</li>
      <li>full_goldset</li>
      <li>general_helper_scripts</li>
      <li>goldset_annotations</li>
      <li>mturk_pilot</li>
      <li>panoptic_segmentation_training</li>
      <li>vedi_pilot</li>
    </ul>
  </li>
  <li><b>data</b>: contains various data files from points in the processing pipeline(annotated image information, segmented images in COCO-JSON format, .manifest files with annotations).
    <ul>
      <li>annotations: various annotated images from SAYCam set.
        <ul>
          <li>basic_level_manual_labels: BL, GK, and NB went through and labeled the prominent object in each image using <a href="https://colab.research.google.com/drive/1xnI6jvErTYNaMabjuHsuq1HzfbVWNw_w"> this Colab Notebook</a>.</li>
          <li>broad_category_segmentations: Used 10 category dictionary and had people go through and label each image with the categories that were present.</li>
          <li>mturk_detections: pilot bounding box detections with intermediate and final dataframes created using <a href="https://colab.research.google.com/drive/11kWilpGUWw8Ds3lo60hj8whZJcqELEez"> this Colab Notebook</a>
          <li>faces_hands: annotation dataset from previous project; bounding boxes around faces and hands in dataset.</li>
          <li>panoptic_segmentations: panoptic segmentations, jsons created using <a href="https://colab.research.google.com/drive/1a0g9QEnDoq7K4Hii5Jf73s2iFVBqLXUj"> this Colab Notebook</a>.
            <ul>
              <li> coco_json_format_files: output from reformatting raw segmentations into COCO JSON format.
              <ul>
                <li>pilot_segmentation.json: first pilot, 9 images with segmentations.</li>
                <li>pilot_b_segmentations.json: second pilot, 90 images with segmentations.</li>
                <li>pilot_b_good_segmentations.json: subset of second pilot with confidence thresholded, 60 images with segmentations.</li>
                <li>pilot_big_segmentations.json: final pilot, 801 image subset of 984 images with segmentations.</li>
                <li>combined_segmentations.json: final image set (combines final pilot with another set of final images), 3365 images with segmentations.</li>
                <li>combined_good_segmentations.json: subset of final image set with confidence thresholded, 2215 images with segmentations.</li>
                <li>rest of folders store the above data, but split into 80/20 training and testing sets.
                    <ul>
                      <li>training and testing data is split using <a href="https://colab.research.google.com/drive/1D0P9Zka_bMwsZQsvupot7JyGHfFHnlQa"> this Colab Notebook</a> and analysis using <a href="https://colab.research.google.com/drive/1TxJzjCNijwTJzMLsaKdOkfQ9VUou91kT"> this Colab Notebook</a>.</li>
                    </ul> 
                  </li>
                </ul>
              </li>
              <li>raw_manifest_files: raw Sagemaker output.</li>
            </ul>
          </li>
        </ul>
      </li>
      <li>category_lists: lists of categories we used to label images.
        <ul>
          <li>categories.txt: basic level category list used as dictionary in annotation tasks.</li>
          <li>object_list.txt: initial full category list used for basic level pilot MTurk and manual annotations.</li>
        </ul> 
      </li>
      <li>image_lists: various lists of video/image filenames and urls.
        <ul>
          <li>SAYCAM_allocentric_videos.csv: 1631 video filenames and whether or not they are allocentric. for filtering out associated images.</li>
          <li>child_hands.csv: list of 3050 public urls to images with child hands from dataset.</li>
          <li>goldset_to_annotate.csv: list of 16996 public urls to images, BL made this.</li>
          <li>hands_sample_annotate.csv: random sample list of 500 public urls to images with hands, subset from hands_to_annotate.csv.</li>
          <li>hands_to_annotate.csv: list of 11828 public urls to images with hands, subset from goldset_to_annotate.csv.</li>
          <li>interesting_image_list.txt: list of 1542 image filenames that NB made by sifting through random subset from goldset_to_annotate.csv. FMI, <a href="https://github.com/brialorelle/headcam-objects/blob/master/data/image_lists/Notes%20on%20Interesting%20Images.pdf">see notes on choosing interesting images</a>.</li>
          <li>interesting_ims.csv: list of 1000 public urls to images subset from interesting_image_list.txt.</li>
          <li>people_goldset.csv: list of 9616 public urls to images with people in frame, subset from goldset_to_annotate.csv.</li>
          <li>person_sample_annotate.csv: random sample list of 500 public urls to images with people in frame, subset from people_goldset.csv.</li>
          <li>pilotImageURLs.csv: list of 150 public urls to images chosen randomly from interesting_image_list.txt using <a href="https://github.com/brialorelle/headcam-objects/blob/master/analysis/general_helper_scripts/chooseRandomIms.py">this helper script</a>.
          </li>
          <li>top_category_frames.csv: list of 984 public urls to images.</li>
          <li>top_frames.csv: list of 953 public urls to images.</li>
        </ul>
      </li>
      <li>preprocessed_data: output from processing data using R.</li>
      <li>saycam_images: includes a zip file of "interesting images" from image_lists/interesting_image_list.txt.</li>
      <li>vedi_pilot: TODO</li>
    </ul>
  </li>
  <li> <b>experiments</b>: task paradigms.
    <ul>
      <li>mturk_pilot: contains html code for MTurk pilot task collecting bounding box annotations.</li>
    </ul> 
  </li>
  <li> <b>writing</b>: workspace for papers associated with this project.
    <ul>
      <li>cogsci-paper: contains preparations for our <a href="https://escholarship.org/uc/item/5t30m4qz">2021 paper in the Proceedings of the Annual Meeting of the Cognitive Science Society</a> and <a href="https://youtu.be/3y_haHVq1-c">corresponding oral presentation</a>.
      </li>
    </ul> 
  </li>

</ul>
