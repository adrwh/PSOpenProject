. ./New-OPTask.ps1

#   Create a CSV list with the following column names
#   TaskName,Status,Priority,Department,Description

$Csv = Import-Csv ./CSVListofTasks.csv

$Csv.ForEach{

    New-OPTask -Priority $_.Priority -Description $_.Description -Department $_.Department -TaskName $_.TaskName
    Start-Sleep -Milliseconds 500
}

