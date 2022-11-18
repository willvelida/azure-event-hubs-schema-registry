@description('The name of our App Service Plan')
param appServicePlanName string

@description('The location to deploy our App Service Plan')
param location string

var appServicePlanSkuName = 'EP1'
var appServicePlanTierName = 'ElasticPremium'
var workerCount = 20

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
  kind: 'elastic'
  properties: {
    maximumElasticWorkerCount: workerCount
  } 
}

output appServicePlanId string = appServicePlan.id
