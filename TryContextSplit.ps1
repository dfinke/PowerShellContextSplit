. .\Invoke-ContextSplit.ps1

Invoke-ContextSplit .\LineTest.txt -Range 13,62,100 -Verbose -Prefix theLines

Invoke-ContextSplit .\book.txt "^(\s+)?Chapter" -Verbose -Prefix chapter

Invoke-ContextSplit .\testLog.txt start,stop -Verbose -Prefix log -Suffix tmp