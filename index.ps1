$disk_free = Get-PSDrive C | ForEach-Object {$_.Free /1GB}
$disk_used = Get-PSDrive C | ForEach-Object {$_.Used /1GB}

$str_total_memory = "Total Physical Memory"
$str_available_memory = "Available Physical Memory"

$URL_POST = "http://127.0.0.1:5000/monitor-win"
$headers = @{
    "Content-type" = "application/json"
}


function Get-Memory {
    param($param) 
        $var_temp = (SystemInfo | Select-String $param).ToString().Split(":")[1]
        $var_temp = $var_temp -replace (" ","")
        $var_temp = $var_temp -replace (",","")
        $var_temp = $var_temp -replace ("MB","")
        return $var_temp
    }

function Get-Porcent-Memory {
    $total_memory     = Get-Memory $str_total_memory 
    $available_memory = Get-Memory $str_available_memory
    $total_memory     = $total_memory -as [int]
    $available_memory = $available_memory -as [int]
    $porcent_occupid  = (1 - ($available_memory/$total_memory)) * 100
    return $porcent_occupid
}
function Get-Porcent-Disk {
    $disk_free       = $disk_free -as [int] 
    $dis_used        = $disk_used -as [int]
    $total_disk      = $disk_free + $dis_used
    $porcent_occupid = (1 - ($disk_used)/$total_disk) * 100
    return $porcent_occupid
}
function Get-Data {
        $value_porcent_occupid_memory = Get-Porcent-Memory
        $value_porcent_occupid_disk = Get-Porcent-Disk
        $data = @{
            "%memory"   = $value_porcent_occupid_memory
            "disk_used" = $disk_used
            "disk_free" = $disk_free
            "%disk"     = $value_porcent_occupid_disk
        }
        return $data
}

function Post-Data {
    param($body, $headers, $url) 
    $response = Invoke-RestMethod -Method 'Post' -Uri $url -Body ($body|ConvertTo-Json) -Headers $headers
    return $response
}
function Get-Main {
    $data = Get-Data
    $req_json = Post-Data $data $headers $URL_POST
    Write-Host $req_json
}

Get-Main