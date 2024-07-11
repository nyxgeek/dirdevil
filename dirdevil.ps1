# dirdevil - PowerShell to hide data in directory structures, proof of concept
# @2024 nyxgeek - TrustedSec



#move into our OUTPUT directory
#cd C:\Users\trustedsec\Desktop\DIRDEVIL_V4\OUTPUT

# this is placeholder data. in reality, we will read a byte stream from a file.

$example_data = @'
        Another one got caught today, it's all over the papers.  "Teenager
Arrested in Computer Crime Scandal", "Hacker Arrested after Bank Tampering"...
        Damn kids.  They're all alike.

        But did you, in your three-piece psychology and 1950's technobrain,
ever take a look behind the eyes of the hacker?  Did you ever wonder what
made him tick, what forces shaped him, what may have molded him?
        I am a hacker, enter my world...
        Mine is a world that begins with school... I'm smarter than most of
the other kids, this crap they teach us bores me...
        Damn underachiever.  They're all alike.

        I'm in junior high or high school.  I've listened to teachers explain
for the fifteenth time how to reduce a fraction.  I understand it.  "No, Ms.
Smith, I didn't show my work.  I did it in my head..."
        Damn kid.  Probably copied it.  They're all alike.

        I made a discovery today.  I found a computer.  Wait a second, this is
cool.  It does what I want it to.  If it makes a mistake, it's because I
screwed it up.  Not because it doesn't like me...
                Or feels threatened by me...
                Or thinks I'm a smart ass...
                Or doesn't like teaching and shouldn't be here...
        Damn kid.  All he does is play games.  They're all alike.

        And then it happened... a door opened to a world... rushing through
the phone line like heroin through an addict's veins, an electronic pulse is
sent out, a refuge from the day-to-day incompetencies is sought... a board is
found.
        "This is it... this is where I belong..."
        I know everyone here... even if I've never met them, never talked to
them, may never hear from them again... I know you all...
        Damn kid.  Tying up the phone line again.  They're all alike...

        You bet your ass we're all alike... we've been spoon-fed baby food at
school when we hungered for steak... the bits of meat that you did let slip
through were pre-chewed and tasteless.  We've been dominated by sadists, or
ignored by the apathetic.  The few that had somexthing to teach found us will-
ing pupils, but those few are like drops of water in the desert.

        This is our world now... the world of the electron and the switch, the
beauty of the baud.  We make use of a service already existing without paying
for what could be dirt-cheap if it wasn't run by profiteering gluttons, and
you call us criminals.  We explore... and you call us criminals.  We seek
after knowledge... and you call us criminals.  We exist without skin color,
without nationality, without religious bias... and you call us criminals.
You build atomic bombs, you wage wars, you murder, cheat, and lie to us
and try to make us believe it's for our own good, yet we're the criminals.

        Yes, I am a criminal.  My crime is that of curiosity.  My crime is
that of judging people by what they say and think, not what they look like.
My crime is that of outsmarting you, something that you will never forgive me
for.

        I am a hacker, and this is my manifesto.  You may stop this individual,
but you can't stop us all... after all, we're all alike.

                               +++The Mentor+++

'@


##### ENCODING

function encodeFile {

    ## FOR TESTING We ARE HARDCODING IN EITHER STRING READ OR FILE READ FOR NOW


    #### THIS FIRST PART IS USING $example_data BLOCK ABOVE
    # Convert the string to a byte array
    $data_bytes = [System.Text.Encoding]::UTF8.GetBytes($example_data)
    # Convert each byte to its hexadecimal representation
    $hexString = ($data_bytes | ForEach-Object { $_.ToString("X2") }) -join ''

    <#

    # FILE READ
    $filePath = "C:\Users\trustedsec\Downloads\putty.exe"
    $bytes = Get-Content -Path $filePath -Encoding Byte
    $hexString = ($bytes | ForEach-Object { $_.ToString("X2") }) -join ""

    # Output the hexadecimal string
    $hexString
    echo "Read file $($filepath). Hex string length is: $($hexString.Length) chars"
    #>


    # Get the current directory
    $currentDirectory = Get-Location
    echo "We are located in: $currentDirectory"

    # Count the number of characters in the path
    $charCount = $currentDirectory.Path.Length

    # Output the character count
    echo "Our current path length is: $charCount"

    # now figure out how many top-level folders we need: 32 * 6 = 192.. But 6 are for index, so 186 chars. Then we have 4 dashes per section, so 24 chars of dashes to account for
    # so we end up with 186 chunks per top-level folder structure. However, adding in the +24 for dashes = 210. Leaving only 50 chars for path. Max path length is 260.  Too tight.
    # $hexString.Length = 6548

    #changing it to 32*5 = 160.. Because once inflated with GUID formatting will be + 20 chars (180 char total, maybe 185 if slashes count). So then 160 - 6 for index = 154 chunks.

    $max_chunk_length = 154
    $max_depth = 5

    # take the hex string length, divide by our max length of 186 chars, and since we will likely get a float - e.g., 35.2, we add +1 and cast as int
    $number_of_folders = [int]($hexString.Length / $max_chunk_length) + 1
    echo "We will generate $number_of_folders top-level folders."


    # Generate the list of random 6-character hex values
    $hexValues = 1..$number_of_folders | ForEach-Object {
        '{0:X6}' -f (Get-Random -Maximum 0xFFFFFF)
    }

    # Sort the list
    $sortedHexValues = $hexValues | Sort-Object

    # Store the sorted list in an array
    $hexArray = @($sortedHexValues)

    # Output the array
    #echo "Here is our array of folder prefixes:"
    #$hexArray
    #sleep 10

    # Define the number of chunks, chunk size, and prefix
    $numChunks = $number_of_folders
    $chunkSize = $max_chunk_length

    <#
    # Pad the string with 0's to ensure it's divisible by the chunk size
    $paddedString = $hexString.PadRight($numChunks * $chunkSize, 'F')

    # Split the string into chunks
    $chunks = [regex]::Matches($paddedString, ".{1,$chunkSize}") | ForEach-Object { $_.Value }
    #>

    # Calculate the number of padding characters needed
    $paddingLength = ($numChunks * $chunkSize) - $hexString.Length
    if ($paddingLength % 2 -ne 0) {
        $paddingLength += 1
    }

    # Pad the string with '20' to ensure it's divisible by the chunk size and has an even number of characters
    # using spaces for padding at end instead
    #$paddedString = $hexString + ('20' * ($paddingLength / 2))

    # FOR FILE - BINARY DATA
    # Pad the string with '00' -  to ensure it's divisible by the chunk size and has an even number of characters
    # using spaces for padding at end instead
    $paddedString = $hexString + ('00' * ($paddingLength / 2))



    # Split the string into chunks
    $chunks = [regex]::Matches($paddedString, ".{1,$chunkSize}") | ForEach-Object { $_.Value }

    $i = 0

    # Process each chunk
    foreach ($chunk in $chunks) {
        #echo "*************    DOING PART $i     ***************"
        $prefix = $hexArray[$i]
        # Prepend the prefix
        $chunkWithPrefix = $prefix + $chunk

        # Split the chunk into 32-char segments and format as GUIDs
        $guids = [regex]::Matches($chunkWithPrefix, ".{1,32}") | ForEach-Object {
            $segment = $_.Value
            $formattedGuid = ($segment -replace '(.{8})(.{4})(.{4})(.{4})(.{12})', '$1-$2-$3-$4-$5')
            [guid]$formattedGuid
        }

        # array to hold our folders before we create them
        $tmp_path_array = @()

        # Process our GUIDs
        $guids | ForEach-Object { 
 
            #Write-Output $_
            $tmp_path_array+="$_"
            }
        #echo "Making directories:"
  
        $fifthline = "{0}\{1}\{2}\{3}\{4}" -f $tmp_path_array[0], $tmp_path_array[1], $tmp_path_array[2], $tmp_path_array[3], $tmp_path_array[4]

        echo $fifthline
        #this -p option creates any required parent folders
        mkdir -p "$fifthline" | out-null

        $i++
    }
}




#### DECODER ######

function decoderRing {


echo "OKAY LET'S TRY TO DECODE IT NOW!"

# Set the root directory
$rootDirectory = $currentDirectory
$rootDirectoryLevels = $rootDirectory.Path.split('\').Count

# clear this value
$decoder_hex_string = ""

$topLevelFolders = Get-ChildItem -Path $rootDirectory -Directory
# Iterate through each top-level folder
foreach ($folder in $topLevelFolders) {
    #echo "TESTING $folder"
    # Get all subfolders recursively
    $subFolders = Get-ChildItem -Path $folder.FullName -Directory -Recurse

    # Find the deepest subfolder
    $deepestSubFolder = $subFolders | Sort-Object { $_.FullName.Split('\').Count } -Descending | Select-Object -First 1

    # Print the full path of the deepest subfolder
    #Write-Output "$($deepestSubFolder.FullName)"
    $trunc_path_split = $deepestSubFolder.Fullname.Split("\")
    $truncated_output = ($trunc_path_split[$rootDirectoryLevels..($trunc_path_split.Length - 1)] -join '\')
    write-output "$($truncated_output)"

    # now format it for our data to append to decoder_hex_string array
    # first, remove all dashes, slashes, Xs, and then cut chars 7- end
    #$purehex = $truncated_output.Substring(6).replace("-","").replace("\","").replace("FF","0D0A")

    $purehex = $truncated_output.Substring(6).replace("-","").replace("\","")
    $decoder_hex_string += $purehex


}


#echo "Our hex string is this:"
# realized we won't have hexstring.length on decoding
#$decoder_hex_string = $decoder_hex_string.substring(0,$hexString.Length)

echo "our hex string is $($decoder_hex_string.Length) chars long"
sleep 5


#echo "Decoded it looks like this:"
# Split the hex string into chunks of 2 characters (each representing a byte)
$decoded_bytes = [regex]::Matches($decoder_hex_string, '..') | ForEach-Object { [Convert]::ToByte($_.Value, 16) }
# Convert the byte array back into a string
#$asciiString = [System.Text.Encoding]::UTF8.GetString($decoded_bytes)
#Write-Output $asciiString

$outputpath = "$currentDirectory\decoded_output.txt"

echo "Writing our payload to file: $outputpath"

# Write the byte stream to the file
Set-Content -Path $outputpath -Value $decoded_bytes -Encoding Byte

# Verify that the file has been created
if (Test-Path $outputpath) {
    Write-Output "File created successfully at: $outputpath"
} else {
    Write-Output "Failed to create the file."
}


}


encodeFile

sleep 5

decoderRing
