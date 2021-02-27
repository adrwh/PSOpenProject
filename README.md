# PSOpenProject

A PowerShell function to create OpenProject Tasks in Bulk.

### Use Cases
* Create single OpenProject tasks with a simple command.
* Provide an arracy of task names to create multiple tasks with a single command.
* Loop through a list or CSV of tasks to create tasks in bulk. (see [CSV_Example.ps1](CSV_Example.ps1))


## Install
1. Like anything in Github, either clone it or download the Zip and unblock it (if you're on windows) and then unpack it.
2. Get your OpenProject API key
2. Create a `config.psd1` file in the same directory as the script, based off the example below.

 ```
 @{
    ApiKey = 'xxxxx'
    ProjectID  = 'MyEpicProject'
    Department = "Security"
    ProductionDomain = "https://openproject.hillsong.io"
    DevelopmentDomain = "http://0.0.0.0/Anything"
}
```
4. Done, you're ready to go!


## New-OPTask examples

Add a single task.

`New-OPTask -TaskName "do this"`

Add multiple tasks seperated by comma

`New-OPTask -TaskName "do this","do that"`

### Defaults

New-OPTask will create tasks using your default Department, Priority set to "Normal" and Status set to "Backlog".  You can change this in the config file or on the command line when you execute.
> Please note:  These labels need to match your specific OpenProject environment, adjust accordingly.

Add a task with a RoadBlocked status and Immediate priority

`New-OPTask -Status RoadBlocked -Priority Immediate -TaskName "need to get cyber insurance"`

## Details

New-OPTask is your PowerShell command to create OpenProject tasks using official v3 APIs.  It handles paramters for Priority, /Department/Team, Status, Project etc as well as allows pre-defined defaults that you can set in a config file `Config.psd1` (see above).  You can set your default Project and Department as well as other properties.


## Special thanks
- Thanks to @esesci for the idea of using PSD1 for PowerShell config in his blog here https://link.medium.com/VLH1Vb7k35.
- Thanks to kennethreitz/httpbin for the docker API testing ground.

## Channge log

May 2020
- initial commit May 2020
- added PowerShell script to add OpenProject Tasks in Bulk
- added PowerShell cmdlet to add comma-seperated OpenProject Tasks at the command line.

Feb 2021
- Add params, defaults, prepared for distribution readiness

