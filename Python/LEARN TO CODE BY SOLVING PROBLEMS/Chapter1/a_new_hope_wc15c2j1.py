user_input = int(input()) 
word1 = 'A long time ago in a galaxy' 
word2 = ' far' 
word3 = ' far,' 
word4 = ' away...' 
if user_input == 1:
	word5 = word1 + word2 + word4 
else:
	word5 = word1 + (word3*(user_input-1)) + word2 + word4 

print(word5)