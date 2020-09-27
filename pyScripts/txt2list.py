# define an empty list
words = []

# open file and read the content in a list
with open('wordbank_object_list.txt', 'r') as filehandle:
    for line in filehandle:
        # remove linebreak which is the last character of the string
        currentWord = line[:-1]

        # add item to the list
        words.append(currentWord)

words = list(set(words)) #remove duplicates
words.sort() #alphabetize

print(words)
