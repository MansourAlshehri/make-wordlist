.صانعة قائمة الكلمات، اداه تعمل على أنظمة لينكس، تساعد على تعديل، إضافة او حذف المحتوى الموجود في ملف القائمة، توفر اكثر من ٢٠ وظيفة لمساعد مختبرين الاختراق او أي مستخدم لتحقيق اهدافة 

The script is used to help pentesters to orgnize and identify the wordlist content. It helps the users with more than 20 functionality such as removing, inserting, and replacing the content. I find the difficulty in finding a bash tool to create and control a targeted wordlist. I found some solutions in embeded tools such as burpsuite, but we like to deal with the terminal as a linux pros. It was so difficult to write this code, the code length exceeded 1000 lines reflecting the difficulty of mixing between the program effectiveness, and the users experience. This tool still needs to community help to imporove its functionalty.

I find some issues in this code, such verbose service, and statistcals mode function wherease it requires a long time when processing a wordlist that contains more that 20000 words. I encourage anyone to imporve the script under the GNU General Public License regarding the version(-v) content. I will be happy to touch me on 'hackersforh@gmail.com' for any help, any founded bugs, or to enhance the script.                                                           Mano-H



         __  __       _                                        _ _ _     _   
        |  \/  |     |(|                    **                | | (_)   |#|  
        | \  / | __ _| | _____    __ _  -\  **  /-___  _ __ __| | |_ ___|#|_ 
        |<|\/| |/*_  | |/ / _ \  /m*n*| \ \*/\*/ / _ \| '__/ _&^| | / __|#@@|   
        |>|  | | (_|&| ) <  __/ | (_| |  \ V  V / (_) | | | (_|^| | \__ \ |_    
        |_|  |_|\__,_|(|\_\_:_|  \_>,_|   \_/\_/ \___/|_|  \_&,_|_|_|___/\@@|   
 


   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                                          
                                                                                                                                                                      
                                                                                                                                                                      
   syntax: ./wlm.sh -f 'input file name' -o 'output file name' -m 'mode' -p 'pattern string'                                                                          
                                                                                                                                                                      
   usage instructions:                                                                                                                                                
                                                                                                                                                                      
        -f        input file name, or path                                                                                                                            
                                                                                                                                                                      
        -p        pattern string                                                                                                                                      
                                                                                                                                                                      
        -o        output file                                                                                                                                         
                                                                                                                                                                      
        -h        help                            
        
                                                                                                                                                                      
        -i        show version info                                                                                                                                                                                                                    
                                                                                                                                                                      
        -m        the mode type; it could be:                                                                                                                         
                                                                                                                                                                      
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                                          
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                                          
                                                                                                                                                                      
                supported modes:                                                                                                                                      
                                                                                                                                                                      
                remove_all          remove string that contains any pattern char(s)                                                                                   
                remove_part         remove the pattern letter(s) then concatinate the word                                                                            
                remove_bysize       remove the word if matches the given size                                                                                         
                remove_byindex      remove the letter by given index and concatinate the word                                                                         
                remove_byline       remove the word by given line number                                                                                              
                                                                                                                                                                      
                postfix             append pattern letter to the end of the word                                                                                      
                prefix              append pattern letter to the begining of the word                                                                                 
                                                                                                                                                                      
                replace_by          replace the original letter(s) set by the given letter(s) set                                                                     
                replace_bysize      replace the existent word of specified size by the given letter(s) set                                                            
                replace_byindex     replace the letter(s) of given index(s) by the given letter(s) set (overwrite existent letters)                                   
                                                                                                                                                                      
                upper               convert the string to upper letter case                                                                                           
                lower               convert the string to lower letter case                                                                                           
                upper_as            convert the string to upper letter case for given pattern string                                                                  
                lower_as            convert the string to lower letter case for given pattern string                                                                  
                                                                                                                                                                      
                combine             compine the current input file's content to another one                                                                           
                convert             convert the file content to wordlist                                                                                              
                                                                                                                                                                      
                hash                hash the wordlist content, the supported hash patterns are md5, sha1, and sha2                                                    
                encode              encode the wordlist string, supported method is url encoding                                                                      
                decode              decode the wordlist string, supported method is url decoding                                                                      
                                                                                                                                                                      
                statistics          show information about the input wordlist                                                                                         
                                                                                                                                                                      
                insert_byindexA     insert the letter(s) after the  given index         (does not overwrite existent letters)                                         
                insert_byindexB     insert the letter(s) before the given index         (does not overwrite existent letters)                                         
                insert_byA          insert the letter(s) After given substring or char  (does not overwrite existent letters)                                         
                insert_byB          insert the letter(s) before given substring or char (does not overwrite existent letters)                                         
                                                                                                                                                                      
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                                        
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                                        
                                                                                                                                                                      
     to show pattern instructions of a specified mode; input the command without a pattern string argument    
