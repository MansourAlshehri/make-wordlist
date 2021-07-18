#!/bin/bash

echo "
  __  __       _                                        _ _ _     _   
 |  \/  |     |(|                    **                | | (_)   |#|  
 | \  / | __ _| | _____    __ _  -\  **  /-___  _ __ __| | |_ ___|#|_ 
 |<|\/| |/*_  | |/ / _ \  /m*n*| \ \*/\*/ / _ \| '__/ _&^| | / __|#@@|
 |>|  | | (_|&| ) <  __/ | (_| |  \ V  V / (_) | | | (_|^| | \__ \ |_ 
 |_|  |_|\__,_|(|\_\_:_|  \_>,_|   \_/\_/ \___/|_|  \_&,_|_|_|___/\@@|
 
 
 "
echo "----------------------------------------------------------------------"
echo "      ---Author => < Mansour Abdullah
      ---Review => < Muhammed Mujeeb
      ---Version 1
      
      The main syntax : ./mwl.sh -f 'input file name' -o 'output file name' -m 'mode string' -p 'pattern string'
      
      "
#help methods
help_instrutions()
{
   echo "Usage instructions:"
   echo -e "\t-f the file name that you wish to filter its content, use the file path if the file does not exist in current directory"
   echo -e "\t-p the pattern to remove from the word, input a list of non-accepted letters that should be removed from the word"
   echo -e "\t-o the output file to write new wordlist in!"
   echo -e "\t-m the mode type; it could be (letter level processing):
   					    remove_all          remove  the string that contains any pattern char(s) from the list
                                            remove_part         remove  the pattern letter then concatinate other letters
                                            remove_bysize       remove the word if match the pattern size
                                            remove_byindex      remove the letter by given index and concatinate ramainder letters
                                            postfix             append pattern letter to the end of the word
                                            prefix              append pattern letter to the begining of the word	
                                            replace_by          replace the original letter(s) set by the given letter(s) set
                                            replace_byindex     replace the letter by given index(overwrite existent letters)
                                            replace_bysize      replace the existent word of specified size by content
                                            upper	        convert the string to upper letter case
                                            lower	        convert the string to lower letter case
                                            upper_as	        convert the string to upper letter case for given char set
                                            lower_as	        convert the string to lower letter case for given char set
                          		    combine	        compine the current input file's content to another one
                          		    convert	        convert the file content to wordlist
                          		    "
        echo "                       	                    ********************---------------------------------------"
        echo "                            	            ********************---------------------------------------"
	exit 1
}

#assign given arguments 
while getopts "f:m:p:o:h" opt
do
   case "$opt" in
      f ) input_file_name="$OPTARG" ;;
      p ) pattern_string="$OPTARG" ;;
      m ) mode_string="$OPTARG" ;;
      o ) output_file="$OPTARG" ;;
      h ) help_instrutions ;; # Print help_instrutions in case parameter is non-existent
      * ) echo "You used a wrong option, try -h for help!"; exit 1;; 
   esac
done

#notify the user about missed arguments
if [ -z "$input_file_name" ] 
then {
	echo "Error: input file name or file path should be given!"; 
        exit 1; 
}
elif [ -z "$output_file" ] 
then {
	echo "Error: output file name or file path should be given!"; 
        exit 1; 
}
elif [ -z "$mode_string" ]; then 
{
	mode_string="remove_all";
  	printf "The default mode that will be used is remove_all \n";
}
elif [ -z "$pattern_string" ] 
then {
	#The following lines moves to mitigate the existence of prefix and postfix letters
	#pattern_string="@#$%\^/&*()[]}{\?><\\!,;:~\"'"; #this is all special chars @#$%\^/&*()[]}{\?><\!,;:~
	#printf "The default pattern that will be used are: %s \n" "$pattern_string";
	
	echo "";
}
else
   #echo "start input string testing then run animation!";
   echo ""
fi

#check if the input-file name is exist or not
test_if_the_input_file_exist_and_not_embty() {
	if [[ ! -e "$1" ]]; then
		echo "Error: the file name that you have provided is not correct!"
		exit 1;
	fi

	#check if input file is empty
	if [ ! -s "$1" ]; then
		echo "The input file is empty!";
		exit 1;
	fi
}

test_if_the_input_file_exist_and_not_embty $input_file_name

#check if the file is a wordlist or not
is_the_file_a_wordlist=true
test_if_file_is_a_wordlist() {
	while IFS= read -r line
	do
		string="${line//[$'\a\b\n\f\r\v\NNN']}"      #\t and apace makes a problem
		#stop loop excution, to save the performace wherease one line contains non wordlist format
		if [ $is_the_file_a_wordlist = "false" ]; then
			break;
		fi
		
		first_space_passed=false
		first_letter_passed=false
		second_space_passed=false
		for (( i = 0; i < ${#string}; i++ )) { 
			if [[ "${string:i:1}" =  *" "* ]] || [[ "${string:i:1}" =  *$'\t'* ]] && [[ $first_letter_passed = "false" ]]; then
				continue
			elif [ "${string:i:1}" !=  *" "* ] || [[ "${string:i:1}" =  *$'\t'* ]] && [[ $first_letter_passed = "false" ]]; then
				first_letter_passed=true
				continue
			elif [[ "${string:i:1}" =  *" "* ]] || [[ "${string:i:1}" =  *$'\t'* ]] && [[ $first_letter_passed = "true" ]]; then
				second_space_passed=true
				continue
			elif [[ "${string:i:1}" !=  *" "* ]] || [[ "${string:i:1}" =  *$'\t'* ]] \
			                                     && [[ $first_letter_passed = "true" ]] && [[ $second_space_passed = "true" ]]; then
				if [ $mode_string = "convert" ]; then
					is_the_file_a_wordlist=false
					echo "The input file is a not a wordlist!, and need to be converted!"
					break
					#go to convert process to complter convertion
				else 
					is_the_file_a_wordlist=false
					echo "The $1 is a not a wordlist!, and can not be processed!"
					exit 1
				fi
			fi
		}
	done < $1
}

test_if_file_is_a_wordlist $input_file_name

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
		echo "Terrible, you can't output the results into the same input file!";
		exit 1;
	elif [ -f "$output_value" ]; then {
		echo "Be carful; the file is exist, proceeding the process will overwrite the file; then the data will be lost!"
		echo "Are you willing to choose another file? Y/N"
		read answer_1 
		if [ -z "$answer_1" ]; then
    			echo "You didn't input any argument!"
    			exit 1;
    		else {
    			if [ "$answer_1" = "N" ] || [ "$answer_1" = "n" ]; then 
    				export PS1="\e[0;31m[\u@\h \W]\\$ \e[m "
    				echo "------------------------------------------------" > $output_file;
    				echo "**This file is generated by a wordlist program**" >> $output_file;
    				echo "------------------------------------------------" >> $output_file;
    				#echo "$output_file has been overwritten!"
			elif [ "$answer_1" = "Y" ] || [ "$answer_1" = "y" ]; then
				echo "enter the output file name, don't forget to include the path if needed!"
				read answer_2
				call_by_function="yes"
				check_output_file_function $answer_2;
			else
				echo "Your input is invalid!"
    				exit 1;
			fi
		}
		fi
	}
	else {
		if [ ! -z "$call_by_function" ]; then 
			output_file=$output_value
			echo "file name is not exist"
		fi
	}
	fi
}

#call check_output_file_function
check_output_file_function	

#check validity of mode string
if [ $mode_string != "remove_all" ] && [ $mode_string != "remove_part" ] && [ $mode_string != "replace_by" ] \
                                  && [ $mode_string != "prefix" ] && [ $mode_string != "postfix" ] && [ $mode_string != "remove_byindex" ] \
                                  && [ $mode_string != "replace_byindex" ] && [ $mode_string != "remove_bysize" ] \
                                  && [ $mode_string != "replace_bysize" ] \
                                  && [ $mode_string != "insert_byA" ] && [ $mode_string != "insert_byB" ] \
                                  && [ $mode_string != "insert_byindexA" ]  && [ $mode_string != "insert_byindexB" ] \
                                  && [ $mode_string != "upper" ]  && [ $mode_string != "lower" ] \
                                  && [ $mode_string != "upper_as" ]   && [ $mode_string != "lower_as" ] && [ $mode_string != "combine" ] \
                                  && [ $mode_string != "convert" ]; then
	echo "You have entered incorrect mode string!";
	exit 1;
fi 

#assing mode type variable witch help in process input according to type of list
remove_stat=false
prefix_postfix=false
replace_insert=false
replace_insert_number=false
upper_lower=false
upper_lower_as=false
special_function=false
if [ $mode_string = "remove_all" ] || [ $mode_string = "remove_part" ] || [ $mode_string = "remove_byindex" ] || [ $mode_string = "remove_bysize" ]; then
	remove_stat=true
	if [ $mode_string = "remove_byindex" ] || [ $mode_string = "remove_bysize" ]; then
		remove_stat_number=true
	fi
elif [ $mode_string = "prefix" ] || [ $mode_string = "postfix" ]; then
	prefix_postfix=true
elif [ $mode_string = "upper" ] || [ $mode_string = "lower" ] || [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
	upper_lower=true
	if [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
		upper_lower_as=true
	fi
elif [ $mode_string = "combine" ]|| [ $mode_string = "convert" ]; then
	special_function=true
else
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
		echo "                     -p 'T:>R' wherease T is the original char(s)/ string(s), and R is the replacement set!"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		exit 1
	elif  [ $mode_string = "replace_byindex" ] || [ $mode_string = "replace_bysize" ]; then
		echo "You should input a replace_byindex/ replace_bysize pattern as specified as the following format:"
		echo "                     -p 'T:>R' wherease T is the index(s), or word size(s) list(in numbers), and R is the replacement set"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		exit 1
	elif [ $mode_string = "insert_byA" ] || [ $mode_string = "insert_byB" ]; then
		echo "You should input a insert_byA/ insert_byB pattern as specified as the following format:"
		echo "                     -p 'T:>R' wherease T is the original char(s)/ string(s), and R is the char(s) or a string to insert set!"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		exit 1
	elif  [ $mode_string = "insert_byindexA" ] || [ $mode_string = "insert_byindexB" ]; then
		echo "You should input a replace_byindex/ replace_bysize pattern as specified as the following format:"
		echo "                     -p 'T:>R' wherease T is the index(s), list(in numbers), and R is the char(s) or a string to insert set!"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		exit 1
	elif  [ $mode_string = "remove_part" ] ||  [ $mode_string = "remove_all" ]; then
		echo "You should input a remove_part/ remove_all pattern as specified as the following format:"
		echo "                     -p 'T' wherease T is the char(s)/ string(s) or number(s) set"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		exit 1
	elif [ $mode_string = "remove_byindex" ] || [ $mode_string = "remove_bysize" ]; then
		echo "You should input a remove_byindex/ remove_bysize pattern as specified as the following format:"
		echo "                     -p 'T' wherease T is the number(s) set"
		echo "                     **Note** inserting space into the pattern string will affects your results!"
		echo "                     **Note** if many input inserted, then use the comma (,) to separate them!"
		echo "                     **Note** do not input the same value multiable times(in left side set), the program apply repetition removal process, 						            which will break the program excution!"
		if [ $mode_string = "remove_byindex" ]; then
			echo "             **Note** inputting many index will reduce the word size consequently!"
		fi
		exit 1
	elif [ $mode_string = "combine" ]; then
		echo "You should input a file name or path into the pattern string!"
		exit 1
	elif [ $mode_string = "convert" ]; then
		pattern_string="wordlist"; 
		printf "The default pattern that will be used are: %s \n" "$pattern_string";
	else
		if [ $mode_string = "prefix" ] || [ $mode_string = "postfix" ]; then
			pattern_string="_"; 
			printf "The default pattern that will be used are: %s \n" "$pattern_string";
		elif [ $mode_string = "upper_as" ] || [ $mode_string = "lower_as" ]; then
			echo "The input mode string is upper_as or lower_as, and does need to pattern string!"
			echo "The pattern string is a set of chars to convert the case to such as 'ABCO' or 'crfbs'"
			exit 1
		elif [ $mode_string = "upper" ] || [ $mode_string = "lower" ]; then
			echo "The input mode string is upper or lower, and does not need to pattern string!"
		else
			pattern_string="@#$%\^/&*()[]}{\?><\\!,;:~\"'"; 
			printf "The default pattern that will be used are: %s \n" "$pattern_string";
		fi
	fi
else	#if pattern is provided and not required
	#check if input file into the pattern string is correct and not embty
	if [ $mode_string = "combine" ]; then
		if [[ ! -e "$pattern_string" ]]; then
			echo "Error: the file name that you have provided is not correct!"
			exit 1;
		fi
		#check if input file is empty
		if [ ! -s "$pattern_string" ]; then
			echo "The input file is empty!";
			exit 1;
		fi
	elif [ $mode_string = "convert" ]; then
		if [ $pattern_string != "wordlist" ]; then
			echo "The only pattern that is supported is a wordlist!"
		fi
	elif [ $upper_lower="true" ] && [ $upper_lower_as="false" ]; then
		echo "The input mode string is upper or lower, and does not need to pattern string!"
	fi	
fi

#deal with pattern string validity if remove_stat is true
if [ $remove_stat = "true" ]; then
	input_set=""
	counter=0 
	first_pattern_arr=()
	for (( i=0 ; i < ${#pattern_string} ; i++ )) {
		if [[ "${pattern_string:i:1}" != "," ]]; then
			input_set+=${pattern_string:i:1}
			next_index=$((i+1))
			if [ "$next_index" -lt "${#pattern_string}" ]; then
				#echo "The next index value is${pattern_string:next_index:1} on $next_index and less than ${#pattern_string}"
				if [ "${pattern_string:next_index:1}" != "," ]; then
        				continue
				else 
					if [ "$input_set" != "" ]; then
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
			continue
		fi
	}
	
	#test if the input is nubmer if replace is by index/ size
	if [ "$remove_stat_number" = "true" ]; then
		for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
			if [[ "${first_pattern_arr[$i]}" != [0-9]* ]]; then
				echo "Your input contains unnumerical values, which is not allowed!"
				exit 1
			fi
		}
	fi
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
		if [ $passed_replace_sign = "false" ]; then
			if [ "${pattern_string:i:1}" = ":" ] && [ ${pattern_string:$((i+1)):1} = ">" ]; then
				#if < in first char, or nothing after it
				if [ $i = 0 ] ||  [ "$(($i+2))" = ${#pattern_string} ]; then
					echo "Your input pattern($mode_string) is not in a correct format!";
					exit 1
				else
					passed_replace_sign=true
				fi
				#increment by 2, : and > letters, in case 2 sign of :> inputed together, first one will be used only
				i=$((i+2))
			fi
		fi
		if [ $passed_replace_sign = "false" ]; then
			if [[ "${pattern_string:i:1}" != "," ]]; then
				input_set+=${pattern_string:i:1}
				next_index=$((i+1))
				if [ "$next_index" -lt "${#pattern_string}" ]; then
					if [[ "${pattern_string:next_index:1}" != "," ]] &&  [[ "${pattern_string:next_index:1}" != ":" ]]; then
						continue
					else 
						if [ "$input_set" != "" ]; then
							first_pattern_arr[$pre_counter]=$input_set
							pre_counter=$((pre_counter+1))
							input_set=""
						fi
						continue
					fi
				else
					echo ""
				fi
			else 
				continue
			fi
		else
			if [[ "${pattern_string:i:1}" != "," ]]; then
				input_set+=${pattern_string:i:1}
				next_index=$((i+1))
				if [ "$next_index" -lt "${#pattern_string}" ]; then
					if [[ "${pattern_string:next_index:1}" != "," ]] &&  [[ "${pattern_string:next_index:1}" != ":" ]]; then
						continue
					else 
						if [ "$input_set" != "" ]; then
							second_input_arr[$post_counter]=$input_set
							post_counter=$((post_counter+1))
							input_set=""
						fi
						continue
					fi
				else
					second_input_arr[$post_counter]=$input_set
					post_counter=$((post_counter+1))
				fi
			else 
				continue
			fi
		fi	
	}
	
	#test if the input is nubmer if replace is by index/ size
	if [ $replace_insert_number = "true" ]; then
		for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
			if [[ "${first_pattern_arr[$i]}" != [0-9]* ]]; then
				echo "Your input contains unnumerical values at the left side, which is not allowed!"
				exit 1
			fi
		}
	fi
	
	#check the equality of left, to right side of pattern string before repetition removal process
	if [ "$pre_counter" = "0" ] || [ "$post_counter" = "0" ] ; then
		echo "Your input pattern misses the left side or the right side string!";
		exit 1
	elif [ "$post_counter" != 1 ]; then
		if [ "$post_counter" != "$pre_counter" ]; then
			echo "The left side set of a pattern string should meet the set number of right side set!";
			exit 1
		fi
	else 
		replace_all_input_pattarn_by_one_letter=true
	fi
fi

#deal with pattern string validity if upper_lower is true
if [ $upper_lower_as = "true" ]; then
	if [ $mode_string = "upper_as" ]; then
		if [ $pattern_string != [a-z] ]; then
			echo "Your pattern input contains non upper letter(s), and the process will proceed further!"
		fi
	elif [ $mode_string = "lower_as" ]; then
		if [ $pattern_string != [A-Z] ]; then
			echo "Your pattern input contains non lower letter(s), and the process will proceed further!"
		fi
	fi
fi

#remove pattern repetition from the pattern array(left side in replace_pattern) if prefix_postfix is false
if  [ "$prefix_postfix" = "false" ] && [ $upper_lower = "false" ] && [ $special_function = "false" ]; then 
	second_pattern_arr=()
	for (( i=0 ; i < ${#first_pattern_arr[@]} ; i++ )) {
		if [ ${#second_pattern_arr[@]} -eq 0 ]; then 
        		second_pattern_arr[$i]=${first_pattern_arr[0]};
        	else 
        		letter_is_exist="No";
        		for (( j=0 ; j < ${#second_pattern_arr[@]} ; j++ )) {
		 		if [ "${first_pattern_arr[$i]}" = "${second_pattern_arr[$j]}" ]; then 
		 			letter_is_exist="Yes"
        				break;
        			fi
			}
			if [ $letter_is_exist = "No" ]; then 
        			second_pattern_arr[${#second_pattern_arr[@]}]=${first_pattern_arr[$i]};
        		fi
        	fi
        }
fi

#check the equality of left, to right side of pattern string(after repetition removal process) if replace_insert is true
if [ $replace_insert = "true" ]; then
	pre_counter=${#second_pattern_arr[@]}
	if [ "$pre_counter" = "0" ] || [ "$post_counter" = "0" ] ; then
		echo "Your input pattern misses the left side or the right side string!";
		exit 1
	elif [ "$post_counter" != 1 ]; then
		if [ "$post_counter" != "$pre_counter" ]; then
			echo "The left side set of a pattern string should meet the set number of right side set, the repetition process may removed the matched 				      elements!";
			exit 1
		fi
	else 
		replace_all_input_pattarn_by_one_letter=true
	fi
fi

echo ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo ------------------------------------------------------------------------------------------------------------------------------------------------------------

#if mode_string is convert
if [ $mode_string = "convert" ]; then
	
	#test_if_file_is_a_wordlist $1
	if [ $is_the_file_a_wordlist = "true" ]; then
		echo "The input file is already a wordlist!, no need to convert it!"
		exit 1
	fi
	
	while IFS= read -r line; do
		string="${line//[$'\a\b\n\f\r\v\NNN']}"      #\t and apace makes a problem
		new_string=""
		insertion_state=false
		for (( i = 0; i < ${#string}; i++ )) { 
			if [ "${string:i:1}" =  " " ] || [ "${string:i:1}" = $'\t' ]; then
				if [ $insertion_state = "true" ]; then
					echo $new_string >> $output_file
					insertion_state=false
					new_string=""
				fi
				continue
			elif [ "${string:i:1}" !=  " " ] && [ "${string:i:1}" != $'\t' ]; then
				insertion_state=true
				new_string+=${string:i:1}
				additive_index=$((i+1))
				if [ $additive_index = ${#string} ]; then
					echo $new_string >> $output_file
					insertion_state=false
					new_string=""
				fi
			fi
		}
    	done < "$input_file_name"
	echo "The file has been converted completely!"
	exit 1
fi

#if mode_string is combine
combine_function() {				#requires sha1sum
	#test the files hash if same or not
	first_file_hash=$(md5sum $input_file_name)
	second_file_hash=$(md5sum $pattern_string)
	
	if [[ $first_file_hash = $second_file_hash ]]; then
		echo "Both files have same content, try to use another file!"
		exit 1
	fi
	
	#test is a pattern_string file is exist, then in a wordlist format
	test_if_the_input_file_exist_and_not_embty $pattern_string
	
	#test if a file is a valid wordlist
	test_if_file_is_a_wordlist $pattern_string
	
	#combine the pattern_file to the input_file
	while IFS= read -r line; do
    		echo $line >> $output_file
    	done < "$input_file_name"
    	
    	#combine the pattern_file to the pattern_string
    	echo "*** combined *** line ***" >> $output_file
	while IFS= read -r line; do
    		echo $line >> $output_file
    	done < "$pattern_string"
}

#deal with combine mode
if [ "$mode_string" = "combine"   ]; then    			
    		combine_function
    		echo "The files are combined successfully!"
    		exit 1
fi

#start processing
while IFS= read -r line; do
	
	#convert each line to array of chars to process replace* modes
	word_arr=()
	word_size=$((${#line}-1))
	for (( i=0 ; i < $word_size ; i++ )) {
    		word_arr[$i]=${line:i:1}
	}
	
	#process according the provided mode, then compare word string to pattern array, if exist apply the action(remove.. and so on)
	if [ "$mode_string" = "remove_all" ]; then 
    		contains_unacceptable_letter=false
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    				if [[ "$line" ==  *"${second_pattern_arr[$i]}"*  ]]; then
    					contains_unacceptable_letter=true
    					break;
    				fi
    		}
    		if [ $contains_unacceptable_letter = "false" ]; then
    			echo $line >> $output_file
    		fi
	elif [ "$mode_string" = "remove_part"   ]; then    #problem if many patterns exist, first one will be used only(break)
    		contains_unacceptable_letter=false
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    				if [[ "$line" ==  *"${second_pattern_arr[$i]}"*  ]]; then
    					echo "${line//${second_pattern_arr[$i]}}" >> $output_file
    					contains_unacceptable_letter=true
    					break;
    				fi
    		}
    		if [ $contains_unacceptable_letter = "false" ]; then
    			echo $line >> $output_file
    		fi
    	elif [ "$mode_string" = "remove_bysize"   ]; then   #requires to tr
    		word_after_removing_unneededletters="${line//[$'\a\b\n\f\r\t\v\NNN']}"
    		match_unacceptable_size=false;
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			if [ "${#word_after_removing_unneededletters}" = "${second_pattern_arr[$i]}" ]; then
    				match_unacceptable_size=true;
    				break
    			fi	
    		}
    		if [ $match_unacceptable_size = "false" ]; then
    			echo $line >> $output_file;
    		fi
    	elif [ "$mode_string" = "remove_byindex"   ]; then 
    		word_after_removing_unneededletters="${line//[$'\a\b\n\f\r\t\v\NNN']}"
    		new_line=$line
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			new_line=${new_line/${new_line:${second_pattern_arr[$i]}:1}}
    		}
    		echo $new_line >> $output_file;
    	elif [ "$mode_string" = "replace_by"   ]; then 
    		new_arr_after_replace=""
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ )) {
    			if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    				new_arr_after_replace=${line//${second_pattern_arr[$i]}/${second_input_arr[0]}}
    				if [ $line != $new_arr_after_replace ]; then
    					break;
    				fi
    			else
    				new_arr_after_replace=${line//${second_pattern_arr[$i]}/${second_input_arr[$i]}}
    				if [ $line != $new_arr_after_replace ]; then
    					break;
    				fi
    			fi
    		}
    		echo $new_arr_after_replace >> $output_file;
    	elif [ "$mode_string" = "replace_bysize"   ]; then 
    		word_after_removing_unneededletters="${line//[$'\a\b\n\f\r\t\v\NNN']}"
    		data_inserted=false
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			if [ "${#word_after_removing_unneededletters}" = "${second_pattern_arr[$i]}" ]; then
    				if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    					echo ${second_input_arr[0]} >> $output_file
    					data_inserted=true
    					break;
    				else
    					echo ${second_input_arr[$i]} >> $output_file
    					data_inserted=true
    					break;
    				fi
    			fi	
    		}
    		if [ $data_inserted = "false" ]; then
    			echo $line >> $output_file;
    		fi
    	elif [ "$mode_string" = "replace_byindex" ]; then	
    		word_after_removing_unneededletters="${line//[$'\a\b\n\f\r\t\v\NNN']}"
    		new_line=""
    		for (( i=0 ; i < ${#second_pattern_arr[@]} ; i++ ))  {
    			if [ $replace_all_input_pattarn_by_one_letter = "true" ]; then
    				second_input_arr_element=${second_input_arr[0]}
    				size_of_second_input_arr_element=${#second_input_arr_element[@]}
    				first_index=$((${second_pattern_arr[$i]}))
    				second_index=$((${second_pattern_arr[$i]}+${#second_input_arr[0]}))
    				new_line="${line:0:$first_index}${second_input_arr[0]}${line:$second_index}"
    				echo $new_line >> $output_file
    				break;
    			else
    				second_input_arr_element=${second_input_arr[$i]}
    				size_of_second_input_arr_element=${#second_input_arr_element[@]}
    				first_index=$((${second_pattern_arr[$i]}))
    				second_index=$((${second_pattern_arr[$i]}+${#second_input_arr[$i]}))
    				new_line="${line:0:$first_index}${second_input_arr[$i]}${line:$second_index}"
    				echo $new_line >> $output_file
    			fi
    		}
    	elif [ "$mode_string" = "insert_byA"   ]; then 
    		echo "Not supported yet!"
    		
    	
    	elif [ "$mode_string" = "insert_byB"   ]; then 
    		echo "Not supported yet!"
    		
    	
    	elif [ "$mode_string" = "insert_byindexA"   ]; then 
    		echo "Not supported yet!"
    	
    	
    	elif [ "$mode_string" = "insert_byindexB"   ]; then 
    		echo "Not supported yet!"
    		
    	elif [ "$mode_string" = "prefix"   ]; then 
    		prefix_string=$pattern_string
    		prefix_string+=$line
    		echo $prefix_string >> $output_file;
    	elif [ "$mode_string" = "postfix"   ]; then    
    		postfix_string=""
    		postfix_string=$line
    		postfix_string+=$pattern_string
    		echo $postfix_string >> $output_file;
    	elif [ "$mode_string" = "upper"   ]; then    				#requires tr
    		echo $line | tr '[:lower:]' '[:upper:]' >> $output_file;
    	elif [ "$mode_string" = "lower"   ]; then    				#requires tr
    		echo $line | tr '[:upper:]' '[:lower:]' >> $output_file;
    	elif [ "$mode_string" = "upper_as"   ]; then    			#requires tr
    		echo "Strings are upper_as"
    		upper_value=$(echo $pattern_string | tr '[:lower:]' '[:upper:]')
    		echo $line | tr $pattern_string $upper_value >> $output_file;
    	elif [ "$mode_string" = "lower_as"   ]; then    			#requires tr
    		echo "Strings are lower_as"
    		lower_value=$(echo $pattern_string | tr '[:upper:]' '[:lower:]')
    		echo "pattern_string is $pattern_string"
    		echo "lower_value is $lower_value"
    		echo $line | tr $pattern_string $lower_value >> $output_file
	fi
done < "$input_file_name"

#check if output is embty then notify the user about it!
if [ ! -f "$output_file" ]; then
	echo "No data has been inserted into the output file, your condition finalize to this results!";
	exit 1;
fi
