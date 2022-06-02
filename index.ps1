$disk_free = Get-PSDrive C | ForEach-Object {$_.Free /1GB}
$disk_used = Get-PSDrive C | ForEach-Object {$_.Used /1GB}

$str_total_memory = "Total Physical Memory"
$str_available_memory = "Available Physical Memory"

function Get-Memory {
    param($param) 
        $var_temp = (SystemInfo | Select-String $param).ToString().Split(":")[1]
        $var_temp = $var_temp -replace (" ","")
        $var_temp = $var_temp -replace (",","")
        $var_temp = $var_temp -replace ("MB","")
        return $var_temp
    }

function Get-Porcent {
        $total_memory = Get-Memory $str_total_memory 
        $available_memory = Get-Memory $str_available_memory
        $total_memory = $total_memory -as [int]
        $available_memory = $available_memory -as [int]
        $porcent_occupid = [math]::Round(((1 - ($available_memory/$total_memory)) * 100),2)
        return $porcent_occupid
}

function Get-Data {
        $value_porcent_occupid = Get-Porcent
        $data = @{
            "%memory" = $value_porcent_occupid
            "disk_used" = $disk_used
            "disk_free" = $disk_free
        }
        return $data
}
function Get-Main {
    Get-Data
}

Get-Main