$a = Get-Location
$b=""
foreach ($f in $(Get-ChildItem -Path $a -Directory)) {
    $c = (Get-ChildItem -Path $f.FullName -Directory -Recurse | Sort-Object { $_.FullName.Split('\').Count } -Descending)[0]
    $d = ($c.Fullname.Split("\")[$a.Path.split('\').Count..$($c.Fullname.Split("\").Length - 1)] -join '\')
    $b += $d.Substring(6).replace("-","").replace("\","")
    }
$e = [regex]::Matches($b, '..') | % { [Convert]::ToByte($_.Value, 16) }
$g = "$($a.Path)\decoded_output.txt"
Set-Content -Path $g -Value $e -Encoding Byte 
