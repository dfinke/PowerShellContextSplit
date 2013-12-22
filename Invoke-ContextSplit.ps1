function Invoke-ContextSplit { 
    <#
        .Synopsis
            The Invoke-ContextSplit command copies the specified file and separates the copy into segments.
            The original input file, which remains unaltered, must be a text file.
        .Description
            The Invoke-ContextSplit command writes the segments to files xx00 . . . xxN.
            The Pattern can be an array of regular expressions
            The Range can be an array of numbers Invoke-ContextSplit .\LineTest.txt -Range 13,62,100

            
        .Example
        Invoke-ContextSplit .\testLog.txt start
        
        Reads testLog.txt and creates a file that contains the segment from the current line up to, but not including, 
        the line containing the specified pattern. The line containing the pattern becomes the current line.
            
        .Example
        Invoke-ContextSplit .\testLog.txt start,stop -Verbose -Prefix log
        Sames as the previous example. This matches on two patterns, `start` and `stop`

        .Example
        Invoke-ContextSplit .\testLog.txt start,stop -Verbose -Prefix log
        Sames as the previous example, the filenames generated are log00.txt ... logNN.txt

        .Example
        Invoke-ContextSplit .\LineTest.txt -Range 11,72,98
        Creates four files: 
            the xx00 file contains lines 1-10
            the xx01 file contains lines 11-71 
            the xx02 file contains lines 72-97
            the xx03 file would contain lines 98 to the end if the file
    #>

    [CmdletBinding()] 
    param( 
        [string]$FileName,
        [string[]]$Pattern,
        [int[]]$Range,
        [string]$Prefix = "xx",
        [string]$Suffix = "txt"
    ) 
  
    $FileName = Resolve-Path $FileName

    $Script:OutputFileName = $Null
    $Script:FileCount = 0 

    function Write-ContextSplitMessage {
        Write-Verbose ("{1} [{0,5}] " -f (ls $Script:OutputFileName).Length, $Script:OutputFileName) 
    }

    function Get-Range {

        param(
            [int[]]$TargetLines
        )

        function New-Range {
            param($StartLine,$EndLine)

            [PSCustomObject]@{StartLine=$StartLine;EndLine=$EndLine}
        }

        $StartLine=1
        for($idx=0; $idx -lt $TargetLines.Count; $idx+=1) {        
        
            $EndLine=$TargetLines[$idx]-1
            New-Range $StartLine $EndLine
            $StartLine=$TargetLines[$idx]
        }
    
        New-Range $StartLine ([int]::MaxValue)
    }

    function Set-NextFile {        

        if($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent) {
            if($Script:OutputFileName -and (Test-Path $Script:OutputFileName)) {
                Write-ContextSplitMessage
            }
        } 

        $Script:OutputFileName  = (Join-Path $pwd ("{0}{1:D2}.{2}" -f $Prefix, $Script:FileCount, $Suffix)) 
    
        if(Test-Path $Script:OutputFileName) { Clear-Content -Path $Script:OutputFileName } 

        $Script:FileCount += 1 
    } 

    function Set-ContextContent ($line) { $line | Add-Content $Script:OutputFileName } 

    if($pattern) {
        $patterns = $Pattern -join "|" 
    
        Set-NextFile 
  
        switch -Regex ( [System.IO.File]::ReadAllLines($FileName) ) {
            $patterns { Set-NextFile; Set-ContextContent $_ } 
            default   { Set-ContextContent $_ } 
        } 

        Write-ContextSplitMessage        
    }

    if($Range) {
        $TheRange = Get-Range $Range
        
        Set-NextFile

        $lineCount = 0
        foreach($line in [System.IO.File]::ReadAllLines($FileName)) {
                 
            Set-ContextContent $line
            $lineCount+=1            
        
            if($lineCount -eq $TheRange[$Script:FileCount-1].EndLine) {
                Set-NextFile
            }
        }

        Write-ContextSplitMessage
    }
}