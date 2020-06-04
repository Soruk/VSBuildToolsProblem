$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module -force "$scriptDir\Common.psm1";
Import-Module -force "$scriptDir\MSBuildChoice.psm1";

function MSBuildFile
{
    [CmdletBinding()]
	param (
        [parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
	    [String]
		$BuildFilePath,

        [parameter(Mandatory=$true)]	
		[ValidateNotNullOrEmpty()]
		[String]
		$LogFileName,

        [parameter(Mandatory=$false)]
        [ValidateSet("2013","2015","2017","2019")]		
		[ValidateNotNullOrEmpty()]
		[String]
		$MSBuildForcedVersion = "2017",

        [parameter(Mandatory=$false)]
        [ValidateSet("x86","x64")]		
		[ValidateNotNullOrEmpty()]
		[String]
		$MSBuildPlatform = "x86",

        [parameter(Mandatory=$false)]
        [ValidateSet("Release","Debug")]	
		[ValidateNotNullOrEmpty()]
		[String]
		$Configuration = "Release",

        [parameter(Mandatory=$false)]
        [ValidateSet("Any CPU","AnyCPU","x86","x64","Win32")]
		[ValidateNotNullOrEmpty()]
		[String]
		$Platform = "Any CPU",

        [parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[String]
		$Target = "",

        [parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[String]
		$PublishProfile = "",

        [parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[String]
		$ExcludeFromBuild = "",

        [parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[String]
		$IgnoreProjectExtensions = "",

        [parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[String]
		$AdditionnalParameters = "",
		
		[parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[bool]
		$EmptiesLogFile = $true,
		
		[parameter(Mandatory=$false)]        
		[ValidateNotNullOrEmpty()]
		[bool]
		$MultiProccess = $true,

        [parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[String]
		$BuildMode = "Rebuild",

        [parameter(Mandatory=$false)]
        [ValidateSet("BuildTools", "Sql","Enterprise","Professional", "Community")]
		[ValidateNotNullOrEmpty()]
		[String]
        $MSBuildProductType = "BuildTools",

        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [AllowNull()]
        [String]
        $WorkingDirectory= $null

    )
    $ok=$true;
    if([String]::IsNullOrWhiteSpace($WorkingDirectory)){
        $currentPath = Get-ScriptPath;
        $currentPath = Split-Path $currentPath -Parent;	
    }
    else{
        $currentPath = $WorkingDirectory;
    }   
    $logpath = Join-Path $currentPath "$LogFileName.txt";	
    if (![System.IO.Path]::IsPathRooted("$BuildFilePath")){
		$buildFile = Join-Path $currentPath "$BuildFilePath";
	}    
    else {
		$buildFile = "$BuildFilePath";
	}    
    if($EmptiesLogFile -eq $true){
		New-Item $logpath -type file -force | Out-Null;
	}    
    $msbuild=Get-MSBuildPathx64 -MSBuildForcedVersion $MSBuildForcedVersion -MSBuildProductType $MSBuildProductType;
    $version=Get-CppSuffix;
    if($MSBuildPlatform -eq "x86"){
        $msbuild=Get-MSBuildPathx86 -MSBuildForcedVersion $MSBuildForcedVersion -MSBuildProductType $MSBuildProductType;
    }
    $msbuild = [System.IO.Path]::GetFullPath($msbuild)
    if(!(Test-Path -Path "$msbuild" -ErrorAction SilentlyContinue)){
		Write-Error "MSBuild File Code $($msbuild) does not exist."
		$ok = $false;       
	}
    $env:_MSPDBSRV_ENDPOINT_ = (New-Guid).Guid;
    $mspdbsrv = Get-MSPDBSRVPath  -MSBuildForcedVersion $MSBuildForcedVersion -MSBuildProductType $MSBuildProductType; 
    $mspdbsrvArgs = "-start -shutdowntime -1"
    $mspdbsrvExists = Test-Path -Path "$msbuild" -ErrorAction SilentlyContinue
	if($ok -eq $true){
        #$arguments="`"$buildFile`" "
        $arguments=" "
		if($MultiProccess -eq $true){
			$arguments= $arguments + "/m";
		}
        if($AdditionnalParameters -ne ""){
			$arguments = $arguments + " $AdditionnalParameters";
		}
		$arguments= $arguments + " /nr:false /p:UseSharedCompilation=false /nologo /p:Configuration=`"$Configuration`" /p:Platform=`"$Platform`""
		if($Target -ne ""){
			$arguments = $arguments + " /p:DeployOnBuild=true /t:`"$Target`":$BuildMode";
		}
		else{
			$arguments = $arguments + " /t:$BuildMode"
		}
		if($PublishProfile -ne ""){
			$arguments = $arguments + " /p:PublishProfile=`"$PublishProfile`"";
		}
		if($ExcludeFromBuild -ne ""){
			$arguments = $arguments + " /p:ExcludeFromBuild=`"$ExcludeFromBuild`"";
		}
        if($IgnoreProjectExtensions -ne ""){
			$arguments = $arguments + " /ignoreprojectextensions:`"$IgnoreProjectExtensions`"";
		}       
		$arguments = $arguments + " /fileLoggerParameters:`"ErrorsOnly;Verbosity=minimal;LogFile=$logpath;Append;`"";
        $arguments = $arguments + " `"$buildFile`" "
        Write-Host "MBBuild begin for building $($BuildFilePath)" -foreground DarkGray
        if ($mspdbsrvExists){
            $processMspdbsrv = Start-Process -NoNewWindow -FilePath $mspdbsrv -ArgumentList $mspdbsrvArgs -PassThru;
        }
    	$process = Start-Process -NoNewWindow -FilePath $msbuild -ArgumentList $arguments -Wait -PassThru;
        if ($mspdbsrvExists){
            Stop-Process $processMspdbsrv.Id;
        }
        Write-Host "MBBuild end for building $($BuildFilePath)" -foreground DarkGray        
		if ($process.ExitCode -eq 0){
			 Write-Host "MBBuild OK for building $($BuildFilePath)" -foreground Green
		}
		else {       
			Write-Error "MSBuild Error Code $($process.ExitCode) for building $($BuildFilePath)"
			$ok = $false;       
		}
	}
    return $ok;        
}

function EchoBeginBuild
{
   [CmdletBinding()]
	param(
		[parameter(Mandatory=$true)]
		[string]
		$BuildName
	)
	Write-Host "====# $($BuildName) START BUILD #====" -foreground Yellow
}

function EchoEndBuildOK
{
    [CmdletBinding()]
	param(
		[parameter(Mandatory=$true)]
		[string]
		$BuildName,

        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [AllowNull()]
	    [string]
	    $OrginalCurrentDir = $null,

        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [AllowNull()]
	    [string]
	    $MKlinkPath = $null
	)
	Write-Host "====# $($BuildName) END BUILD #====" -foreground Yellow
	#ExitWithCode -exitcode 0
    
    if(![String]::IsNullOrWhiteSpace($OrginalCurrentDir) -and ![String]::IsNullOrWhiteSpace($MKlinkPath)){
        Remove-RootMKLink -OrginalCurrentDir $OrginalCurrentDir -MKlinkPath $MKlinkPath
    }
    return 0;
}
function EchoEndBuildKO()
{
    [CmdletBinding()]
	param(
		[parameter(Mandatory=$true)]
		[string]
		$BuildName,

        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [AllowNull()]
	    [string]
	    $OrginalCurrentDir = $null,

        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [AllowNull()]
	    [string]
	    $MKLinkPath = $null
	)
	#Write-Host "====# $($BuildName) BUILD FAILED #====" -foreground Red	
    Write-Error "====# $($BuildName) BUILD FAILED #====" -ErrorAction Stop
	#ExitWithCode -exitcode 1

    if(![String]::IsNullOrWhiteSpace($OrginalCurrentDir) -and ![String]::IsNullOrWhiteSpace($MKLinkPath)){
        Remove-RootMKLink -OrginalCurrentDir $OrginalCurrentDir -MKLinkPath $MKlinkPath
    }
    return 1;
}

function New-RootMKLink(){
    [CmdletBinding()]
    param(
	    [parameter(Mandatory=$true)]
	    [string]
	    $CurrentDir
    )

    $root = $(get-location).Drive.Root
    $folderName = Split-Path -Path $CurrentDir -Leaf;	
    $workingPath = Split-Path -Path $CurrentDir -Parent;	
    #$workingPath = Join-Path  $CurrentDir "..\"
    $leaf = Split-Path -Path $workingPath -Leaf
    $mklinkPath = Join-Path $root $leaf

    cmd /c mklink /J $mklinkPath $workingPath 

    Set-Location (Join-Path $mklinkPath $folderName)

    return $mklinkPath
}

function Remove-RootMKLink(){
    [CmdletBinding()]
    param(
	    [parameter(Mandatory=$true)]
	    [string]
	    $OrginalCurrentDir,

        [parameter(Mandatory=$true)]
	    [string]
	    $MKLinkPath
    )

    Set-Location $OrginalCurrentDir

    cmd /c rmdir $MKlinkPath
}

export-modulemember -function MSBuildFile
export-modulemember -function EchoBeginBuild
export-modulemember -function EchoEndBuildOK
export-modulemember -function EchoEndBuildKO
export-modulemember -function New-RootMKLink