@description('The name of our application.')
param applicationName string = uniqueString(resourceGroup().id)

@description('The location that our resources will be deployed to. Default is location of resource group')
param location string = resourceGroup().location

@description('The name of the Event Hubs namespace to deploy')
param eventHubNamespaceName string = 'eh${applicationName}'

@description('The name of the App Service Plan that will be deployed')
param appServicePlanName string = 'asp${applicationName}'

@description('The name of the Storage Account to deploy')
param storageAccountName string = 'fnstor${replace(applicationName, '-', '')}'

@description('The name of the Function App to deploy')
param functionAppName string = 'func${applicationName}'

@description('The name of the App Insights workspace to deploy')
param appInsightsName string = 'ai${applicationName}'

module eventHub 'modules/event-hub.bicep' = {
  name: 'eventHub'
  params: {
    eventHubNamespaceName: eventHubNamespaceName
    location: location
  }
}

module asp 'modules/app-service-plan.bicep' = {
  name: 'asp'
  params: {
    appServicePlanName: appServicePlanName
    location: location
  }
}

module functionApp 'modules/function-app.bicep' = {
  name: 'functionApp'
  params: {
    appInsightsName: appInsightsName 
    eventHubName: eventHub.outputs.orderEventHubName
    eventHubNamespaceName: eventHub.outputs.eventHubNamespaceName
    functionAppName: functionAppName
    location: location
    serverFarmId: asp.outputs.appServicePlanId
    storageAccountName: storageAccountName
  }
}

module eventHubRoles 'modules/event-hub-role-assignment.bicep' = {
  name: 'ev-roles'
  params: {
    eventHubNamespaceName: eventHub.outputs.eventHubNamespaceName 
    functionAppId: functionApp.outputs.functionAppId
    functionAppPrincipalId: functionApp.outputs.functionAppPrincipalId
  }
}
