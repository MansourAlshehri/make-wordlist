# make-wordlist
Tool to help the users the control and organize the wordlist content. 
 
----------------------------------------------------------------------
      ---Author => < Mansour Abdullah
      ---Review => < Muhammed Mujeeb
      ---Version 1
      
      The main syntax : ./mwl.sh -f 'input file name' -o 'output file name' -m 'mode string' -p 'pattern string'
      
      
Usage instructions:
        -f the file name that you wish to filter its content, use the file path if the file does not exist in current directory
        -p the pattern to remove from the word, input a list of non-accepted letters that should be removed from the word
        -o the output file to write new wordlist in!
        -m the mode type; it could be (letter level processing):
                                            remove_all          remove  the string that contains any pattern char(s) from the list
                                            remove_part         remove  the pattern letter then concatinate other letters
                                            remove_bysize       remove the word if match the pattern size
                                            remove_byindex      remove the letter by given index and concatinate ramainder letters
                                            postfix             append pattern letter to the end of the word
                                            prefix              append pattern letter to the begining of the word
                                            replace_by          replace the original letter(s) set by the given letter(s) set
                                            replace_byindex     replace the letter by given index(overwrite existent letters)
                                            replace_bysize      replace the existent word of specified size by content
                                            upper               convert the string to upper letter case
                                            lower               convert the string to lower letter case
                                            upper_as            convert the string to upper letter case for given char set
                                            lower_as            convert the string to lower letter case for given char set
                                            combine             compine the current input file's content to another one
                                            convert             convert the file content to wordlist
                                            
                                            ********************---------------------------------------
                                            ********************---------------------------------------
