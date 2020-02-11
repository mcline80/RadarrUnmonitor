$uri = "http://<RADARRADDRESS>/api/movie" #URL to RADARR MOVIE LIST

$uriP = "http://<RADARRADDRESS>/api/movie" #same for another pull

$apiKEY = "<API KEY" #YOUR API KEY NOTE: RADARR > SETTINGS > GENERAL TAB

$Headers = @{'X-API-KEY'=$apiKEY} #HEADER INFORMATION FOR GET/PULL

#Grabs the JSON details out of Movie listing completely and converts all to a PS OBJECT
$GetJSON = (Invoke-WebRequest -Uri $uri -Headers $Headers -UseBasicParsing).Content | ConvertFrom-Json

#Looks at each item from created Powershell object SETID and looks at monitored and hasFile if both are TRUE - Gets ID#
$SetID = $GetJSON | ? {$_.monitored -eq "True" -and $_.hasFile -eq "True"} | Select id

#Takes each ID found from SETID and assigns to movies ID number to $movie
foreach($movie in $SetID){

$uriP = "http://<RADARRADDRESS>/api/movie/$movie" #pulls JSON data for individaul movie  and conversts to PSOBJECT

$Movieobject = (Invoke-WebRequest -Uri $uriP -Headers $Headers).Content | ConvertFrom-Json

$movieobject.monitored = "False" #Changes monitored to FALSE

$Movieobject.movieFile.quality = ""#Changes quality to EMPTY STRING (NOTE: IF THIS ISN'T USED IT WILL FAIL)

$getmoviedetails = $Movieobject | Select Title,id,monitored,hasFile #OPTIONAL #This simply prints a ID,TITLE and new monitored status,and hasFILE status

$updateJSON = $Movieobject | ConvertTo-Json #Converts Back to JSON object

Invoke-WebRequest -Uri $uri -Method Put -Headers $Headers -Body $UpdateJson #Performs full put method back to the ID/MOVIE page

Write-Host -ForegroundColor Green "$movie has been updated in Radarr to unmonitored: $getmoviedetails"

}
