# BIOS Management PowerShell Script

This PowerShell script is designed to help system administrators manage BIOS passwords for Dell and HP computers within their organization. It checks for the presence of the necessary WMI providers, detects the computer vendor, and sets or updates the BIOS password accordingly.

## Features

- Check if the Dell or HP WMI provider is installed
- Set or update the BIOS password for Dell and HP computers

## Usage

1. Open PowerShell as an administrator.
2. Navigate to the folder containing the script.
3. Run the script: `.\bios_management_script.ps1`
4. Follow the on-screen menu options to manage BIOS passwords.

## Requirements

- Windows 10
- PowerShell
- WMI providers for Dell (root\dcim\sysman) or HP (root\hpq)

## Disclaimer

Please use this script at your own risk. The author is not responsible for any damage or loss caused by the use of this script. Always test the script in a safe environment before deploying it in a production environment.
