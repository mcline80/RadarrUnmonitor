$uri = "https://urldefense.proofpoint.com/v2/url?u=http-3A__localhost-3A7878_api_movie-2522-23VALID&d=DwIGaQ&c=9g4MJkl2VjLjS6R4ei18BA&r=g6u22jQsyopSe3dngu6XKPR4OQfBviL-SPDa_Vgzhew&m=Oygs0T9n_uExyNuVniHhsKzraq6eOO-jTkxGjqApAlg&s=gYlpTkDtWaC2CVe3ifNJD8XZ0RuXnQc-keKKFxRhVvQ&e=  URL to RADARR MOVIE LIST

$uriP = "http://<RADARRADDRESS>/api/movie"#same for another pull

$apiKEY = "<API KEY" #YOUR API KEY NOTE: RADARR > SETTINGS > GENERAL TAB

$Headers = @{'X-API-KEY'=$apiKEY} #HEADER INFORMATION FOR GET/PULL

#Grabs the JSON details out of Movie listing completely and converts all to a PS OBJECT
$GetJSON = (Invoke-WebRequest -Uri $uri -Headers $Headers -UseBasicParsing).Content | ConvertFrom-Json

#Looks at each item from created Powershell object SETID and looks at monitored and hasFile if both are TRUE - Gets ID#
$SetID = $GetJSON | ? {$_.monitored -eq "True" -and $_.hasFile -eq "True"} | Select id

#Takes each ID found from SETID and assigns to movies ID number to $movie
foreach($movie in $SetID){

$uriP = "https://urldefense.proofpoint.com/v2/url?u=http-3A__localhost-3A7878_api_movie_-24movie&d=DwIGaQ&c=9g4MJkl2VjLjS6R4ei18BA&r=g6u22jQsyopSe3dngu6XKPR4OQfBviL-SPDa_Vgzhew&m=Oygs0T9n_uExyNuVniHhsKzraq6eOO-jTkxGjqApAlg&s=ULy4R7lDakUajhI-ilzBhaYrsXIHSFc8v6Li6kJgo4E&e= " #pulls JSON data for individaul movie  and conversts to PSOBJECT

$Movieobject = (Invoke-WebRequest -Uri $uriP -Headers $Headers).Content | ConvertFrom-Json

$movieobject.monitored = "False" #Changes monitored to FALSE

$Movieobject.movieFile.quality = ""#Changes quality to EMPTY STRING (NOTE: IF THIS ISN'T USED IT WILL FAIL)

$getmoviedetails = $Movieobject | Select Title,id,monitored,hasFile #OPTIONAL #This simply prints a ID,TITLE and new monitored status,and hasFILE status

$updateJSON = $Movieobject | ConvertTo-Json #Converts Back to JSON object

Invoke-WebRequest -Uri $uri -Method Put -Headers $Headers -Body $UpdateJson #Performs full put method back to the ID/MOVIE page

Write-Host -ForegroundColor Green "$movie has been updated in Radarr to unmonitored: $getmoviedetails"

}
