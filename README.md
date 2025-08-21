main.json currently deploys:
- cosmos + db + custom data role
- foundry + project
- MI
- App Service App Service Plan + Web App
- Adds role assignments for MI on all resources
- Updates Web App with foundry values and deploys EasyAgent site extension

Run via creating a custom deployment template in azure portal. Can be run with existing webapp etc. (i.e. there is a BYO resources option), but it is not required that you have anything to start. 

If your open api spec is wrong, the site extension won't be able to update your agent tools properly and you'll have to edit the agent in foundry and/or update the app setting that was added to your webapp. 

Once you've deployed, go to /ai/chat on your webapp to test things out.
