function New-PSOPTask {
    param ($list)

    # OpenProject API Key stored in confid data file
    $config = Import-PowerShellDataFile -Path config.psd1

    # Create base64 encoded api authentication credentials
    $cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f 'apikey', $config.key)))

    # Create the Invoke-RestMethod request headers
    $headers = @{Authorization = "Basic $cred" }

    # Loop through and create each task
    $list.split(",") | ForEach-Object {

        Write-Verbose -Verbose $_

        # This is the request body to POST
        $body = @{
            subject = $_
            _links  = @{
                type         = @{href = "/api/v3/types/1" } # Match the task type (Task, Milestone, Bug, etc, with your own requirement)
                status       = @{href = "/api/v3/statuses/1" } # Match the status (Backlog, Roadblocked, InProgress, Stalled, etc with your own requirement)
                priority     = @{href = "/api/v3/priorities/8" } # Match the priority (High, Medium, Low, etc, with your own requirement)
                customField2 = @{href = "/api/v3/custom_options/5" } # If you want to include custom fields, otherwise comment this line out.
            }
        } | ConvertTo-Json  # The OpenProject API expects JSON, so convert the object to JSON

        # Testing endpoint
        #$Uri = "http://localhost/anything"

        # The project specific Work_Packages endpoint.
        $Uri = "$($config.opProdHost)/api/v3/projects/$($config.projectId)/work_packages/"

        try {
            Invoke-RestMethod -Uri $Uri -Headers $headers -ContentType 'application/json' -Method Post -Body $body
        }
        catch {
            $_
        }

        # Give the API a breather for large lists
        Start-Sleep -Milliseconds 200

    }
}