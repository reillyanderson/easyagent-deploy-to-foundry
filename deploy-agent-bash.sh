echo $AZURE_RESOURCE_GROUP
echo $AI_FOUNDRY_PROJECT_NAME
echo $AI_FOUNDRY_ACCOUNT_NAME
echo $GPT_MODEL_NAME
echo $INSTRUCTIONS
echo $AGENT_NAME
echo $API_VERSION
echo "Starting AI Foundry Agent creation using REST API..."
foundryAccessToken=$(az account get-access-token --resource 'https://ai.azure.com' | jq -r .accessToken | tr -d '"')
echo "Access token for AI Foundry: $foundryAccessToken"
cognitiveAccountEndpoint=$(az cognitiveservices account show --name $AI_FOUNDRY_ACCOUNT_NAME --resource-group $AZURE_RESOURCE_GROUP --query 'properties.endpoints."AI Foundry API"' -o tsv)
echo "Cognitive Account Endpoint: $cognitiveAccountEndpoint"
projectEndpoint="${cognitiveAccountEndpoint}api/projects/${AI_FOUNDRY_PROJECT_NAME}"
echo "Project Endpoint: $projectEndpoint"
formatBody="{\"instructions\":\"${INSTRUCTIONS}\",\"name\":\"${AGENT_NAME}\",\"model\":\"${GPT_MODEL_NAME}\"}"
echo "Formatted body for API request: $formatBody"
url="${projectEndpoint}/assistants?api-version=${API_VERSION}"
result=$(curl -X POST "$url" -H "Authorization: Bearer ${foundryAccessToken}" -H "Content-Type: application/json" -d "$formatBody")
echo "Result: $result"
resultContentJson=$(echo $result | jq -r .)
echo $resultContentJson
echo $resultContentJson | jq -r '{ agentId: .id}'
echo $resultContentJson | jq -r '{ agentId: .id}' > $AZ_SCRIPTS_OUTPUT_PATH
exit 0
