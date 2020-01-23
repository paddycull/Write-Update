<#
.SYNOPSIS
This function is a used to display updates to the user throughout the script execution. It also allows for optionally logging the update to a file.

.DESCRIPTION
The function displays colorful messages to the output, and logs timestamped messages to a log file if required.

.EXAMPLE
Write-Update "This is a success message" -UpdateType Success -Logfile $Logfile
This will display "SUCCESS: "This is a success message" in green to the user, and add the message with a timestamp to the $Logfile log 

.NOTES
Author: Patrick Cull
Date: 2020-01-20
#>

function Write-Update {
    [Cmdletbinding()]
    param(   
        #Message to output to user and log 
        [Parameter(ValueFromPipeline, Mandatory)]
        [string] $Message,

        #Type of update - effects colour and message prefixes
        [ValidateSet("Info", "Normal", "Success", "Header", "Warning", "Error")]
        [string] $UpdateType="Normal",

        #File to output the messages to.
        [string] $Logfile
    )

    process {
        switch ($UpdateType) {     
            "Info" {
                $Message = "INFO: " + $Message
                Write-Host $Message -ForegroundColor Yellow -BackgroundColor Black
            }
            
            "Normal" {
                Write-Host $Message
            }
            
            "Success" {
                $Message = "SUCCESS: " + $Message
                Write-Host $Message -ForegroundColor Green
            }

            "Warning" {
                $Message = "[WARNING] " + $Message            
                Write-Host $Message -ForegroundColor Yellow
            }
    
            "Error" {
                $Message = "[ERROR] " + $Message
                Write-Host $Message -ForegroundColor Red
            }

            "Header" {
                $Message = $Message.ToUpper()
                $Message = "`r`n`r`n################################################`r`n" + $Message + "`r`n################################################"
                Write-Host $Message
            }
        }
        
        
        #If a logfile is specified with write to that as well and timestamp the messages.
        if ($Logfile) {
            #If the update type is header we don't timestamp it
            if ($UpdateType -eq "Header") {
                $Message | Out-File $LogFile -Append
            }
            else {
                $datetimestamp = Get-Date -UFormat "[%Y-%m-%d %H:%M:%S]"
                $LogString = "$datetimestamp : " + $Message
                $Logstring | Out-File $Logfile -Append
            }
        }
    }
} #end Write-v1Update