# Copyright 2012 Aaron Jensen
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function Install-IisVirtualDirectory
{
    <#
    .SYNOPSIS
    Installs a virtual directory.

    .DESCRIPTION
    This function creates a virtual directory under website `SiteName` at `/Name`, serving files out of `Path`.  If a virtual directory called `Name` already exists, it is deleted first, and a new virtual directory is created.

    .EXAMPLE
    Install-IisVirtualDirectory -SiteName 'Peanuts' -Name 'DogHouse' -Path C:\Peanuts\Doghouse

    Creates a /DogHouse virtual directory, which serves files from the C:\Peanuts\Doghouse directory.  If the Peanuts website responds to hostname `peanuts.com`, the virtual directory is accessible at `peanuts.com/DogHouse`.

    .EXAMPLE
    Install-IisVirtualDirectory -SiteName 'Peanuts' -Name 'Brown/Snoopy/DogHouse' -Path C:\Peanuts\DogHouse

    Creates a DogHouse virtual directory under the `Peanuts` website at `/Brown/Snoopy/DogHouse` serving files out of the `C:\Peanuts\DogHouse` directory.  If the Peanuts website responds to hostname `peanuts.com`, the virtual directory is accessible at `peanuts.com/Brown/Snoopy/DogHouse`.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The site where the virtual directory should be created.
        $SiteName,
        
        [Parameter(Mandatory=$true)]
        [string]
        # The name of the virtual directory.  This can contain multiple directory segments for virtual directories not at the root of the website, e.g. First/Second/VirtualDirectory.
        $Name,
        
        [Parameter(Mandatory=$true)]
        [string]
        # The file system path to the virtual directory.
        $Path
    )
    
    $vdirID = """$SiteName/$Name"""
    $output = Invoke-AppCmd list vdir $vdirID
    if( $output -like "*$vdirID*" )
    {
        Invoke-AppCmd delete vdir $vdirID
    }
    
    Invoke-AppCmd add vdir /app.name:"$SiteName/" / /path:/$Name /physicalPath:"$Path"       
}
