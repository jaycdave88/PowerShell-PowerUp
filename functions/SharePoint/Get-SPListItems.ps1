<#
$Metadata = @{
    Title = "Get SharePoint List Items"
	Filename = "Get-SPListItems.ps1"
	Description = ""
	Tags = ""powershell, sharepoint, function"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-07-29"
	LastEditDate = "2013-10-08"
	Version = "2.1.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or 
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Get-SPListItems{

<#

.SYNOPSIS
    Get all items of the chosen SharePoint lists.

.DESCRIPTION
	Get all items of the chosen SharePoint lists.
    
.PARAMETER Url
	Url of the SharePoint website containing the lists.

.PARAMETER ListName
	Only get items from the specified list.
  
.PARAMETER OnlyDocumentLibraries
	Only get items of document libraries
    
.PARAMETER Recursive
	Requires Identity, includes the every sub list of the specified website.


.EXAMPLE
	PS C:\> Get-SPListItems -Url "http://sharepoint.vbl.ch/Projekte/SitePages/Homepage.aspx" -ListName "Documents" -OnlyDocumentLibraries -Recursive

#>

	param(
		[Parameter(Mandatory=$false)]
		[string]$Url,

		[Parameter(Mandatory=$false)]
		[string]$FilterListName,
		
		[switch]$OnlyDocumentLibraries,
        
        [switch]$OnlyFiles,

		[switch]$Recursive
	)
    
    #--------------------------------------------------#
    # modules
    #--------------------------------------------------#
    if ((Get-PSSnapin “Microsoft.SharePoint.PowerShell” -ErrorAction SilentlyContinue) -eq $null) {
        Add-PSSnapin “Microsoft.SharePoint.PowerShell”
    }

    #--------------------------------------------------#
    # main
    #--------------------------------------------------#
    $(if($Url){    

        [Uri]$SPWebUrl = (Get-CleanSPUrl $Url).WebUrl
                
        if($Recursive){
                  
            Get-SPLists -Url $SPWebUrl.OriginalString -Recursive -OnlyDocumentLibraries:$OnlyDocumentLibraries -FilterListName $FilterListName
                        
        }else{
        
            Get-SPLists -Url $SPWebUrl.OriginalString -OnlyDocumentLibraries:$OnlyDocumentLibraries -FilterListName $FilterListName
        }
     }else{
    
       Get-SPLists -OnlyDocumentLibraries:$OnlyDocumentLibraries -FilterListName $FilterListName
            
    }) | %{

        $_.Items | %{
          
            $(if($OnlyFiles){ 
                
                $_ | where {$_.FileSystemObjectType -eq "File"}
                
            }else{
            
                $_
            
            })
        }
    } 
}
