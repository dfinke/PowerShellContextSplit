PowerShell Invoke-ContextSplit
=
Based on the [UNIX csplit](http://publib.boulder.ibm.com/infocenter/pseries/v5r3/index.jsp?topic=/com.ibm.aix.cmds/doc/aixcmds1/csplit.htm) command

The Invoke-ContextSplit command copies the specified file and separates the copy into segments.
The original input file, which remains unaltered, must be a text file.

The Invoke-ContextSplit command writes the segments to files xx00 . . . xxN.

* The Pattern can be an array of regular expressions `Invoke-ContextSplit .\book.txt '^(\s+)?Chapter'`
* The Range can be an array of numbers `Invoke-ContextSplit .\LineTest.txt -Range 13,62,100`


![image](https://raw.github.com/dfinke/PowerShellContextSplit/master/HowTo.gif)