param(
  [Parameter(Mandatory=$true)]
  [string]$AZURE_RESOURCE_GROUP,
  
  [Parameter(Mandatory=$true)]
  [string]$AI_FOUNDATION_PROJECT_NAME,
  
  [Parameter(Mandatory=$true)]
  [string]$AI_FOUNDATION_ACCOUNT_NAME,
  
  [Parameter(Mandatory=$true)]
  [string]$GPT_MODEL_NAME
)

try {
    Write-Output "Installing Azure PowerShell modules..."
    Install-Module -Name Az.Accounts -Force -AllowClobber -Scope CurrentUser
    Install-Module -Name Az.CognitiveServices -Force -AllowClobber -Scope CurrentUser
    Import-Module Az.Accounts
    Import-Module Az.CognitiveServices
    Write-Output "Azure PowerShell modules installed successfully"
} catch {
    Write-Warning "Failed to install Azure PowerShell modules: $($_.Exception.Message)"
}

try{
    Write-Output "Starting AI Foundry Agent creation using REST API..."
    Connect-AzAccount -Identity
    Write-Output "Successfully logged in with managed identity."
} catch {
    Write-Warning "Failed to authenticate with managed identity: $($_.Exception.Message)"
    throw $_
}

try {
    Write-Output "Retrieving foundry access token..."
    $foundryAccessToken = (Get-AzAccessToken -ResourceUrl 'https://ai.azure.com').Token
    Write-Output "Access token for AI Foundry: $foundryAccessToken"
} catch {
    Write-Warning "Failed to retrieve foundry access token or cognitive account endpoint: $($_.Exception.Message)"
    throw $_
}

try {
    $foundryAccount = Get-AzCognitiveServicesAccount -ResourceGroupName $AZURE_RESOURCE_GROUP -Name $AI_FOUNDATION_ACCOUNT_NAME
    $projectEndpoint = $foundryAccount.Properties.Endpoints["AI Foundry API"] + "api/projects/$AI_FOUNDATION_PROJECT_NAME"
    Write-Output "AI Foundry account and project URL retrieved successfully: $projectEndpoint"
} catch {
    Write-Warning "Failed to retrieve AI Foundry account or project URL: $($_.Exception.Message)"
    throw $_
}

try {
    $Headers = @{
      "Authorization" = "Bearer $foundryAccessToken"
      "Content-Type" = "application/json"
    }
    $Body = @{
      "instructions" = $instructions
      "name" = $agentName
      "model" = $gptModelName
    } | ConvertTo-Json

    $result = Invoke-WebRequest -Uri "$projectEndpoint/assistants?api-version=$apiVersion" -Method Post -Headers $Headers -Body $Body
    Write-Output "Result: $result"
    $resultContentJson = $result.Content | ConvertFrom-Json
    Write-Output $resultContentJson
    $agentId = $resultContentJson.id
    Write-Output "Agent ID: $agentId"
    return $agentId
} catch {
    Write-Warning "Failed to set HTTP headers or invoke web request: $($_.Exception.Message)"
    throw $_
}
