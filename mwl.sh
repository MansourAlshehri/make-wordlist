#!/bin/bash

printf "\033[0;31m 

 	 __  __       _                                        _ _ _     _   
	|  \/  |     |(|                    **                | | (_)   |#|  
 	| \  / | __ _| | _____    __ _  -\  **  /-___  _ __ __| | |_ ___|#|_ 
	|<|\/| |/*_  | |/ / _ \  /m*n*| \ \*/\*/ / _ \| '__/ _&^| | / __|#@@|   \033[1;35m
	|>|  | | (_|&| ) <  __/ | (_| |  \ V  V / (_) | | | (_|^| | \__ \ |_    \033[1;33m
	|_|  |_|\__,_|(|\_\_:_|  \_>,_|   \_/\_/ \___/|_|  \_&,_|_|_|___/\@@|   \033[1;37m
 


   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 "

#disable keyboard input and do animation
stty -echo
chars="/-\|"
c=0
while [[ $c < 20 ]]; do #uses stty
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.1
    echo -en "${chars:$i:1}" "\r"
  done
  ((c++))
done
#enable keyboard input again
stty echo

#help methods
help_instrutions()
{
   echo -e " \033[1;33m 
   					    
   syntax: ./wlm.sh -f 'input file name' -o 'output file name' -m 'mode' -p 'pattern string'
   \033[1;37m
   usage instructions:
   
   \t-f 	  input file name, or path
   
   \t-p 	  pattern string
   
   \t-o 	  output file
   
   \t-h 	  help
   
   \t-v	  verbose, only one verbose level is used
   
   \t-i   	  show version info
   
   \t-d   	  add this script to PATH, for fast access
   "
   
   echo -e "\t-m 	  the mode type; it could be:
   
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
   		
   		upper	       	    convert the string to upper letter case
   		lower	            convert the string to lower letter case
   		upper_as	    convert the string to upper letter case for given pattern string
   		lower_as	    convert the string to lower letter case for given pattern string
   		
   		combine	            compine the current input file's content to another one
   		convert	            convert the file content to wordlist
   		
   		hash		    hash the wordlist content, the supported hash patterns are md5, sha1, and sha2
   		encode	            encode the wordlist string, supported method is url encoding
   		decode	            decode the wordlist string, supported method is url decoding
   		
   		statistics          show information about the input wordlist
   		
   		insert_byindexA     insert the letter(s) after the  given index         (does not overwrite existent letters)
   		insert_byindexB     insert the letter(s) before the given index         (does not overwrite existent letters)
   		insert_byA          insert the letter(s) After given substring or char  (does not overwrite existent letters)
   		insert_byB          insert the letter(s) before given substring or char (does not overwrite existent letters)
   		
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     
     to show pattern instructions of a specified mode; input the command without a pattern string argument
     \033[0;37m "
	exit 1
}

#print_versin_info funciton
print_version_info() {
	echo "       Version Info:
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - 
  Version number:  1.1
  Auther: 	 Mansour Abdullah
  Developed on:	 bash, version 5.1.4(1)-release (x86_64-pc-linux-gnu)
  Tested on:       
  Included tools:  tr, md5sum, shasum, sha2sum, awk, echo, stty "
	exit 1
}

#add the script to path for fast access
add_script_to_path() {
	echo ""
}

#assign given arguments
verbose=false
for (( i=1; i<=$#; i++ )) {
	if [ ${!i} = "-f" ]; then 
    		((i++)) 
        	input_file_name=${!i};	
	elif [ ${!i} = "-i" ]; then 
        	((i++)) 
      	 	print_version_info;
      	elif [ ${!i} = "-d" ]; then 
        	((i++)) 
      	 	add_script_to_path;
    	elif [ ${!i} = "-p" ]; then 
    		((i++)) 
        	pattern_string=${!i};
        elif [ ${!i} = "-m" ]; then 
    		((i++)) 
        	mode_string=${!i};
        elif [ ${!i} = "-o" ]; then 
    		((i++)) 
        	output_file=${!i};
        elif [ ${!i} = "-h" ]; then 
    		((i++)) 
        	help_instrutions;
        elif [ ${!i} = "-v" ]; then 
    		((i++)) 
        	verbose=true;
        else
        	echo "Error: the given argumant is not accepted, try -h for help"; 
        	exit 1;
    	fi
}

echo "input_file_name is $input_file_name, output_file is $output_file, mode_string is $mode_string, and pattern_string is $patteren_string"
#notify the user about missed arguments
if [ -z "$input_file_name" ]; then 
	echo "Error: input file name or file path should be given"; 
        exit 1; 
elif [ -z "$output_file" ]; then 
	#if [ $pattern_string != "statistics" ]; then
		echo "Error: output file name or file path should be given"; 
       		exit 1; 
	#fi
elif [ -z "$mode_string" ]; then 
	echo "Error: no mode string provided, you should provide someone; use -h option to show supported modes"
	exit 1
fi

#check if the input-file name is exist or not
test_if_the_input_file_exist_and_not_embty() {
	if [[ ! -e "$1" ]]; then
		echo "Error: the input file name is not exist"
		exit 1;
	fi

	#check if input file is empty
	if [ ! -s "$1" ]; then
		echo "Error: the input file is empty, the program can not proceed further";
		exit 1;
	fi
}

test_if_the_input_file_exist_and_not_embty $input_file_name

#check if the file is a wordlist or not
is_the_file_a_wordlist=true
test_if_file_is_a_wordlist() {
	
	echo ""
	echo "checking if the file is a wordlist..."
	
	while IFS= read -r line
	do
		string="${line//[$'\a\b\n\f\r\v']}"      
		echo "The string now is $string"
		word_in_progress=false
		word_counter=0
		for (( i = 0; i < ${#string}; i++ )) { \
			echo "i is $i and letter now is ${string:i:1}"
			additive_index=$((i+1))
			if [[ ${string:i:1} = " " ]]  || [[ "${string:i:1}" =  "\t" ]] || [[ $((i+1)) -eq ${#string} ]] && [ $word_in_progress = "true" ]; then
				word_counter=$((word_counter+1))
				echo "word_counter is $word_counter"
				word_in_progress=false
			       	echo "here_1"
				continue
			elif [[ ${string:i:1} =  " " ]] || [[ ${string:i:1} =  "\t" ]] && [ $word_in_progress = "false" ]; then
				echo "here_2"
				#continue
			else
				echo "here_3"
				if [[ $((i+1)) -eq ${#string} ]]; then
					word_counter=$((word_counter+1))
					echo "word_counter is $word_counter"
					word_in_progress=false
					echo "here_4"
				fi
				word_in_progress=true
			fi
		}		
		if [[ $word_counter -gt 1 ]]; then
			if [ $mode_string = "convert" ]; then
				echo "here_4"
				is_the_file_a_wordlist=false
				break
			else 
				echo "here_5"
				is_the_file_a_wordlist=false
				echo "Error: the $1 is a not a wordlist, and the program can not proceed"
				echo "Warning: the file is considered as non wordlist due to the existence of spaces or tabs within the lines"
				echo "**Note**all of these reasons will confuse bruteforce operations or any use of the wordlist"
				echo "Inform: use 'convert' mode to make it a wordlist, before proceeding to a target mode"
				exit 1
			fi
		fi
	done < $1
}

test_if_file_is_a_wordlist $input_file_name

#create restore file of output_file then restore if new result is empty
:'echo "restore file here"
restore_filename="resotrefile"
counter=0
while true; do
	if [ -f $restore_filename ]; then
		restore_filename="$restore_file$counter"
		counter=$((counter+1))
	else
		cp $output_file $restore_filename
		break;	
	fi
	echo "restore file loop $counter"
done
exit 1'

#clear stdin brfore reading
function clear_stdin() {				#by Илья Антипов
    old_tty_settings=`stty -g`
    stty -icanon min 0 time 0

    while read none; do :; done 

    stty "$old_tty_settings"
}

#relative output file name
relative_output_filename () {
	if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "Inform: enter the output file name, don't forget to include the path if needed"
		read answer_2
		call_by_function="yes"
		check_output_file_function $answer_2
	elif [[ "$1" =~ ^([nN][oO]|[nN])$ ]]; then
		echo "------------------------------------------------" >  $output_file
    		echo " **This_file_is_generated_by_a_wordlistmaker**"   >> $output_file
    		echo "------------------------------------------------" >> $output_file
	else
    		echo "Error: your input is invalid"
    		exit 1
	fi
}

#check output file name validity
check_output_file_function () {
	
	#check if call by function or deals as a first call
	if [ -z "$call_by_function" ]; then 
		output_value=$output_file;
	else
		output_value=$1;
	fi
	
	#process the output_value data
	if [ "$output_value" = "$input_file_name" ]; then 
		echo "Error: you can not output the results into the same input file";
		exit 1;
	elif [ -f "$output_value" ]; then 
		echo "Warning: be carful; the file is exist, proceeding the process will overwrite the file; then the data will be lost"
		echo "Inform: are you willing to choose another file? Y/N"
		clear_stdin
		read answer_1 
		if [ -z "$answer_1" ]; then
    			echo "Error: you did not input any argument"
    			exit 1;
    		else 
    			relative_output_filename $answer_1
		fi
	else 
		if [ ! -z "$call_by_function" ]; then 
			output_file=$output_value
		fi
	fi
}

#call check_output_file_function
check_output_file_function	

#check validity of mode string
if [ $mode_string != "remove_all" ] && [ $mode_string != "remove_part" ]     && [ $mode_string != "replace_by" ] \
                                    && [ $mode_string != "prefix" ]          && [ $mode_string != "postfix" ]  && [ $mode_string != "remove_byindex" ] \
                                    && [ $mode_string != "replace_byindex" ] && [ $mode_string != "remove_bysize" ] \
                                    && [ $mode_string != "replace_bysize" ]  && [ $mode_string != "insert_byA" ] \
                                    && [ $mode_string != "insert_byB" ]      && [ $mode_string != "insert_byindexA" ] \
                                    && [ $mode_string != "insert_byindexB" ] && [ $mode_string != "upper" ]    && [ $mode_string != "lower" ] \
                                    && [ $mode_string != "upper_as" ]        && [ $mode_string != "lower_as" ] && [ $mode_string != "combine" ] \
                                    && [ $mode_string != "convert" ]         && [ $mode_string != "hash" ]     && [ $mode_string != "remove_byline" ] \
                                    && [ $mode_string != "encode" ]          && [ $mode_string != "decode" ]   && [ $mode_string != "statistics" ]; then
	echo "Error: your input mode string is not correct";
	exit 1;
fi 

#assing mode type variable witch help in process input according to type of list
remove_stat=false
prefix_postfix=false
replace_insert=false
replace_insert_number=false
upper_lower=false
statistics_mode=false
upper_lower_as=false
special_function=false
remove_stat_byline=false
encode_decode=false
remove_stat_number=false
hash_mode=false
if [ $mode_string = "remove_all" ] || [ $mode_string = "remove_part" ]   || [ $mode_string = "remove_byindex" ] \
				   || [ $mode_string = "remove_bysize" ] || [ $mode_string = "remove_byline" ]; then
	remove_stat=true
	if [ $mode_string = "remove_byindex" ] || [ $mode_string = "remove_bysize" ]; then
		remove_stat_number=true
	fi
	if [ $mode_string = "remove_byline" ]; then
		remove_stat_byline=true
	fi
elif [ $mode_string = "prefix" ] || [ $mode_string = "postfix" ]; then
	prefix_postfix=true
elif [ $mode_string = "encode" ] || [ $mode_string = "decode" ]; then
	encode_decode=true
elif [ $mode_string = "upper" ] || [ $mode_string = "lower" ] || [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
	upper_lower=true
	if [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
		upper_lower_as=true
	fi
elif [ $mode_string = "combine" ]|| [ $mode_string = "convert" ]; then
	special_function=true
elif [ $mode_string = "hash" ]; then
	hash_mode=true
elif [ $mode_string = "statistics" ]; then
	statistics_mode=true
elif [ $mode_string = "replace_by" ] || [ $mode_string = "replace_byindex" ] || [ $mode_string = "replace_bysize" ] \
						|| [ $mode_string = "insert_byindexA" ] || [ $mode_string = "insert_byindexB" ]; then
	replace_insert=true
	if [ $mode_string = "replace_byindex" ] || [ $mode_string = "replace_bysize" ] \
						|| [ $mode_string = "insert_byindexA" ] || [ $mode_string = "insert_byindexB" ]; then
		replace_insert_number=true
	fi
fi 

#assign "_"(if no pattern given) to the pattern string if prefix or postfix modes are used, if not assign all special chars !"#$%&'()*+,-./:;<>=?@[\]^_'{}|~
if [ -z "$pattern_string" ]; then
	if [ $mode_string = "replace_by" ]; then
		echo "You should input a replace_by pattern as specified as the following format:"
		echo "       -p 'T:>R' wherease T is the original char(s)/ string(s) set, and R is the replacement set; ex 't,test:>x,XX'"
		echo "       **Note** inserting space into the pattern string will effect your results"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them, and use ':>' to distinguish between the sets"
		echo "       **Note** do not input the same value multiable times(in left side set), which will be removed in repitition removal process"
		echo "       **Note** the right side set(after :>), could have one value; ex 't,test:>x', then the left side set will be replaced by one value"
		echo "       **Note** the right side set(after :>), could have multiple values; ex 't,test,3b:>x,X,XX', then t becomes x, and test becomes X etc"
		exit 1
	elif  [ $mode_string = "replace_byindex" ]; then
		echo "You should input a replace_byindex pattern as specified as the following format:"
		echo "       -p 'T:>R' wherease T is the index(s) set, and R is the replacement set; ex '3,5:>x,XX'"
		echo "       **Note** inserting space into the pattern string will effect your results"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them, and use ':>' to distinguish between the sets"
		echo "       **Note** do not input the same value multiable times(in left side set), which will be removed in repitition removal process"
		echo "       **Note** the right side set(after :>), could have one value; ex '4,22:>x', then the left side set will be replaced by one value"
		echo "       **Note** the right side set(after :>), could have multiple values; ex '4,44,3b:>x,X,XX', then 4 becomes x, and 44 becomes X etc"
		exit 1
	elif  [ $mode_string = "replace_bysize" ]; then
		echo "You should input a replace_bysize pattern as specified as the following format:"
		echo "       -p 'T:>R' wherease T is the word size(s) list(in numbers), and R is the replacement set; ex '3,5:>x,XX'"
		echo "       **Note** inserting space into the pattern string will effect your results"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them, and use ':>' to distinguish between the sets"
		echo "       **Note** do not input the same value multiable times(in left side set), which will be removed in repitition removal process"
		echo "       **Note** the right side set(after :>), could have one value; ex '4,22:>x', then the left side set will be replaced by one value"
		echo "       **Note** the right side set(after :>), could have multiple values; ex '4,44,3b:>x,X,XX', then 4 becomes x, and 44 becomes X etc"
		exit 1
	elif [ $mode_string = "insert_byA" ] || [ $mode_string = "insert_byB" ]; then
		echo "You should input a insert_byA/ insert_byB pattern as specified as the following format:"
		echo "       -p 'T:>R' wherease T is the original char(s)/ string(s), and R is the char(s) or a string to insert set; ex 't,test:>x,XX'"
		echo "       **Note** inserting space into the pattern string will affects your results!"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "       **Note** do not input the same value multiable times(in left side set), which will be removed in repitition removal process"
		exit 1
	elif  [ $mode_string = "insert_byindexA" ] || [ $mode_string = "insert_byindexB" ]; then
		echo "You should input a replace_byindex/ replace_bysize pattern as specified as the following format:"
		echo "       -p 'T:>R' wherease T is the index(s), list(in numbers), and R is the char(s) or a string to insert set; ex '3,5:>x,XX'"
		echo "       **Note** inserting space into the pattern string will affects your results!"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "       **Note** do not input the same value multiable times(in left side set), which will be removed in repitition removal process"
		exit 1
	elif  [ $mode_string = "remove_part" ] ||  [ $mode_string = "remove_all" ]; then
		echo "You should input a $mode_string pattern as specified as the following format:"
		echo "       -p 'T' wherease T is the char(s)/ string(s) or number(s) set; ex '3,5,x,XX'"
		echo "       **Note** inserting space into the pattern string will affects your results!"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "       **Note** do not input the same value multiable times, which will be removed in repitition removal process"
		exit 1
	elif [ $mode_string = "remove_byindex" ] || [ $mode_string = "remove_bysize" ] || [ $mode_string = "remove_byline" ]; then
		echo "You should input a $mode_string pattern as specified as the following format:"
		echo "       -p 'T' wherease T is the number(s) set; ex '3,5'"
		echo "       **Note** inserting space into the pattern string will affects your results!"
		echo "       **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "       **Note** do not input the same value multiable times, which will be removed in repetition removal process"
		if [ $mode_string = "remove_byindex" ]; then
			echo "       **Note** inputting many index will reduce the word size consequently!"
		fi
		if [ $mode_string = "remove_byline" ]; then
			echo "       **Note** You can input range of numbers as specified: 1-20 using the dash symbol; ex '3,5-10'"
		fi
		exit 1
	elif [ $mode_string = "combine" ]; then
		echo "You should input a file name or path into the pattern string!"
		exit 1
	elif [ $mode_string = "convert" ]; then
		pattern_string="wordlist"; 
		printf "The default pattern that will be used is: %s \n" "$pattern_string";
	elif [ $mode_string = "hash" ]; then
		pattern_string="md5"; 
		printf "Inform: the default pattern that will be used is: %s \n" "$pattern_string";
	elif [ $mode_string = "statistics" ]; then
		pattern_string="all"; 
		printf "Inform: the default pattern that will be used is: %s \n" "$pattern_string";
	elif [ $mode_string = "encode" ] || [ $mode_string = "decode" ]; then
		pattern_string="url"; 
		printf "Inform: the default pattern that will be used is: %s \n" "$pattern_string";
	else
		if [ $mode_string = "prefix" ] || [ $mode_string = "postfix" ]; then
			pattern_string="_"; 
			printf "The default pattern that will be used are: %s \n" "$pattern_string";
		elif [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
			echo "Error: the input mode string is $mode_string, and needs to pattern string"
			echo "Inform: the pattern string is a set of chars to convert the case to; such as 'ABCO' or 'crfbs'"
			echo "Inform: inputting same value multiple times doesn't make sense"
			exit 1
		#elif [ $mode_string = "upper" ] || [ $mode_string = "lower" ]; then
		#	echo "The input mode string is $mode_string, and does not need to pattern string!"
		else
			pattern_string="@#$%\^/&*()[]}{\?><\\!,;:~\"'"; 
			printf "The default pattern that will be used are: %s \n" "$pattern_string"
		fi
	fi
else	#if pattern is provided and not required or equals to wrong value
	#check if input file into the pattern string is correct and not embty
	if [ $mode_string = "combine" ]; then
		if [[ ! -e "$pattern_string" ]]; then
			echo "Error: the input file name is not exist"
			exit 1;
		fi
		#check if input file is empty
		if [ ! -s "$pattern_string" ]; then
			echo "Error: the input file is empty!";
			exit 1;
		fi
	elif [ $mode_string = "hash" ]; then
			if [ $pattern_string != "md5" ] && [ $pattern_string != "sha1" ] && [ $pattern_string != "sha2" ]; then
				echo "Error: the input pattern string is not supported, the available hashs are md5, sha1, and sha2"
				exit 1
			fi
	elif [ $mode_string = "statistics" ]; then
			if [ $pattern_string != "all" ]; then
				echo "Error: the input pattern string is not allowed, the available pattern is all"
				exit 1
			fi
	elif [ $mode_string = "encode" ] || [ $mode_string = "decode" ]; then
			if [ $pattern_string != "url" ]; then
				printf "Error: the only available encoding methods is url";
				exit 1
			fi
	elif [ $mode_string = "convert" ]; then
		if [ $pattern_string != "wordlist" ]; then
			echo "Inform: the only pattern that is supported is a wordlist!"
		fi
	elif [ $upper_lower = "true" ] && [ $upper_lower_as = "false" ]; then
		echo "Inform: the mode string is upper or lower, and does not need a pattern string"
	fi	
fi


#deal with pattern string validity if remove_stat is true
range_arr_counter=0
range_arr=()
if [ $remove_stat = "true" ]; then
	input_set=""
	counter=0 
	first_pattern_arr=()
	for (( i=0 ; i < ${#pattern_string} ; i++ )) {
		if [[ "${pattern_string:i:1}" != "," ]]; then
			#echo "${pattern_string:i:1} is not a comma"
			input_set+=${pattern_string:i:1}
			next_index=$((i+1))
			if [ "$next_index" -lt "${#pattern_string}" ]; then
				#echo "The next index value is${pattern_string:next_index:1} on $next_index and less than ${#pattern_string}"
				if [ "${pattern_string:next_index:1}" != "," ]; then
					echo "continue_2"
        				continue
				else 
					echo "continue_3"
					if [ "$input_set" != "" ]; then
						echo $input_set
						first_pattern_arr[$counter]=$input_set
						counter=$((counter+1))
						input_set=""
					fi
					continue
				fi
			else
				first_pattern_arr[$counter]=$input_set
				counter=$((counter+1))
				echo ""
			fi
		else 
			#echo "${pattern_string:i:1} is for continue_1"
			continue
		fi
	}
	
	#test if the input is nubmer if remove is by index/ size
	if [ "$remove_stat_number" = "true" ]; then
		echo "${first_pattern_arr[@]}"
		for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
			echo "element is ${first_pattern_arr[$i]}"
			if ! [[ ${first_pattern_arr[$i]} =~ ^[0-9]+$ ]]; then        #=~ ^-?[0-9]+$
				echo "first_pattern_arr is ${first_pattern_arr[$i]}"
				echo "Error: your input pattern is in a wrong format, and the program can not be proceed"
				exit 1
			fi
		}
	fi
	
	#validate range_string if remove_stat_byline is true
	if [ "$remove_stat_byline" = "true" ]; then
		echo "first_pattern_arr is ${first_pattern_arr[@]}"
		echo "first_pattern_arr size is ${#first_pattern_arr[@]}"
		lines_arr=()
		lines_arr_counter=0
		for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
			echo "element is ${first_pattern_arr[$i]}"
			if ! [[ ${first_pattern_arr[$i]} =~ ^[0-9]+-[0-9]+$ ]] && ! [[ ${first_pattern_arr[$i]} =~ ^[0-9]+$ ]]; then        #=~ ^-?[0-9]+$
				echo "first_pattern_arr is ${first_pattern_arr[$i]}"
				echo "Error: your input pattern is in a wrong format, and the program can not be proceed"
				exit 1
			elif [[ ${first_pattern_arr[$i]} =~ ^[0-9]+$ ]]; then
				line_arr[$lines_arr_counter]=${first_pattern_arr[$i]};
				lines_arr_counter=$((lines_arr_counter+1))
			elif [[ ${first_pattern_arr[$i]} =~ ^[0-9]+-[0-9]+$ ]]; then
				#convert range to a set of numbers
				echo "convert element is ${first_pattern_arr[$i]}"
				range_string=${first_pattern_arr[$i]}
				dash_passed=false
				first_number=""
				last_number=""
				for (( j=0 ; j < ${#range_string} ; j++ )) {
					if [ $dash_passed = "false" ]; then
						if [ ${range_string:j:1} != "-" ]; then
							first_number+=${range_string:j:1}
						else
							dash_passed=true
						fi
					else
						last_number+=${range_string:j:1}
					fi
				}
				if [ $first_number -gt $last_number ]; then
					echo "first greater"
					for (( z=$last_number; z <= $first_number; z++ )) {
						line_arr[$lines_arr_counter]=$z;
						lines_arr_counter=$((lines_arr_counter+1))
					}
				elif [ $first_number -lt $last_number ]; then
					echo "second greater"
					for (( z=$first_number; z <= $last_number; z++ )) {
						line_arr[$lines_arr_counter]=$z;
						lines_arr_counter=$((lines_arr_counter+1))
					}
				elif [ $first_number -eq $last_number ]; then
					echo "equal"
					line_arr[$lines_arr_counter]=$first_number;
					lines_arr_counter=$((lines_arr_counter+1))
				fi
				#echo "first_number is $first_number"
				#echo "last_number is $last_number"
				echo "line_arr is ${line_arr[@]}"
				echo "line_arr size is ${#line_arr[@]}"
			fi
		}
	fi
	
	echo "The first_pattern_arr is ${first_pattern_arr[@]}"
	echo "The first_pattern_arr size is ${#first_pattern_arr[@]}"
fi

#deal with pattern string validity if replace_insert is true
if [ $replace_insert = "true" ]; then
	is_pattern_in_correct_format=false
	passed_replace_sign=false
	input_set=""
	pre_counter=0
	post_counter=0
	first_pattern_arr=()  
	second_input_arr=()
	replace_all_input_pattarn_by_one_letter=false
	for (( i=0 ; i < ${#pattern_string} ; i++ )) {
		#printf "The letter now is %s \n" "${pattern_string:i:1}";
		if [ $passed_replace_sign = "false" ]; then
			if [ "${pattern_string:i:1}" = ":" ] && [ ${pattern_string:$((i+1)):1} = ">" ]; then
				#if < in first char, or nothing after it
				if [ $i = 0 ]; then
					#echo "here_1"
					echo "Error: your input pattern misses the left hand side, and the program can not proceed";
					exit 1
				elif  [ "$(($i+2))" = ${#pattern_string} ]; then
					echo "Error: your input pattern misses the right hand side, and the program can not proceed";
					exit 1
				else
					#echo "here_2"
					passed_replace_sign=true
				fi
				#increment by 2, : and > letters, in case 2 sign of :> inputed together, first one will be used only
				i=$((i+2))
			fi
		fi
		if [ $passed_replace_sign = "false" ]; then
			if [[ "${pattern_string:i:1}" != "," ]]; then
				#echo "${pattern_string:i:1} is not a comma"
				input_set+=${pattern_string:i:1}
				next_index=$((i+1))
				if [ "$next_index" -lt "${#pattern_string}" ]; then
					#echo "The next index value is${pattern_string:next_index:1} on $next_index and less than ${#pattern_string}"
					if [[ "${pattern_string:next_index:1}" != "," ]] &&  [[ "${pattern_string:next_index:1}" != ":" ]]; then
						#echo "continue_2"
						continue
					else 
						#echo "continue_3"
						if [ "$input_set" != "" ]; then
							#echo $input_set
							first_pattern_arr[$pre_counter]=$input_set
							pre_counter=$((pre_counter+1))
							input_set=""
						fi
						continue
					fi
				else
					echo ""
					#echo "replace_sign_didnot passed and the string ends here!"
				fi
			else 
				#echo "${pattern_string:i:1} is for continue_1"
				continue
			fi
		else
			if [[ "${pattern_string:i:1}" != "," ]]; then
				#echo "${pattern_string:i:1} is not a comma"
				input_set+=${pattern_string:i:1}
				next_index=$((i+1))
				if [ "$next_index" -lt "${#pattern_string}" ]; then
					#echo "The next index value is${pattern_string:next_index:1} on $next_index and less than ${#pattern_string}"
					if [[ "${pattern_string:next_index:1}" != "," ]] &&  [[ "${pattern_string:next_index:1}" != ":" ]]; then
						echo "continue_2"
						continue
					else 
						echo "continue_3"
						if [ "$input_set" != "" ]; then
							echo $input_set
							second_input_arr[$post_counter]=$input_set
							post_counter=$((post_counter+1))
							input_set=""
						fi
						continue
					fi
				else
					second_input_arr[$post_counter]=$input_set
					post_counter=$((post_counter+1))
					echo ""
					#echo "replace_sign_didnot passed and the string ends here!"
				fi
			else 
				#echo "${pattern_string:i:1} is for continue_1"
				continue
			fi
		fi	
	}
	
	#test if the input is nubmer if replace is by index/ size
	if [ $replace_insert_number = "true" ]; then
		echo "${first_pattern_arr[@]}"
		for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
			echo "element is ${first_pattern_arr[$i]}"
			if ! [[ "${first_pattern_arr[$i]}" =~ ^[0-9]+$ ]]; then
				echo "Error: your input contains non numerical value at the left side(before :>), and the program can not proceed"
				exit 1
			fi
		}
	fi
	
	#check the equality of left, to right side of pattern string before repetition removal process
	echo "Inform: number of left side set is $pre_counter, and number of right side set is $post_counter"  #verbose
	if [ "$pre_counter" = "0" ] || [ "$post_counter" = "0" ] ; then
		echo "Error: your input pattern misses the left side or the right side string";
		exit 1
	elif [ "$post_counter" != 1 ]; then
		if [ "$post_counter" != "$pre_counter" ]; then
			echo "Error: the number of left side set(before :>) should meet the number of right side set"
			echo "Inform: the left side set of a pattern string should meet the set number of right side set, or replaced by one value at the right"
			exit 1
		fi
	else 
		replace_all_input_pattarn_by_one_letter=true
	fi
	echo "The last pre array is ${first_pattern_arr[@]}"
	echo "The last post array is ${second_input_arr[@]}"
fi
#exit 1
echo "here_1"

#deal with pattern string validity if upper_lower_as is true
if [ $upper_lower_as = "true" ]; then
	if ! [[ $pattern_string =~ ^[a-zA-Z]+$ ]]; then
		echo "Error: the pattern string should be in letter(s)"
		exit 1
	else
		if [ $mode_string = "upper_as" ]; then
			if ! [[ $pattern_string =~ ^[a-z]+$ ]]; then
				echo "Error: your pattern input contains non lower letter(s), and should be in small"
				exit 1
			fi
		elif [ $mode_string = "lower_as" ]; then
			if ! [[ $pattern_string =~ ^[A-Z]+$ ]]; then
				echo "Error: your pattern input contains non upper letter(s), and should be in upper"
				exit 1
			fi
		fi	
	fi
fi

#remove pattern repetition from the pattern array(left side in replace_pattern) if prefix_postfix is and ... false
if  [ "$prefix_postfix" = "false" ] && [ $upper_lower = "false" ] && [ $special_function = "false" ] && [ $encode_decode = "false" ] \
				    && [ $statistics_mode = "false" ] && [ $hash_mode = "false" ]; then 
	second_pattern_arr=()
	#echo $second_pattern_arr
	for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
		#echo "loop"
		if [ ${#second_pattern_arr[@]} -eq 0 ]; then 
        		second_pattern_arr[$i]=${first_pattern_arr[0]};
        		#echo "first block, second patten array now are !"
			printf "second array now is %s \n" "${second_pattern_arr[@]}"
			printf "second array size now is %s \n" ${#second_pattern_arr[@]} 
			echo "here_1"
        	else 
        		letter_is_exist="No";
        		#printf "letter_is_exist is %s" $letter_is_exist
        		for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
				#printf "i is %s, j is %s \n" "${first_pattern_arr[$i]}" "${second_pattern_arr[$j]}";
		 		if [ "${first_pattern_arr[$i]}" = "${second_pattern_arr[$j]}" ]; then 
		 			letter_is_exist="Yes"
		 			printf "letter_is_exist is %s" $letter_is_exist
        				#echo "Letter is exist in the second list!"
        				echo "here_2"
        				break;
        			fi
			}
			if [ $letter_is_exist = "No" ]; then 
        			second_pattern_arr[${#second_pattern_arr[@]}]=${first_pattern_arr[$i]};
        			printf "second array now is %s \n" "${second_pattern_arr[@]}"
				printf "second array size now is %s \n" ${#second_pattern_arr[@]} 
				echo "here_3"
        		fi
        	fi
        }
	echo "After pattern repetition processing:"
	printf "second_pattern_array is %s \n" "${second_pattern_arr[@]}"
	printf "second pattern size is: %s \n" "${#second_pattern_arr[@]}" 
fi

#check the equality of left, to right side of pattern string(after repetition removal process) if replace_insert is true
if [ $replace_insert = "true" ]; then
	pre_counter=${#second_pattern_arr[@]}
	echo "Inform: number of left side set is $pre_counter, and number of right side set is $post_counter"  #verbose
	if [ "$pre_counter" = "0" ] || [ "$post_counter" = "0" ] ; then
		echo "Error: your input pattern misses the left side or the right side set";
		exit 1
	elif [ "$post_counter" != 1 ]; then
		if [ "$post_counter" != "$pre_counter" ]; then
			#echo "here_3"
			echo "Error: the left side set of a pattern string should meet the set number of right side set";
			echo "Inform: the program apply repetition removal on a pattern string, which causes removing some elements from the string";
			exit 1
		fi
	else 
		replace_all_input_pattarn_by_one_letter=true
	fi
fi

#exit 1

echo ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------------------------------------------


#disable keyboard input and do animation, uses stty
stty -echo
chars="/-\|"
c=0
while [[ $c < 20 ]]; do 
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.1
    echo -en "${chars:$i:1}" "\r"
  done
  ((c++))
done
#enable keyboard input again
stty echo

#if mode_string is convert
if [ $mode_string = "convert" ]; then
	
	#test_if_file_is_a_wordlist $1
	if [ $is_the_file_a_wordlist = "true" ]; then
		echo "Inform: the input file is already a wordlist, no need to convert it"
		exit 1
	fi
	
	test_counter=0
	while IFS= read -r line; do
		#echo $line | od -c
		string="${line//[$'\a\b\n\f\r\v']}"      #\t and apace makes a problem
		echo "line is $line and string is $string"
		#echo $string | od -c
		new_string=""
		insertion_state=false
		for (( i = 0; i < ${#string}; i++ )) { 
			additive_index=$((i+1))
			#echo "i is $i at ${string:i:1}"
			if [ "${string:i:1}" !=  " " ] && [ "${string:i:1}" != "\t" ]; then
				echo "not a space"
				#insertion_state=true
				new_string+=${string:i:1}
				#echo "i is $i and additive_index is $additive_index and "
				if [ $additive_index = ${#string} ] || [ "${string:additive_index:1}" = " " ] || [ "${string:additive_index:1}" = "\t" ]; then
					echo "inner_new_string is $new_string and inserted"
					echo "$new_string" >> $output_file
					#insertion_state=false
					new_string=""
				fi
			else 
				continue
			fi
		}
    	done < "$input_file_name"
	echo "Inform: the file has been converted completely"
	exit 1
fi

#if mode_string is combine
combine_function() {				#requires md5sum
	#test the files hash if same or not
	first_file_hash=$(md5sum $input_file_name)
	second_file_hash=$(md5sum $pattern_string)
	
	if [ $first_file_hash = second_file_hash ]; then
		echo "Inform: both files have same content, try to use another file"
		exit 1
	fi
	
	#test is a pattern_string file is exist, then in a wordlist format
	test_if_the_input_file_exist_and_not_embty $pattern_string
	
	#test if a file is a valid wordlist
	test_if_file_is_a_wordlist $pattern_string
	
	#combine the pattern_file to the input_file
	while IFS= read -r line; do
    		echo "$line" >> $output_file
    	done < "$input_file_name"
    	
    	#combine the pattern_file to the pattern_string
    	echo "***combined***line***" >> $output_file
	while IFS= read -r line; do
    		echo "$line" >> $output_file
    	done < "$pattern_string"
}

#deal with combine mode
if [ "$mode_string" = "combine"   ]; then    			
    		echo "Strings are combine"
    		combine_function
    		echo "Inform: the files are combined successfully"
    		exit 1
fi

#deal with the mode statistics
if [ "$mode_string" = "statistics"   ]; then 
   	#test_if_file_is_a_wordlist $1
	
	#show number of lines, number of words by size, repetition number of words, stat command, required processing time
	line_counter=0
	embty_line_counter=0
	file_words_arr=()
	#create array of lines of wordlist
	while IFS= read -r line; do
		line_n="${line//[$' \a\b\n\f\r\t\v']}"
		if [[ $line_n != "" ]]; then
			file_words_arr[$line_counter]=$line_n
			#echo "The array now is ${file_words_arr[$line_counter]}"
			line_counter=$((line_counter+1))
		else
			embty_line_counter=$((embty_line_counter+1))
		fi
	done < "$input_file_name"
	
	#echo "The array now is ${file_words_arr[@]}"
	echo "The array size now is ${#file_words_arr[@]}"
	echo "line_counter is $line_counter"
    	
    	#create two lists one is for repeated words, another is for repeated counters per word
    	repeat_counter=0
    	counter=0
    	repeated_words_arr=()
    	repeated_substring_arr=()
    	repeated_words_counters=()
    	for (( i=0 ; i < ${#file_words_arr[@]} ; i++ )) {
    		repeat_counter=1
		for (( j=$((i+1)) ; j < ${#file_words_arr[@]} ; j++ )) {
			if [[ ${file_words_arr[$i]} = ${file_words_arr[$j]} ]]; then
				repeat_counter=$((repeat_counter+1))
			fi
		}
		if [ $repeat_counter != 1 ]; then
			if [ $counter = 0 ]; then
				repeated_words_arr[$counter]=${file_words_arr[$i]}
				repeated_words_counters[$counter]=$repeat_counter
				counter=$((counter+1))
			else
				is_word_inserted=false
				for (( z=0 ; z < ${#repeated_words_arr[@]} ; z++ )) {
					if [ ${file_words_arr[$i]} = ${repeated_words_arr[$z]} ]; then
						is_word_inserted=true
					fi
				}
				if [ $is_word_inserted = "false" ]; then
					repeated_words_arr[$counter]=${file_words_arr[$i]}
					repeated_words_counters[$counter]=$repeat_counter
					counter=$((counter+1))
				fi
			fi
		fi
	}
    	#echo "repeated_words_arr  is ${repeated_words_arr[@]}"
    	#echo "repeated_words_counters  is ${repeated_words_counters[@]}"
    	echo ""
    	echo "file information:"
    	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
    	echo "The file contains $line_counter words"
    	echo "The file contains $embty_line_counter embty lines"
    	echo ""
    	echo "word repetition information:"
    	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
    	echo ""
    	if [ $counter -gt 0 ]; then
    		for (( i=0 ; i < ${#repeated_words_arr[@]} ; i++ )) {
			printf "%30s is repeated %10s times\n" "${repeated_words_arr[$i]}" "${repeated_words_counters[$i]}"
		}
    	else
    		echo "Inform: the wordlist has not any repetition, all the words are written once"
    	fi
    	
    	exit 1
fi

#start processing
line_number=0
while IFS= read -r line; do
	
	echo "line is $line"
	#line number counter
	((line_number++))
	echo "line_number is $line_number"
	
	#convert each line to array of chars to process replace* modes
	line_n="${line//[$' \a\b\n\f\r\t\v']}"
	echo "line_n is $line_n"
	if [ $mode_string = "insert_byindexA" ] || [ "$mode_string" = "insert_byindexB" ] || [ "$mode_string" = "insert_byA"   ] \
						|| [ "$mode_string" = "insert_byB"   ]; then
		word_arr=()
		#echo $word_size; echo $line
		for (( i=0 ; i < ${#line_n} ; i++ )) {
			#echo "${line_n:i:1}"
    			word_arr[$i]=${line_n:i:1}
    			#echo "${word_arr[$i]}"
    			#echo "here"
		}
		#printf "word array is :%s \n" "${word_arr[@]}" 
		echo "size of word_arr is  ${#word_arr[@]}"                #size of array
	fi
	
	#process according the provided mode, then compare word string to pattern array, if exist apply the action(remove.. and so on)
	if [ "$mode_string" = "remove_all" ]; then 
    		echo "String is remove_all."
    		contains_unacceptable_letter=false
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			printf "i is %s \n" "${second_pattern_arr[$i]}"
    				if [[ "$line_n" ==  *"${second_pattern_arr[$i]}"*  ]]; then
    					echo "contains unaccepted"
    					contains_unacceptable_letter=true
    					break;
    				fi
    		}
    		if [ $contains_unacceptable_letter = "false" ]; then
    			echo "$line_n" >> $output_file
    		fi
	elif [ "$mode_string" = "remove_part"   ]; then    #problem if many patterns exist, first one will be used only(break)
    		echo "String is remove_part"
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			printf "i is %s \n" "${second_pattern_arr[$i]}"
    				if [[ "$line_n" ==  *"${second_pattern_arr[$i]}"*  ]]; then
    					echo "contains unaccepted"
    					line_n=${line_n//${second_pattern_arr[$i]}}
    					line_n=${line_n//[$'\a\b\n\f\r\t\v']}
    				fi
    		}
    		#echo $line_n | od -c
    	        if [ $line_n != " " ]; then
    	        	echo "$line_n" >> $output_file
    	        fi
    	elif [ "$mode_string" = "remove_bysize"   ]; then   #requires to tr
    		echo "Strings are remove_bysize "
    		#echo "$line_n" | od -c
    		#line_n=$(echo "$line_n" | tr -dc '[:print:]')
    		#echo "line_n is $line_n"
    		match_unacceptable_size=false;
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			echo "The line_n size is ${#line_n}"
    			if [ ${#line_n} = ${second_pattern_arr[$i]} ]; then
    				echo "Match the unacceptable size!"
    				match_unacceptable_size=true;
    				break
    			fi	
    		}
    		if [ $match_unacceptable_size = "false" ]; then
    			echo "$line_n" >> $output_file;
    		fi
    	elif [ "$mode_string" = "remove_byline"   ]; then   
    		echo "String is remove_byline"
    		match_unacceptable_line=false;
    		echo "The line_n size is ${#line_n}"
    		for (( i=0 ; i < ${#line_arr[@]} ; i++ ))  {
    			echo "The line_arr element is ${line_arr[$i]} at $i"
    			if [ $line_number = ${line_arr[$i]} ]; then
    				echo "line_number is $line_number"
    				echo "Match the unacceptable line number!"
    				match_unacceptable_line=true
    				break
    			fi	
    		}
    		if [ $match_unacceptable_line = "false" ]; then
    			echo "$line_n" >> $output_file;
    		fi
    	elif [ $mode_string = "remove_byindex" ]; then 
    		echo "Strings are remove_byindex"
    		new_string=$line_n
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			#printf "i is %s \n" "${second_pattern_arr[$i]}"
    			new_string=${new_string/${new_string:${second_pattern_arr[$i]}:1}}
    			echo "The index now is ${second_pattern_arr[$i]} at $i and  new_line is $new_string"
    		}
    		echo "$new_string" >> $output_file;
    	elif [ "$mode_string" = "replace_by"   ]; then 
    		echo "Strings are replace_by"
    		new_arr_after_replace=""
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			echo "The second_pattern_arr element now is: ${second_pattern_arr[$i]} at $i"
    			if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    				new_arr_after_replace=${line_n//${second_pattern_arr[$i]}/${second_input_arr[0]}}
    				if [ $line_n != $new_arr_after_replace ]; then
    					break;
    				fi
    			else
    				new_arr_after_replace=${line_n//${second_pattern_arr[$i]}/${second_input_arr[$i]}}
    				if [ $line_n != $new_arr_after_replace ]; then
    					break;
    				fi
    			fi
    		}
    		printf "The new word after replace is %s \n" "$new_arr_after_replace"
    		echo "$new_arr_after_replace" >> $output_file;
    	elif [ "$mode_string" = "replace_bysize"   ]; then 
    		echo "Strings are replace_bysize "
    		#echo "$line" | od -c
    		line_n="${line//[$'\a\b\n\f\r\t\v']}"
    		#line_n=$(echo "$line" | tr -dc '[:print:]')
    		#echo "line_n is $line_n"
    		data_inserted=false
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			echo "The line size is ${#line_n}"
    			if [ "${#line_n}" = "${second_pattern_arr[$i]}" ]; then
    				if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    					echo "${second_input_arr[0]}" >> $output_file
    					data_inserted=true
    					break;
    				else
    					echo "${second_input_arr[$i]}" >> $output_file
    					data_inserted=true
    					break;
    				fi
    			fi	
    		}
    		if [ $data_inserted = "false" ]; then
    			echo "$line" >> $output_file;
    		fi
    	elif [ "$mode_string" = "replace_byindex" ]; then	#should not allow more than one index if right side is one also, if multiple values inputted then 									#the file size will be doubles
    		echo "Strings are string replace_byindex"
    		#echo "$line" | od -c
    		line_n="${line//[$'\a\b\n\f\r\t\v']}"
    		#line_n=$(echo "$line" | tr -dc '[:print:]')
    		new_line=""
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    				second_input_arr_element=${second_input_arr[0]}
    				size_of_second_input_arr_element=${#second_input_arr_element[@]}
    				first_index=$((${second_pattern_arr[$i]}))
    				second_index=$((${second_pattern_arr[$i]}+${#second_input_arr[0]}))
    				new_line="${line:0:$first_index}${second_input_arr[0]}${line:$second_index}"
    				echo "The line is $line"
    				echo "The new_line is $new_line"
    				echo "The first_index is $first_index and current second_pattern_arr is ${second_pattern_arr[$i]}"
    				echo "The second_index is $second_index"
    				echo "$new_line" >> $output_file
    				break;
    			else
    				second_input_arr_element=${second_input_arr[$i]}
    				size_of_second_input_arr_element=${#second_input_arr_element[@]}
    				first_index=$((${second_pattern_arr[$i]}))
    				second_index=$((${second_pattern_arr[$i]}+${#second_input_arr[$i]}))
    				new_line="${line:0:$first_index}${second_input_arr[$i]}${line:$second_index}"
    				echo "The line is $line"
    				echo "The new_line is $new_line"
    				echo "The first_index is $first_index and current second_pattern_arr is ${second_pattern_arr[$i]}"
    				echo "The second_index is $second_index"
    				echo "$new_line" >> $output_file
    			fi
    		}
    	elif [ "$mode_string" = "insert_byA"   ]; then 
    		echo "String is insert_byA"
    		string_after_insertion=""
		for (( i=0 ; i < ${#word_arr[@]} ; i++ )) {
			is_inserted=false
			for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
				string=${second_pattern_arr[$j]}
				#echo "string is $string"
				if [ ${#string} = 1 ]; then
					echo "i is ${word_arr[$i]} at $i and j is ${second_pattern_arr[$j]} at $j"
					echo "string length is 1"
					if [ ${word_arr[$i]} = ${second_pattern_arr[$j]} ]; then
						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
							string_after_insertion+=${word_arr[$i]}
							string_after_insertion+=${second_input_arr[0]}
							is_inserted=true
							break
						else
							string_after_insertion+=${word_arr[$i]}
							string_after_insertion+=${second_input_arr[$j]}
							is_inserted=true
							break
						fi
					fi
				else
				        echo "string length is not  1"
					letter_equal=false
					new_i_index=$i
					#test if upper index of word_arr equals to string(second pattern array element)
					for (( z=0 ; z < ${#string} ; z++ )) {
						echo "i is ${word_arr[$new_i_index]} at $new_i_index and z is ${second_pattern_arr:z:1} at $z"
						if [[ ${word_arr[$new_i_index]} = ${string:z:1} ]] && [[ $new_i_index < ${#word_arr[@]} ]]; then
						        echo "is equals"
							letter_equal=true
							new_i_index=$((new_i_index+1))
						else
							letter_equal=false
							break
						fi	
					}
					if [ $letter_equal = "true" ]; then
						echo "substring is equals"
						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
							string_after_insertion+=$string 
							string_after_insertion+=${second_input_arr[0]}
							i=$((new_i_index-1))
							is_inserted=true
							break
						else
							string_after_insertion+=$string 
							string_after_insertion+=${second_input_arr[$j]}
							i=$((new_i_index-1))
							is_inserted=true
							break
						fi
					fi
				fi
			}
			if [ $is_inserted = "false" ];then
    				string_after_insertion+=${word_arr[$i]} 
    			fi 
		}
		echo "$string_after_insertion" >> $output_file;
    	elif [ "$mode_string" = "insert_byB"   ]; then 
    		echo "Strings are insert_byB"
    		string_after_insertion=""
		for (( i=0 ; i < ${#word_arr[@]} ; i++ )) {
			is_inserted=false
			for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
				string=${second_pattern_arr[$j]}
				#echo "string is $string"
				if [ ${#string} = 1 ]; then
					echo "i is ${word_arr[$i]} at $i and j is ${second_pattern_arr[$j]} at $j"
					echo "string length is 1"
					if [ ${word_arr[$i]} = ${second_pattern_arr[$j]} ]; then
						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
							string_after_insertion+=${second_input_arr[0]}
							string_after_insertion+=${word_arr[$i]}
							is_inserted=true
							break
						else
							string_after_insertion+=${second_input_arr[$j]}
							string_after_insertion+=${word_arr[$i]}
							is_inserted=true
							break
						fi
					fi
				else
				        echo "string length is not  1"
					letter_equal=false
					new_i_index=$i
					#test if upper index of word_arr equals to string(second pattern array element)
					for (( z=0 ; z < ${#string} ; z++ )) {
						echo "i is ${word_arr[$new_i_index]} at $new_i_index and z is ${second_pattern_arr:z:1} at $z"
						if [[ ${word_arr[$new_i_index]} = ${string:z:1} ]] && [[ $new_i_index < ${#word_arr[@]} ]]; then
						        echo "is equals"
							letter_equal=true
							new_i_index=$((new_i_index+1))
						else
							letter_equal=false
							break
						fi	
					}
					if [ $letter_equal = "true" ]; then
						echo "substring is equals"
						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
							string_after_insertion+=${second_input_arr[0]}
							string_after_insertion+=$string 
							i=$((new_i_index-1))
							is_inserted=true
							break
						else
							string_after_insertion+=${second_input_arr[$j]}
							string_after_insertion+=$string 
							i=$((new_i_index-1))
							is_inserted=true
							break
						fi
					fi
				fi
			}
			if [ $is_inserted = "false" ];then
    				string_after_insertion+=${word_arr[$i]} 
    			fi 
		}
		echo "$string_after_insertion" >> $output_file;
    	
    	elif [ "$mode_string" = "insert_byindexA"   ]; then 
    		echo "mode_string is insert_byindexA"
    		string_after_insertion=""
    		index_of_new_array=0
    		for (( i=0 ; i < ${#word_arr[@]} ; i++ )) {
    			is_inserted=false
    			for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
    				#printf "i is ${word_arr[$i]} at $i and j is ${#second_pattern_arr[$j]} at $j"
    				if [ $i = ${second_pattern_arr[$j]} ]; then
    					echo "i is ${word_arr[$i]} at $i and j is ${second_pattern_arr[$j]} at $j  and equals"
    					if [[ ${second_pattern_arr[$j]} -lt ${#word_arr[@]} ]]; then
    						echo " second_pattern_arr[$j] is ${second_pattern_arr[$j]} and word_arr size is ${#word_arr[@]}!"
    						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    							#insert current letter at $i and add the string after it
    							string_after_insertion+=${word_arr[$i]} 
    							string_after_insertion+=${second_input_arr[0]}
    							is_inserted=true
    							break
    						else
    							string_after_insertion+=${word_arr[$i]} 
    							string_after_insertion+=${second_input_arr[$j]}
    							is_inserted=true
    							break
    						fi		
    					fi
    				fi
    			}
    			if [ $is_inserted = "false" ];then
    				string_after_insertion+=${word_arr[$i]} 
    			fi 
		}
		echo "$string_after_insertion" >> $output_file;
    	elif [ "$mode_string" = "insert_byindexB"   ]; then 
		echo "mode_string is insert_byindexB"
		string_after_insertion=""
    		index_of_new_array=0
    		for (( i=0 ; i < ${#word_arr[@]} ; i++ )) {
    			is_inserted=false
    			for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
    				#printf "i is ${word_arr[$i]} at $i and j is ${#second_pattern_arr[$j]} at $j"
    				if [ $i = ${second_pattern_arr[$j]} ]; then
    					echo "i is ${word_arr[$i]} at $i and j is ${second_pattern_arr[$j]} at $j  and equals"
    					if [ ${second_pattern_arr[$j]} -lt ${#word_arr[@]} ] && [ $i != 0 ]; then
    						echo " second_pattern_arr[$j] is ${second_pattern_arr[$j]} and word_arr size is ${#word_arr[@]}!"
    						if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    							#insert current letter at $i and add the string after it
    							string_after_insertion+=${second_input_arr[0]}
    							string_after_insertion+=${word_arr[$i]} 
    							is_inserted=true
    							break
    						else
    							string_after_insertion+=${second_input_arr[$j]}
    							string_after_insertion+=${word_arr[$i]} 
    							is_inserted=true
    							break
    						fi		
    					fi
    				fi
    			}
    			if [ $is_inserted = "false" ];then
    				string_after_insertion+=${word_arr[$i]} 
    			fi 
		}
		echo "$string_after_insertion" >> $output_file;
    	elif [ "$mode_string" = "prefix"   ]; then 
    		echo "Strings is prefix"
    		prefix_string=$pattern_string
    		prefix_string+=$line_n
    		echo "The result prefix string is $prefix_string";
    		echo "$prefix_string" >> $output_file;
    	elif [ "$mode_string" = "postfix"   ]; then    #gives wrong output, maybe a bug in the software
    		echo "Strings are postfix"
    		postfix_string=$line_n
    		echo "line is $postfix_string"
    		postfix_string+=$pattern_string
    		echo "after insertion is $postfix_string"
    		echo "$postfix_string" >> $output_file;
    	elif [ "$mode_string" = "upper"   ]; then    				#requires tr
    		echo "Strings are upper"
    		echo "$line_n" | tr '[:lower:]' '[:upper:]' >> $output_file;
    	elif [ "$mode_string" = "lower"   ]; then    				#requires tr
    		echo "Strings are upper"
    		echo "$line_n" | tr '[:upper:]' '[:lower:]' >> $output_file;
    	elif [ "$mode_string" = "upper_as"   ]; then    			#requires tr
    		echo "Strings are upper_as"
    		upper_value=$(echo $pattern_string | tr '[:lower:]' '[:upper:]')
    		echo "pattern_string is $pattern_string"
    		echo "upper_value is $upper_value"
    		echo "$line_n" | tr "$pattern_string" "$upper_value" >> $output_file;
    	elif [ "$mode_string" = "lower_as"   ]; then    			#requires tr
    		echo "Strings are lower_as"
    		lower_value=$(echo $pattern_string | tr '[:upper:]' '[:lower:]')
    		echo "pattern_string is $pattern_string"
    		echo "lower_value is $lower_value"
    		echo "$line_n" | tr "$pattern_string" "$lower_value" >> $output_file
    	elif [ "$mode_string" = "encode"   ]; then    								
    		echo "String is encode"
    		string_after_encoding=""
    		for (( i = 0; i < ${#line_n}; i++ )) {
        		c="${line_n:i:1}"
        		case $c in
            			[a-zA-Z0-9.~_-]) string_after_encoding+=$c ;;
        		        *) string_after_encoding+=$(printf '%%%02X' "'$c") ;;
        		esac
    		}
		echo "$string_after_encoding" >> $output_file
	elif [ "$mode_string" = "decode"   ]; then    				
    		echo "Strings are decode"
    		string_after_decoding=""
    		url_encoded="${line_n//+/ }"
    		string_after_decoding=$(printf '%b' "${url_encoded//%/\\x}")
    		echo "$string_after_decoding" >> $output_file
    		#echo $string_after_decoding | od -c
    	elif [ "$mode_string" = "hash" ]; then    			#requires tr
    		echo "Strings are hash"
    		hashed_string=""
    		#echo "$line_n" | od -c
    		if [ $pattern_string = "md5" ]; then                     #require md5sum, sha1sum, sha2sum, and awk
    			hashed_string=$(md5sum  <<< $line_n  | awk '{ print $1 }')
    		elif [ $pattern_string = "sha1" ]; then
    			hashed_string=$(shasum  <<< $line_n  | awk '{ print $1 }')
    		elif [ $pattern_string = "sha2" ]; then
    		    	hashed_string=$(sha2sum <<< $line_n  | awk '{ print $1 }')
    		fi
    		echo "$hashed_string" >> $output_file
	fi
	#echo "after continue"
	echo ""
	#echo "$line"
done < "$input_file_name"

#check if output is embty then notify the user about it!
if [ ! -f "$output_file" ]; then
	echo "Error: no data has been inserted into the output file, your condition finalizes to this results";
	exit 1;
fi

#remove all input spaces of a wordlist
#capture tr/ sha1sum/ echo error output when inputting -p "[:A-Z:]" -m lower_as
#-p "nn,cl:>3,"33 works well


#complete line by number, hashes gives different results from online tools, progress
#version test on, participant, tools, restore(195), is /NNN unprinted letter?
#unify the repetition in arrays in one method such as line_arr and statistics
