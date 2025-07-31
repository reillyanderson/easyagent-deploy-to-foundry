$MANAGED_IDENTITY_RESOURCE_ID
$AZURE_RESOURCE_GROUP
$AI_FOUNDATION_PROJECT_NAME
$AI_FOUNDATION_ACCOUNT_NAME
$GPT_MODEL_NAME
Write-Output \"Starting AI Foundry Agent creation using REST API...\"
az login --identity --resource-id $MANAGED_IDENTITY_RESOURCE_ID
Write-Output \"Successfully logged in with managed identity.\"
$foundryAccessToken = az account get-access-token --resource 'https://ai.azure.com' | jq -r .accessToken | tr -d '\"'
Write-Output \"Access token for AI Foundry: $foundryAccessToken\"
$cognitiveAccountEndpoint = az cognitiveservices account show --name $foundryAccountNameUniqueSuffix --resource-group $resourceGroupName --query 'properties.endpoints.\"AI Foundry API\"' -o tsv
Write-Output \"Cognitive Account Endpoint: $cognitiveAccountEndpoint\"
$projectEndpoint = $cognitiveAccountEndpoint+\"api/projects/$aiFoundryProjectName\"
Write-Output \"Project Endpoint: $projectEndpoint\"
$Headers = @{
  \"Authorization\" = \"Bearer $foundryAccessToken\"
  \"Content-Type\" = \"application/json\"
}
$Body = @{
  \"instructions\" = $instructions
  \"name\" = $agentName
  \"model\" = $gptModelName
} | ConvertTo-Json
$result = Invoke-WebRequest -Uri \"$projectEndpoint/assistants?api-version=$apiVersion\" -Method Post -Headers $Headers -Body $Body
Write-Output \"Result: $result\"
$resultContentJson = $result.Content | ConvertFrom-Json
Write-Output $resultContentJson
$agentId = $resultContentJson.id
Write-Output \"Agent ID: $agentId\"
return $agentId
