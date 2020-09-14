import xmltodict
import boto3
import json
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import requests
from io import BytesIO
from PIL import Image
import pandas as pd
import os


""" Load Object Label List

Use the function from the txt2list.py file (copying it for ease of use)
"""

def loadObjList(txtFile):
    # define an empty list
    words = []

    # open file and read the content into a list
    with open(txtFile, 'r') as filehandle:
        for line in filehandle:
            # remove linebreak which is the last character of the string
            currentWord = line[:-1]

            # add item to the list
            words.append(currentWord)

    words = list(set(words))
    words.sort() #alphabetize
    words.insert(0, 'other / label not found')
    return words

"""Create a dictionary mapping categories to ids""""
def categoryMapping(txtFile):
    categories = {}       # dictionary mapping labels to ids
    catId = 1
    labels = loadObjList(txtFile)
    for cat in labels:
        categories[cat] = catId
        catId+=1
    return categories

""" Load batch results from MTurk CSV
""""
def loadResults(csvDataFilename):
    results = pd.read_csv(csvFilename)

    # only use approved HITs; could filter before downloading but including if not
    #approvedResults = batchResults[batchResults['AssignmentStatus'] == 'Approved']

    # make a smaller dataframe with the values of interest (the assignment id is a good unique id)
    #results = approvedResults[['HITId', 'WorkerId', 'AssignmentId', 'Input.image_url','Answer.taskAnswers']]

    # give some of the columns more intuitive names
    results = results.rename(columns={'Input.image_url':'image_url', 'Answer.taskAnswers':'taskAnswers'})
    return results

"""Create a boundingBox object with height, width, xmin, and ymin attributes 
and an image object with filename, HITId, height, and width attributes;
We'll store our annotations in these objects for easy access during analyses"""

class boundingBox(object):
  def __init__(self, height, width, left, top, label, HITId):
    self.height = height
    self.width = width
    self.xmin = left
    self.ymin = top
    self.label = label
class image(object):
  def __init__(self, height, width, url):
    self.height = height
    self.width = width
    self.url = url


"""We organize the annotated results using a nested dictionary with workerIds and HITIds and first and second keys. 
    To have a unique ID for each annotation, we map assignment Ids to workerId and HITId pairs.
"""
def resultsToDicts(csvDataFilename):
    results = loadResults(csvDataFilename)  
    idMapper = {}                   # initialize an empty dictionary where we'll map assignmentIds to worker and HIT ids
    answers = {}                    # initialize an empty dictionary where we'll put the annotations as values
    images = {}
    for row in results.itertuples():
        url = row.image_url
        HITId = row.HITId
        answer = json.loads(row.taskAnswers)[0]
        bbox = answer['annotatedResult']['boundingBoxes']
        if HITId not in images.keys():
            imProp = answer['annotatedResult']['inputImageProperties']
            im = image(imProp['height'],imProp['width'], url)
            images[HITId] = image(imProp['height'],imProp['width'], url)
        idMapper[row.AssignmentId] = {'HITId': HITId, 'WorkerId': row.WorkerId}
        answers[row.AssignmentId] = answer['annotatedResult']['boundingBoxes']
    return idMapper, answers, images


"""Modified https://github.com/Tony607/voc2coco/blob/master/voc2coco.py code to create a coco json file from our dictionaries!"""

def get_filename_as_int(filename):
    try:
        filename = os.path.basename(filename)
        filename = filename.split('-')[2]
        return int(filename)
    except:
        raise ValueError("Filename %s is supposed to be an integer." % (filename))


def convert(categories, images, answers, json_file):
    json_dict = {"images": [], "type": "instances", "annotations": [], "categories": []}
    bnd_id = 1      # bounding box id
    IDsSeen=[]
    for AssignmentId in answers.keys():
        ## Currently we do not support segmentation.
        #  segmented = get_and_check(root, 'segmented', 1).text
        #  assert segmented == '0'
        HITId = idMapper[AssignmentId]['HITId']
        im = images[HITId]
        filename = im.url
        image_id = get_filename_as_int(filename)
        if image_id not in IDsSeen:
        width = im.width
        height = im.height
        image = {
            "file_name": filename,
            "height": height,
            "width": width,
            "id": image_id}
        json_dict["images"].append(image)
        IDsSeen.append(image_id)
        for answer in answers[AssignmentId]:
        category = answer['label']
        if category not in categories.keys():
            new_id = len(categories)+1
            categories[category] = new_id
        category_id = categories[category]
        xmin = answer['left']
        ymin = answer['top']
        width = answer['width']
        height = answer['height']
        image_id = get_filename_as_int(filename)
        ann = {
            "area": width * height,
            "iscrowd": 0,
            "image_id": image_id,
            "bbox": [xmin, ymin, width, height],
            "category_id": category_id,
            "id": bnd_id,
            "ignore": 0,
            "segmentation": [],
        }
        json_dict["annotations"].append(ann)
        bnd_id = bnd_id + 1
    for cate, cid in categories.items():
        cat = {"supercategory": "none", "id": cid, "name": cate}
        json_dict["categories"].append(cat)

    os.makedirs(os.path.dirname(json_file), exist_ok=True)
    json_fp = open(json_file, "w")
    json_str = json.dumps(json_dict)
    json_fp.write(json_str)
    json_fp.close()


""" Main function to run: takes MTurk CSV and exports data as COCO JSON file
""""
def mTurkCSVtoCOCOJSON(csvDataFilename, objectListFilename, exportJSONFilename):
    # load list from object list txt file and create category-id dictionary
    categories = categoryMapping(objectListFilename)

    # load results from csv and organize into dictionaries
    idMapper, answers, images = resultsToDicts(csvDataFilename)

    # convert and export dictionaries to COCO JSON file format
    convert(categories, images, answers, exportJSONFilename)







