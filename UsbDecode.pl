#!/usr/bin/perl

$pcap = @ARGV[0];

@result = ();


unless (-e $pcap){ #if the file does not exist give the user an error 

print("File not found. Please try again.\n");
print("Example use:\n perl UsbDecode.pl capture.pcap\n");
exit;

}


%lower_case = ( "04" => "a", #table for lowercase keyboard 
                "05" => "b",
                "06" => "c", 
                "07" => "d",
                "08" => "e",
                "09" => "f",
                "0a" => "g",
                "0b" => "h",
                "0c" => "i",
                "0d" => "j",
                "0e" => "k",
                "0f" => "l",
                "10" => "m",
                "11" => "n",
                "12" => "o",
                "13" => "p",
                "14" => "q",
                "15" => "r",
                "16" => "s",
                "17" => "t",
                "18" => "u",
                "19" => "v",
                "1a" => "w",
                "1b" => "x",
                "1c" => "y",
                "1d" => "z",
                "1c" => "y",
                "1d" => "z",
                "1e" => "1",
                "1f" => "2",
                "20" => "3",
                "21" => "4",
                "22" => "5",
                "23" => "6",
                "24" => "7",
                "25" => "8",
                "26" => "9",
                "27" => "0",
                "28" => "<RET>",
                "29" => "<ESC>",
                "2a" => "<DEL>",
                "2c" => " ", #space
                "2d" => "-",
		"2e" => "=",
		"2f" => "[",
                "30" => "]",
		"31" => "\\",
		"32" => "<NON>",
		"33" => ":",
		"34" => "'",
		"35" => "<GA>",
		"36" => ",",
                "37" => ".",
		"38" => "/",
		"39" => "<CAP>",
		"3a" => "<F1>",
		"3b" => "<F2>",
		"3c" => "<F3>",
		"3d" => "<F4>",
		"3e" => "<F5>",
		"3f" => "<F6>",
		"40" => "<F7>",
		"41" => "<F8>",
		"42" => "<F9>",
		"43" => "<F10>",
		"44" => "<F11>",
		"45" => "<F12>"
                ) ;

%upper_case = ( "04" => "A", #table for upper case keyboard 
                "05" => "B",
                "06" => "C",
                "07" => "D",
                "08" => "E",
                "09" => "F",
                "0a" => "G",
                "0b" => "H",
                "0c" => "I",
                "0d" => "J",
                "0e" => "K",
                "0f" => "L",
                "10" => "M",
                "11" => "N",
                "12" => "O",
                "13" => "P",
                "14" => "Q",
                "15" => "R",
                "16" => "S",
                "17" => "T",
                "18" => "U",
                "19" => "V",
                "1a" => "W",
                "1b" => "X",
                "1c" => "Y",
                "1d" => "Z",
                "1c" => "Y",
                "1d" => "Z",
                "1e" => "!",
                "1f" => "@",
                "20" => "\$",
                "21" => "4",
                "22" => "%",
                "23" => "^",
                "24" => "&",
                "25" => "*",
                "26" => "(",
                "27" => ")",
                "28" => "<RET>",
                "29" => "<ESC>",
                "2a" => "<DEL>",
                "2c" => " ", #space
                "2f" => "{",
                "30" => "}",
		"31" => "|",
		"32" => "<NON>",
		"33" => "\"",
		"34" => ":",
		"35" => "<GA>",
		"36" => "<",
		"37" => ">",
		"38" => "?",
		"39" => "<CAP>",
		"3a" => "<F1>",
		"3b" => "<F2>",
		"3c" => "<F3>",
		"3d" => "<F4>",
		"3e" => "<F5>",
		"3f" => "<F6>",
		"40" => "<F7>",
		"41" => "<F8>",
		"42" => "<F9>",
		"43" => "<F10>",
		"44" => "<F11>",
		"45" => "<F12>",
                "2d" => "_" 
                ) ;


@usb = `tshark -r $pcap -T fields -e usb.capdata 'usb.data_len == 8'`; # Runs the tshark command to get the keyboard keys and saves it to an array

foreach(@usb){
        if(/^02[0-9]{2}(?!00)([0-9a-z]{2})[0-9]+/gm){ #If the key starts with 02 add it to the upercase array
         $find_upper = $upper_case{$1};
        push @result, $find_upper ;
        }
        elsif(/^[0-9]{4}([2a]{2})[0-9]+/gm){ #If the DEL key was pressed then remove the last letter 

                pop @result;
        }
        elsif(/^[0-9]{4}(?!00)([0-9a-z]{2})[0-9]+/gm){ #If it's a lowercase key add it to the result array 
                $test = $lower_case{$1};
                push @result, $test;
        }
}

print(@result, "\n");
