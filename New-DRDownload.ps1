function New-DRDownload
{
    [CmdletBinding()]
    param
    (
        
    )
    
    begin
    {
        ## Location of the script
        $ScriptLocation = '' | Set-Location
        
        ## Location for downloaded files
        $MediaDestination = ''
    }
    
    process
    {
        ## Location of media to be downloaded.
        $DownloadURLs = Get-Content -Path 'Media.csv'
        foreach ($DownloadURL in $DownloadURLs)
        {
            .\youtube-dl.exe --update --ffmpeg-location ffmpeg.exe --prefer-ffmpeg $DownloadURL

            ## Remove downloaded media from the CSV file.
            $DownloadURLs | Where-Object {$PSItem -ne $DownloadURL} | Out-File 'Media.csv'
            
            ## Move downloaded media to final destination.
            $MoveScriptBlock = [ScriptBlock]::Create((Get-ChildItem $ScriptLocation -Filter "*.mp4" | Move-Item -Destination $MediaDestination))
            Start-Job -Name 'MoveDRDownloads' -ScriptBlock $MoveScriptBlock
        }
    }
    
    end
    {
        Write-Output 'Done with this round of downloads!'
    }
}