Get-Content -Raw -Path .\unique-artwork* -Filter *.json | ConvertFrom-Json | Where-Object {$_.Name -in "Forest","Plains","Island","Swamp","Mountain"} | ConvertTo-Json | Out-File ".\basicLandsUniqueArt.json"
$cards = Get-Content -Raw -Path basicLandsUniqueArt.json | ConvertFrom-Json
Import-Csv ".\Artists.csv" | ForEach-Object {
    foreach ($land in $cards) {
        if ($_.Artist -eq $land.artist) {
            if ($land.Name -eq "Forest") {
                $_.Green = 1
            }
            if ($land.Name -eq "Plains") {
                $_.White = 1
            }
            if ($land.Name -eq "Island") {
                $_.Blue = 1
            }
            if ($land.Name -eq "Swamp") {
                $_.Black = 1
            }
            if ($land.Name -eq "Mountain") {
                $_.Red = 1
            }
        }
    }
    $_
} | ConvertTo-Json | Out-File ".\ArtistsWithBasicLandColours.json"

$Artists = Import-Csv ".\Artists.csv" | ForEach-Object { $_.Artist }

Get-Content -Raw -Path .\unique-artwork* -Filter *.json  | ConvertFrom-Json | Where-Object { $_.type_line -like "Legendary Creature*" -and $_.artist -in $Artists } | Select-Object -Property name, artist, color_identity | ConvertTo-Json | Out-File ".\LegendaryCreaturesArtist.json"

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

$cards = Get-Content -Raw -Path .\unique-artwork* -Filter *.json  | ConvertFrom-Json | Where-Object {$_.legalities.commander -eq "legal"}
Import-Csv ".\Artists.csv" | ForEach-Object {
    foreach ($card in $cards) {
        if ($_.Artist -eq $card.artist) {
            if ($card.color_identity -contains "G") {
                $_.Green = [int]$_.Green + 1
            }
            if ($card.color_identity -contains "W") {
                $_.White = [int]$_.White + 1
            }
            if ($card.color_identity -contains "U") {
                $_.Blue = [int]$_.Blue+1
            }
            if ($card.color_identity -contains "B") {
                $_.Black = [int]$_.Black+1
            }
            if ($card.color_identity -contains "R") {
                $_.Red = [int]$_.Red+1
            }
        }
    }
    $_
} | ConvertTo-Json | Out-File ".\ArtistsColourCardCount.json"

$Artists = Get-Content -Raw -Path ArtistsColourCardCount.json | ConvertFrom-Json
Get-Content -Raw -Path LegendaryCreaturesArtistHasBasic.json | ConvertFrom-Json | ForEach-Object {
    foreach ($x in $Artists) {
        if ($x.Artist -eq $_.artist) {
            $ToReturn = 0
            if ($_.color_identity -contains "G") {
                $ToReturn += $x.Green
            }
            if ($_.color_identity -contains "W") {
                $ToReturn += $x.White
            }
            if ($_.color_identity -contains "U") {
                $ToReturn += $x.Blue
            }
            if ($_.color_identity -contains "R") {
                $ToReturn += $x.Red
            }
            if ($_.color_identity -contains "B") {
                $ToReturn += $x.Black
            }
            $_ | Add-Member -MemberType NoteProperty -Name CardsInColour -Value $ToReturn -PassThru
        }
    }
}| Sort-Object -Property CardsInColour -Descending | ConvertTo-Json | Out-File ".\LegendaryCreaturesArtistPlayableCount.json"