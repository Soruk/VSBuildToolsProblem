function Get-MSBuildPath{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]
		[ValidateNotNullOrEmpty()]$MSBuildForcedVersion = "2017",
        
        [parameter(Mandatory=$false)]
        [ValidateSet("x86","x64")]
		[ValidateNotNullOrEmpty()]$MSBuildPlatform = "x86",

        [parameter(Mandatory=$false)]
        [ValidateSet("BuildTools", "Sql","Enterprise","Professional", "Community")]
		[ValidateNotNullOrEmpty()]
		[String]$MSBuildProductType = "BuildTools"
    )
    $msbuildPath = "";
    $platform="amd64";
    if($MSBuildPlatform -eq "x86"){
        $platform="";
    }
    elseif ($MSBuildPlatform -eq "x64"){
        $platform="amd64";
    }
    if (!(Get-Module -ListAvailable -Name VSSetup -ErrorAction SilentlyContinue)) {
        Install-Module VSSetup -Scope CurrentUser -Force
    }  
    #Import-Module -Force VSSetup

    $vsInstallationPath = (Get-VSSetupInstance | Where-Object { ($_.DisplayName -like "*$($MSBuildForcedVersion)*") } | Select-VSSetupInstance -Product "Microsoft.VisualStudio.Product.$MSBuildProductType" -Latest | Select-Object -ExpandProperty "InstallationPath");
    if($vsInstallationPath -eq $null){
      $vsInstallationPath = (Get-VSSetupInstance | Where-Object { ($_.DisplayName -like "*$($MSBuildForcedVersion)*") } | Select-VSSetupInstance -Latest | Select-Object -ExpandProperty "InstallationPath");   
    }
    if($vsInstallationPath -eq $null){
        $vsInstallationPath = ${env:ProgramFiles(x86)}
    }
    $msbuildPathCurrent = $vsInstallationPath + "\MSBuild\Current\Bin\$platform\MSBuild.exe";
    $msbuildPath15 = $vsInstallationPath + "\MSBuild\15.0\Bin\$platform\MSBuild.exe";
    $msbuildPath14 = ${env:ProgramFiles(x86)} + "\MSBuild\14.0\Bin\$platform\MSBuild.exe";
    $msbuildPath12 = ${env:ProgramFiles(x86)} + "\MSBuild\12.0\Bin\$platform\MSBuild.exe";
    if ((Test-Path $msbuildPathCurrent -ErrorAction SilentlyContinue) -and ($MSBuildForcedVersion -eq "2017" -or $MSBuildForcedVersion -eq "2019")){
        $msbuildPath=$msbuildPathCurrent;
    }
    elseif ((Test-Path $msbuildPath15 -ErrorAction SilentlyContinue) -and $MSBuildForcedVersion -eq "2017"){
        $msbuildPath=$msbuildPath15;
    }
    elseif ((Test-Path $msbuildPath14 -ErrorAction SilentlyContinue) -and $MSBuildForcedVersion -eq "2015"){
        $msbuildPath=$msbuildPath14;
    }
    #elseif ((Test-Path $msbuildPath12) -and $MSBuildForcedVersion -eq "2013"){
    elseif ((Test-Path $msbuildPath12 -ErrorAction SilentlyContinue)){
        $msbuildPath=$msbuildPath12;
    }
    return $msbuildPath;
}


function Get-MSBuildPathx64{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]
		[ValidateNotNullOrEmpty()]$MSBuildForcedVersion = "2017",

        [parameter(Mandatory=$false)]
        [ValidateSet("BuildTools", "Sql","Enterprise","Professional", "Community")]
		[ValidateNotNullOrEmpty()]
		[String]$MSBuildProductType = "BuildTools"
    )
    return (Get-MSBuildPath -MSBuildForcedVersion $MSBuildForcedVersion -MSBuildPlatform "x64" -MSBuildProductType $MSBuildProductType) ;
}

function Get-MSBuildPathx86{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]
		[ValidateNotNullOrEmpty()]$MSBuildForcedVersion = "2017",

        [parameter(Mandatory=$false)]
        [ValidateSet("BuildTools", "Sql","Enterprise","Professional", "Community")]
		[ValidateNotNullOrEmpty()]
		[String]$MSBuildProductType = "BuildTools"
    )
        return (Get-MSBuildPath -MSBuildForcedVersion $MSBuildForcedVersion -MSBuildPlatform "x86" -MSBuildProductType $MSBuildProductType) ;
}

function Get-CppSuffix{
    [CmdletBinding()]    
    param (
        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]
		[ValidateNotNullOrEmpty()]$MSBuildForcedVersion = "2017"
    )
    $cppSuffix = "";
    $cppPath14 = ${env:ProgramFiles(x86)} + "\MSBuild\Microsoft.Cpp\v4.0\V140\Microsoft.Cpp.Default.props";
    $cppPath12 = ${env:ProgramFiles(x86)} + "\MSBuild\Microsoft.Cpp\v4.0\V120\Microsoft.Cpp.Default.props";
    if ((Test-Path $cppPath14 -ErrorAction SilentlyContinue) -and ($MSBuildForcedVersion -eq "2015" -or $MSBuildForcedVersion -eq "2017" -or $MSBuildForcedVersion -eq "2019")){
        $cppSuffix="2017";
    }
    #elseif ((Test-Path $cppPath12) -and $MSBuildForcedVersion -eq "2013"){
    elseif ((Test-Path $cppPath12 -ErrorAction SilentlyContinue)){
        $cppSuffix="2013";
    }
    return $cppSuffix;
}


function Get-MSPDBSRVPath{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]
		[ValidateNotNullOrEmpty()]$MSBuildForcedVersion = "2017",
       

        [parameter(Mandatory=$false)]
        [ValidateSet("BuildTools", "Sql","Enterprise","Professional", "Community")]
		[ValidateNotNullOrEmpty()]
		[String]$MSBuildProductType = "BuildTools"
    )
    $mspdbsrvPath = "";    
    if (!(Get-Module -ListAvailable -Name VSSetup -ErrorAction SilentlyContinue)) {
        Install-Module VSSetup -Scope CurrentUser -Force
    }  
    Import-Module VSSetup

    $vsInstallationPath = (Get-VSSetupInstance | Where-Object { ($_.DisplayName -like "*$($MSBuildForcedVersion)*") } | Select-VSSetupInstance -Product "Microsoft.VisualStudio.Product.$MSBuildProductType" -Latest | Select-Object -ExpandProperty "InstallationPath");
    if($vsInstallationPath -eq $null){
      $vsInstallationPath = (Get-VSSetupInstance | Where-Object { ($_.DisplayName -like "*$($MSBuildForcedVersion)*") } | Select-VSSetupInstance -Latest | Select-Object -ExpandProperty "InstallationPath");   
    }
    if($vsInstallationPath -eq $null){
        $vsInstallationPath = ${env:ProgramFiles(x86)}
    }
    $mspdbsrvPath15 = $vsInstallationPath + "\Common7\IDE\mspdbsrv.exe";
    $mspdbsrvPath14 = ${env:ProgramFiles(x86)} + "\Microsoft Visual Studio 14.0\VC\bin\mspdbsrv.exe";
    $mspdbsrvPath12 = ${env:ProgramFiles(x86)} + "\Microsoft Visual Studio 12.0\VC\bin\mspdbsrv.exe";
    if ((Test-Path $mspdbsrvPath15 -ErrorAction SilentlyContinue) -and ($MSBuildForcedVersion -eq "2017" -or $MSBuildForcedVersion -eq "2019")){
        $mspdbsrvPath=$mspdbsrvPath15;
    }
    elseif ((Test-Path $mspdbsrvPath14 -ErrorAction SilentlyContinue) -and $MSBuildForcedVersion -eq "2015"){
        $mspdbsrvPath=$mspdbsrvPath14;
    }
    #elseif ((Test-Path $mspdbsrvPath12) -and $MSBuildForcedVersion -eq "2013"){
    elseif ((Test-Path $mspdbsrvPath12 -ErrorAction SilentlyContinue)){
        $mspdbsrvPath=$mspdbsrvPath12;
    }
   
    return $mspdbsrvPath;
}


export-modulemember -function Get-MSBuildPathx64 
export-modulemember -function Get-MSBuildPathx86 
export-modulemember -function Get-MSBuildPath
export-modulemember -function Get-CppSuffix 
export-modulemember -function Get-MSPDBSRVPath 