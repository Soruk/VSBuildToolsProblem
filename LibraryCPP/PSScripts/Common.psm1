function Get-ScriptPath{

	$scriptPath = ''
	if($PSVersionTable.PSVersion.Major -lt 3){
		$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path
	}
	else{
		$scriptPath = $PSScriptRoot
	}
	return $scriptPath 
}

function ExitWithCode 
{ 
    [CmdletBinding()]
    param 
    ( 
        $exitcode 
    )

    $host.SetShouldExit($exitcode) 
    exit 
}

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Set-GlobalProxy{
   [CmdletBinding()]
   param (
   [switch]$Elevated,

   [parameter(Mandatory=$false)]
   [string]
   $proxyUrl = ""	
  )

  if($proxyUrl -ne "" -and ![string]::IsNullOrEmpty($proxyUrl)){
    [Environment]::SetEnvironmentVariable('HTTP_PROXY', $proxyUrl, 'machine');
    [Environment]::SetEnvironmentVariable('HTTPS_PROXY', $proxyUrl, 'machine');
  }

}
export-modulemember -function Get-ScriptPath
export-modulemember -function ExitWithCode
export-modulemember -function Test-Admin
export-modulemember -function Set-GlobalProxy