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

    return words
