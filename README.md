main.json currently deploys:
- cosmos + db + custom data role
- foundry + project + generic agent
- MI
- App Service App Service Plan + Web App
- Adds role assignments for MI on all resources
- Updates Web App with foundry values and deploys EasyAgent site extension

Run via creating a custom deployment template in azure portal. Can be run with existing webapp etc. (i.e. there is a BYO resources option), but it is not required that you have anything to start. 

If your open api spec is wrong, the site extension won't be able to update your agent tools properly and you'll have to edit the agent in foundry and/or update the app setting that was added to your webapp. 

Once you've deployed, go to /ai/chat on your webapp to test things out.

Deployment process:
1. Go to portal.azure.com
2. Go to the subscription that has the BYO resources, or that you want to create the resources in.
3. Make sure you (or the deployment orchestrator - whatever or whoever will kick off the deployment) has "Managed Identity Operator" on the subscription. This allows you to run deployment scripts, which is needed for agent creation.
4. Create a new resource of type "Template deployment (deploy using custom templates)"
5. Select "Build your own template in the editor" and then copy and paste in the contents of `./main.json` from this repo. Click "save"
6. Edit the parameters accordingly. At minimum, you need to select or create a resource group and specify a web app name and the open api spec json (properly escaped).
7. Click "Review and create", fix any validation errors, and run the template.
8. Once the deployment has finished, go to your webapp to /ai/chat to test out your new chat feature!
