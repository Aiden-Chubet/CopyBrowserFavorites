# Prompt for the remote PC name and username
$remotePC = Read-Host -Prompt "Enter the remote PC name"
$username = Read-Host -Prompt "Enter the username"

# Define the paths to the bookmarks files on the remote PC
$remoteEdgeBookmarksPath = "\\$remotePC\C$\Users\$username\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
$remoteChromeBookmarksPath = "\\$remotePC\C$\Users\$username\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"

# Define the paths to the bookmarks files on the local PC
$localEdgeBookmarksPath = "C:\Users\$username\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
$localChromeBookmarksPath = "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"

# Function to copy bookmarks file with error handling
function Copy-BookmarksFile {
    param ($remotePath, $localPath)

    try {
        # Check if the bookmarks file exists on the remote PC
        if (Test-Path -Path $remotePath) {
            Write-Output "Bookmarks file found on remote PC at: $remotePath"

            # Create the directory on the local PC if it doesn't exist
            $localDir = Split-Path -Path $localPath -Parent
            if (-not (Test-Path -Path $localDir)) {
                New-Item -ItemType Directory -Path $localDir -Force
            }

            # Copy the bookmarks file from the remote PC to the local PC
            Copy-Item -Path $remotePath -Destination $localPath -Force

            Write-Output "Bookmarks file has been copied to: $localPath"
        } else {
            Write-Output "No bookmarks file found on remote PC at: $remotePath"
        }
    } catch {
        if ($_.Exception.Message -match "The network path was not found") {
            Write-Output "The computer $remotePC is off or unreachable."
        } else {
            Write-Output "An error occurred: $($_.Exception.Message)"
        }
    }
}

# Copy Edge bookmarks
Copy-BookmarksFile -remotePath $remoteEdgeBookmarksPath -localPath $localEdgeBookmarksPath

# Copy Chrome bookmarks
Copy-BookmarksFile -remotePath $remoteChromeBookmarksPath -localPath $localChromeBookmarksPath
