import detectron2
from detectron2.utils.logger import setup_logger
setup_logger()

# import some common libraries
import numpy as np
import os, json, cv2, random
from google.colab.patches import cv2_imshow
import urllib


# import some common detectron2 utilities
from detectron2 import model_zoo
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2.utils.visualizer import Visualizer
from detectron2.data import MetadataCatalog, DatasetCatalog


from detectron2.data.datasets import register_coco_instances

from detectron2.engine import DefaultTrainer, SimpleTrainer

from detectron2.modeling import build_model

"""In order to use OpenCV to visualize our iamges, we use the below function 
(from https://www.pyimagesearch.com/2015/03/02/convert-url-to-image-with-python-and-opencv/) 
to convert our image urls to OpenCV format."""
def url_to_image(url):
	# download the image, convert it to a NumPy array, and then read
	# it into OpenCV format
	resp = urllib.request.urlopen(url)
	image = np.asarray(bytearray(resp.read()), dtype="uint8")
	image = cv2.imdecode(image, cv2.IMREAD_COLOR)
	# return the image
	return image


"""To verify the data loading is correct, let's visualize the annotations of one of the images in the set. 
Note that all annotations are displayed for the given image, meaning that the image has multiple annotations for the same thing. 
This is a product of COCO JSON format storing annotations by image."""
def visualizeData(datasetToSee):
    d_dict = DatasetCatalog.get(datasetToSee)
    for d in d_dict:
        im = url_to_image(d['file_name'])
        visualizer = Visualizer(im[:, :, ::-1], metadata=MetadataCatalog.get(datasetToSee))
        visualizer._default_font_size = 25
        out = visualizer.draw_dataset_dict(d)
        cv2_imshow(out.get_image()[:, :, ::-1]) # need to replace this for something else, only compatible with google colab


""" Train!
Now, let's fine-tune a COCO-pretrained R101-C4 Faster R-CNN model on the toy dataset. 
There are a lot of training parameters here that need to be considered and adjusted; putting this on my TODO to look into the docs and note what each parameter is.
"COCO-Detection/faster_rcnn_R_101_FPN_3x.yaml"
"""


from detectron2.engine import DefaultTrainer, SimpleTrainer
def trainModel(modelConfigFile, trainDataset, numCats=354):
    CUDA_LAUNCH_BLOCKING=1  # avoid getting a runtime error
    
    cfg = get_cfg()
    cfg.merge_from_file(model_zoo.get_config_file(modelConfigFile))
    cfg.DATASETS.TRAIN = (trainDataset,)
    cfg.DATASETS.TEST = ()
    cfg.DATALOADER.NUM_WORKERS = 2
    cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url(modelConfigFile)  # Let training initialize from model zoo
    cfg.SOLVER.IMS_PER_BATCH = 2
    cfg.SOLVER.BASE_LR = 0.0025  # pick a good LR
    cfg.SOLVER.MAX_ITER = 300    # 300 iterations seems good enough for this toy dataset; you may need to train longer for a practical dataset
    cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset (default: 512)
    cfg.MODEL.ROI_HEADS.NUM_CLASSES = numCats  # number of categories

    os.makedirs(cfg.OUTPUT_DIR, exist_ok=True)
    trainer = DefaultTrainer(cfg) 
    trainer.resume_or_load(resume=True)
    trainer.train()

    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")

    return cfg, trainer

"""Function using COCO Evaluator and evaluation metrics to get inferences on dataset"""
from detectron2.evaluation import COCOEvaluator, inference_on_dataset
from detectron2.data import build_detection_test_loader
def evaluateModel(cfg, trainer, validationDataset, testingThreshold):
    
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = testingThreshold  # set the testing threshold for this model
    cfg.DATASETS.TEST = (validationDataset, )
    predictor = DefaultPredictor(cfg)
    evaluator = COCOEvaluator(validationDataset, cfg, True, output_dir=cfg.OUTPUT_DIR)
    val_loader = build_detection_test_loader(cfg, validationDataset)
    return inference_on_dataset(trainer.model, val_loader, evaluator)

"""" Main function that takes cocojson files and trains a detectron2 model based 
    on the config file and outputs evaluation metrics
"""""
    def loadModel(trainingDataFile, validationDataFile, modelConfigFile="COCO-Detection/faster_rcnn_R_101_FPN_3x.yaml"):
    
    # register datasets
    register_coco_instances("dataset_train", {}, trainingDataFile, "")
    register_coco_instances("dataset_val", {},  validationDataFile, "")

    cfg, trainer = trainModel("dataset_train", modelConfigFile)

    return evaluateModel(cfg, trainer, "dataset_val", 0.7)
