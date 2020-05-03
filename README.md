# PSOpenProject

A PowerShell script to create OpenProject Tasks in Bulk.

- Thanks to @esesci for the idea of using PSD1 for PowerShell config in his blog here https://link.medium.com/VLH1Vb7k35.
- Thanks to kennethreitz/httpbin for the docker API testing ground.

## Instructions

### New-PSOPTask

Add a single task.

`New-PSOPTask -list "do this"`

Add multiple tasks seperated by comma

`New-PSOPTask -list "do this","do that"`

## Channge log

- initial commit May 2020
- added PowerShell script to add OpenProject Tasks in Bulk
- added PowerShell cmdlet to add comma-seperated OpenProject Tasks at the command line.
