PowerShell Invoke-ContextSplit
=
Based on the [UNIX csplit](http://publib.boulder.ibm.com/infocenter/pseries/v5r3/index.jsp?topic=/com.ibm.aix.cmds/doc/aixcmds1/csplit.htm) command

The Invoke-ContextSplit command copies the specified file and separates the copy into segments.
The original input file, which remains unaltered, must be a text file.

The Invoke-ContextSplit command writes the segments to files xx00 . . . xxN.

* The Pattern can be an array of regular expressions `Invoke-ContextSplit .\book.txt '^(\s+)?Chapter'`
* The Range can be an array of numbers `Invoke-ContextSplit .\LineTest.txt -Range 13,62,100`


![image](https://raw.github.com/dfinke/PowerShellContextSplit/master/HowTo.gif)

What if
-
You had a log like this and wanted to create separate files each time you saw the words `start`?

	1291126929200 started 88 videolist15.txt 4 Good 4
	1291126929250 59.875 29.0 29.580243595150186 43.016096916037604
	1291126929296 59.921 29.0 29.52749417740926 42.78632483544682
	1291126929359 59.984 29.0 29.479540161281143 42.56031951027556
	1291126929437 60.046 50.0 31.345036510255586 42.682281485516945
	1291126932859 started 88 videolist15.txt 5 Good 4
	1291126932900 stopped

### No problem

	Invoke-ContextSplit .\testLog.txt start

This creates two files xx01.txt and xx02.txt

### xx01.txt
	1291126929200 started 88 videolist15.txt 4 Good 4
	1291126929250 59.875 29.0 29.580243595150186 43.016096916037604
	1291126929296 59.921 29.0 29.52749417740926 42.78632483544682
	1291126929359 59.984 29.0 29.479540161281143 42.56031951027556
	1291126929437 60.046 50.0 31.345036510255586 42.682281485516945

### xx02.txt
	1291126932859 started 88 videolist15.txt 5 Good 4
	1291126932900 stopped

But Wait, there's more
-
You want to split out a separate file each time `start` or `stop ` is found. Plus, you don't like the prefix `xx` for each file or `txt` as the extension. Also, you don't want to guess at how many files are created.

### No Problem

`Invoke-ContextSplit` allows multiple patterns to be searched for and control of the file name generated. Using PowerShell's `Verbose` switch gives feedback.  

	Invoke-ContextSplit .\testLog.txt start,stop -Prefix log -Suffix tmp -Verbose

Here is the output. The name and size of the file.

	VERBOSE: C:\PoSh\Invoke-ContextSplit\log01.tmp [  308]
	VERBOSE: C:\PoSh\Invoke-ContextSplit\log02.tmp [   51]
	VERBOSE: C:\PoSh\Invoke-ContextSplit\log03.tmp [   23]

What Else can Invoke-ContextSplit Do?
-

More to come...