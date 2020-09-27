
"""Choose 150 random images from the list of interesting images."""

import random
import csv
import pandas as pd
import numpy as np
import math

""""Helper functions for one image per HIT"""

def loadTxtListRandom(interestingImageListTxtFile, numberOfIms):
    with open(interestingImageListTxtFile,'r') as f:
        lines = f.read().split('\n') 
        imList = random.sample(lines, numberOfIms)
    return imList

def exportImListToCSV(imURLs, exportCSVFilename):
    with open(exportCSVFilename, 'w', newline='') as write_file:
        write=csv.writer(write_file)
        write.writerow(['image_url'])
        write.writerows([url] for url in imURLs)


""""Helper functions for generating multiple images per HIT (10 images per HIT, so 15 unique HITs)"""

def loadTxtListRandomLoL(interestingImageListTxtFile, root, imsPerHIT, numberOfIms):
    imList = []
    numUniqueHITs = numberOfIms//imsPerHIT
    with open(interestingImageListTxtFile,'r') as f:
        lines = f.read().split('\n')
        for i in range(0,numUniqueHITs):
            ims = [root + im for im in random.sample(lines, imsPerHIT)]
            imList.append(ims)
    return imList

# make list of titles for columns based on number of columns in imList
def genTitleList(imList):
    titles = []
    for col in range(0, len(imList[0])):
        titles.append('image_url' + str(col+1))
    return titles

def exportImListToCSVLoL(imList, exportCSVFilename):
    titles = genTitleList(imList)
    with open(exportCSVFilename, 'w', newline='') as write_file:
        write=csv.writer(write_file)
        write.writerow(titles)
        write.writerows(imList)


""" Main function, takes interesting image list file and exports list of 150 (default) images in CSV file
"""
def chooseRandomIms(interestingImageListTxtFile, numberOfIms = 150, imsPerHIT = 1, root = 'http://langcog.stanford.edu/expts/saycam/frames/', exportCSVFilename):
    # multiple images per HIT!
    if imsPerHIT>1:
        # make 10 lists of 15 random images from interesting image list
        imList = loadTxtListRandomLoL(interestingImageListTxtFile, root, imsPerHIT, numberOfIms)
        #if you want to use this to also generate list of imURLs = [root + im for ims in imList for im in ims]
        # export imList as CSV for upload to MTurk Batch with multiple images for each HIT
        exportImListToCSVLoL(imList, exportCSVFilename)

    # default 1 image per HIT
    else:
        # make list of 150 random images from interesting image list
        imList = loadTxtListRandom(interestingImageListTxtFile, numberOfIms)
        # generate image url list
        imURLs = [root + im for im in imList] 
        # export imURLs as CSV for upload to MTurk Batch
        exportImListToCSV(imURLs, exportCSVFilename)


   
