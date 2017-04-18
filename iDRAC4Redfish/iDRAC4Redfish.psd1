﻿#
# Module manifest for module 'module'
#
# Generated by: 
#
# Generated on: 
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = 'Module.psd1'

# Version number of this module.
ModuleVersion = '1.6.8.100'

# ID used to uniquely identify this module
GUID = '11460f31-b8c9-4747-a1ce-2ca5588c02a0'

# Author of this module
Author = 'Karsten Bott'

# Company or vendor of this module
CompanyName = 'Dell|EMC'

# Copyright statement for this module
Copyright = '(c) 2017 . All rights reserved.
                        Karsten Bott

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
'

# Description of the functionality provided by this module
Description = 'Configure DELL iDRAC using RedFish API'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
#ScriptsToProcess = @(".\init.ps1")

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @(
'./Formats/iDRAC4Redfish.Accounts.Format.ps1xml',
'./Formats/iDRAC4Redfish.SimpleStorage.Format.ps1xml',
'./Formats/iDRAC4Redfish.Sessions.Format.ps1xml',
'./Formats/iDRAC4Redfish.lclog.Format.ps1xml',
'./Formats/iDRAC4Redfish.EthernetInterfaces.Format.ps1xml'
)

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @("./idrac4redfish.psm1",
"./errors/errors.psm1")

# Functions to export from this module


# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @('idrac4redfish.psm1',
'idrac4redfish.psd1'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

