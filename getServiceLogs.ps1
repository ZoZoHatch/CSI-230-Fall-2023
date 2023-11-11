# Storyline: List all services in the system and show all, stopped, or running

function select_service() {

    cls      

    $arrValidInput = @('all', 'stopped', 'running')

    $readInput = Read-Host -Prompt "Please spcify if you want to see 'all', 'running', or 'stopped' services, or 'quit' to quit"

    
    # Check if the user wants to quit.
    if ($readInput -imatch "quit") {

        # Stop executing the program and close the script
        break

    } # end if

    # Check if the user entered a valid option
    if (-not $readInput -iin $arrValidInput) {

        Write-Host -BackgroundColor Red -ForegroundColor White "Please enter a vaid option."
        sleep 2

        # Return to option input after a short delay
        select_service

    } # end if

    # send input to show_service
    show_service -userSelection $readInput


} # end function select_services


function show_service() {
    
    Param([string]$userSelection)

    if($userSelection -imatch $arrValidInput[0]) {
        
        Write-Host -BackgroundColor Green -ForegroundColor White "Showing " $arrValidInput[0] " services"
        sleep 2

        Get-Service

    } elseif($userSelection -imatch $arrValidInput[1]) { 

        Write-Host -BackgroundColor Green -ForegroundColor White "Showing " $arrValidInput[1] " services"
        sleep 2

        Get-Service | Where { $_.Status -eq "Stopped" }

    } elseif($userSelection -imatch $arrValidInput[2]) {

        Write-Host -BackgroundColor Green -ForegroundColor White "Showing "  $arrValidInput[2] " services"
        sleep 2

        Get-Service | Where { $_.Status -eq "Running" }

    } # end if

     # Pause the screen and wait until the user is ready to proceed
    Read-Host -Prompt "Press enter when you are done"

    # Go back to select_log
    select_service

} # end function show_service

select_service


