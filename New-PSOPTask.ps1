function New-PSOPTask {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$TaskName,
        [Parameter()]
        [ValidateSet("Backlog", "Parked", "RoadBlocked", "InProgress")]
        [String]$Status = "Backlog",
        [Parameter()]
        [ValidateSet("Immediate", "High", "Normal", "Low")]
        [String]$Priority = "Normal",
        [Parameter()]
        [ValidateSet("Service Desk", "Infrastructure", "Network Operations", "Event Operations", "Security")]
        [String]$Department,
        [Parameter()]
        [String]$Description

    )

    begin {

        # OpenProject API Key stored in confid data file
        $config = Import-PowerShellDataFile -Path config.psd1

        # Create base64 encoded api authentication credentials
        $cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f 'apikey', $config.key)))

        # Create the Invoke-RestMethod request headers
        $headers = @{"Authorization" = "Basic $cred";"Content-Type" = 'application/json'}

        # Param switches
        $StatusSwitch = 0
        switch ($Status) {
            "Backlog" { $StatusSwitch = 1; Break }
            "Parked" { $StatusSwitch = 15; Break }
            "RoadBlocked" { $StatusSwitch = 16; Break }
            "InProgress" { $StatusSwitch = 7; Break }
            Default { $StatusSwitch = 1 }
        }
        $DepartmentSwitch = 0
        switch ($Department) {
            "Service Desk" { $DepartmentSwitch = 1; Break }
            "Infrastructure" { $DepartmentSwitch = 2; Break }
            "Network Operations" { $DepartmentSwitch = 3; Break }
            "Security" { $DepartmentSwitch = 4; Break }
            Default {}
        }
        $PrioritySwitch = 0
        switch ($Priority) {
            "Low" { $PrioritySwitch = 7; Break }
            "Normal" { $PrioritySwitch = 8; Break }
            "High" { $PrioritySwitch = 9; Break }
            "Immediate" { $PrioritySwitch = 10; Break }
            Default { $PrioritySwitch = 8 }
        }

    }
    process {

        # This is the request body to POST
        $body = @{
            subject = $TaskName.trim() # Clean up the task name
            description = @{
                raw = $Description
            }
            _links  = @{
                type         = @{href = "/api/v3/types/1" } # Match the task type (Task, Milestone, Bug, etc, with your own requirement)
                status       = @{href = "/api/v3/statuses/$StatusSwitch" } # Match the status (Backlog, Roadblocked, InProgress, Stalled, etc with your own requirement)
                priority     = @{href = "/api/v3/priorities/$PrioritySwitch" } # Match the priority (High, Medium, Low, etc, with your own requirement)
                customField2 = @{href = "/api/v3/custom_options/$DepartmentSwitch" } # If you want to include custom fields, otherwise comment this line out.
                customField9 = @{href = "/api/v3/custom_options/116" } # If you want to include custom fields, otherwise comment this line out.
            }
        } | ConvertTo-Json -Compress # The OpenProject API expects JSON, so convert the object to JSON

        # Test endpoint using httpbin.org container
        #$Uri = "http://localhost/anything"

        # The project specific Work_Packages endpoint.
        $Uri = -join ($config.opProdHost, "/api/v3/projects/", $config.projectId, "/work_packages/")
        
        # Splat the payload
        $payload = @{
            Uri = $Uri
            Headers = $headers
            Method = "Post"
            Body = $body
            Verbose = $false
        }
        try {
            Invoke-RestMethod @payload
            Write-Verbose "Added $TaskName"
        }
        catch {
            $_
        }
    }
}
