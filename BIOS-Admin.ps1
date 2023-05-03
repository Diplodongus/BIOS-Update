# Function to check if the Dell WMI provider is installed
function Check-DellWMIProvider {
    # Query WMI for Dell's sysman namespace
    $dellNamespace = Get-WmiObject -Namespace root\dcim\sysman -Class __NAMESPACE -ErrorAction SilentlyContinue

    # If the Dell namespace is found, return that the WMI provider is installed
    if ($dellNamespace -ne $null) {
        "Dell WMI provider is installed"
    } else {
        "Dell WMI provider is not installed"
    }
}

# Function to check if the HP WMI provider is installed
function Check-HPWMIProvider {
    # Query WMI for HP's hpq namespace
    $hpNamespace = Get-WmiObject -Namespace root\hpq -Class __NAMESPACE -ErrorAction SilentlyContinue

    # If the HP namespace is found, return that the WMI provider is installed
    if ($hpNamespace -ne $null) {
        "HP WMI provider is installed"
    } else {
        "HP WMI provider is not installed"
    }
}

# Function to check the computer vendor and update the BIOS password
function Check-VendorAndUpdateBIOSPassword {
    param(
        [string]$Password
    )

    # Get the computer's manufacturer
    $vendor = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer

    # Call the appropriate function to set the BIOS password based on the manufacturer
    if ($vendor -match "Dell") {
        Set-DellBiosPassword -Password $Password
    } elseif ($vendor -match "HP") {
        Set-HPBiosPassword -Password $Password
    } else {
        "Unsupported vendor: $vendor"
    }
}

# Function to check the computer vendor and output the status of the corresponding WMI provider
function Check-VendorAndWMIProvider {
    # Get the computer's manufacturer
    $vendor = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer

    # Call the appropriate function to check the WMI provider based on the manufacturer
    if ($vendor -match "Dell") {
        Check-DellWMIProvider
    } elseif ($vendor -match "HP") {
        Check-HPWMIProvider
    } else {
        "Unsupported vendor: $vendor"
    }
}

# Function to display the main menu
function Show-Menu {
    param (
        [string]$Title = 'BIOS Management Menu'
    )

    # Clear the console and display the menu title
    Clear-Host
    Write-Host "================ $Title ================"

    # Display the menu options
    Write-Host "1: Check if Dell or HP WMI provider is installed"
    Write-Host "2: Set BIOS password (requires WMI provider)"
    Write-Host "Q: Quit"
}

# Function to set Dell BIOS Password
function Set-DellBiosPassword {
    param(
        [string]$Password
    )
    
    # Attempt to set the BIOS password using Dell's WMI provider
    try {
        $output = (gwmi -Namespace root\dcim\sysman -Class DCIM_BIOSService).SetBIOSSetupPassword($Password)

        # If the ReturnValue is 0, password was set successfully
        if ($output.ReturnValue -eq 0) {
            "Dell BIOS password set successfully"
        } else {
            "Failed to set Dell BIOS password, error code: $($output.ReturnValue)"
        }
    } catch {
        "Failed to set Dell BIOS password: $_"
    }
}

# Function to set HP BIOS Password
function Set-HPBiosPassword {
    param(
        [string]$Password
    )
    
    # Attempt to set the BIOS password using HP's WMI provider
    try {
        $output = (gwmi -Namespace root\hpq -Class HP_BIOSSettingInterface).SetBIOSSetting("Setup Password", "`"$Password`"")

        # If the ReturnValue is 0, password was set successfully
        if ($output.ReturnValue -eq 0) {
            "HP BIOS password set successfully"
        } else {
            "Failed to set HP BIOS password, error code: $($output.ReturnValue)"
        }
    } catch {
        "Failed to set HP BIOS password: $_"
    }
}

# Main loop to display the menu and handle user input
while ($true) {
    Show-Menu
    $input = Read-Host "Please choose an option"

    switch ($input) {
        '1' {
            Check-VendorAndWMIProvider
            Read-Host -Prompt "Press Enter to return to the menu"
        }
        '2' {
            $newBiosPassword = Read-Host "Please enter the desired BIOS password"
            Check-VendorAndUpdateBIOSPassword -Password $newBiosPassword
            Read-Host -Prompt "Press Enter to return to the menu"
        }
        'Q' {
            exit
        }
        default {
            Write-Host "Invalid option, please try again"
            Start-Sleep -Seconds 2
        }
    }
}
