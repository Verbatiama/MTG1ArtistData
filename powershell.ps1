# Get-Content -Raw -Path unique-artwork-20231108220413.json | ConvertFrom-Json | Where-Object {$_.Name -in "Forest","Plains","Island","Swamp","Mountain"} | ConvertTo-Json | Out-File ".\basicLandsUniqueArt.json"
#$cards = Get-Content -Raw -Path basicLandsUniqueArt.json | ConvertFrom-Json
#Import-Csv ".\Artists.csv" | ForEach-Object {
#    foreach ($land in $cards) {
#        if ($_.Artist -eq $land.artist) {
#            if ($land.Name -eq "Forest") {
#                $_.Green = 1
#            }
#            if ($land.Name -eq "Plains") {
#                $_.White = 1
#            }
#            if ($land.Name -eq "Island") {
#                $_.Blue = 1
#            }
#            if ($land.Name -eq "Swamp") {
#                $_.Black = 1
#            }
#            if ($land.Name -eq "Mountain") {
#                $_.Red = 1
#            }
#        }
#    }
#    $_
#} | ConvertTo-Json | Out-File ".\ArtistsWithBasicLandColours.json"

#$Artists = Import-Csv ".\Artists.csv" | ForEach-Object { $_.Artist }
#
#Get-Content -Raw -Path unique-artwork-20231108220413.json | ConvertFrom-Json | Where-Object { $_.type_line -like "Legendary Creature*" -and $_.artist -in $Artists } | Select-Object -Property name, artist, color_identity | ConvertTo-Json | Out-File ".\LegendaryCreaturesArtist.json"

$Artists = Get-Content -Raw -Path ArtistsWithBasicLandColours.json | ConvertFrom-Json
Get-Content -Raw -Path LegendaryCreaturesArtist.json | ConvertFrom-Json | ForEach-Object {
    foreach ($x in $Artists) {
        if ($x.Artist -eq $_.artist) {
            $ToReturn = $true
            if ($_.color_identity -contains "G" -and $x.Green -ne 1) {
                $ToReturn = $false
            }
            if ($_.color_identity -contains "W" -and $x.White -ne 1) {
                $ToReturn = $false
            }
            if ($_.color_identity -contains "U" -and $x.Blue -ne 1) {
                $ToReturn = $false
            }
            if ($_.color_identity -contains "R" -and $x.Red -ne 1) {
                $ToReturn = $false
            }
            if ($_.color_identity -contains "B" -and $x.Black -ne 1) {
                $ToReturn = $false
            }
            if($ToReturn){
                $_
            }
        }
    }
} | ConvertTo-Json | Out-File ".\LegendaryCreaturesArtistHasBasic.json"