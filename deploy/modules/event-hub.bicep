@description('The name of the Event Hubs namespace to deploy')
param eventHubNamespaceName string

@description('The location that our resources will be deployed to. Default is location of resource group')
param location string

var orderHubName = 'orders'
var schemaGroupName = 'contososchemagroup'

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    minimumTlsVersion: '1.2'
  }
}

resource orderHub 'Microsoft.EventHub/namespaces/eventhubs@2022-01-01-preview' = {
  name: orderHubName
  parent: eventHubNamespace
  properties: {
    messageRetentionInDays: 7
  }
}

resource contosoSchema 'Microsoft.EventHub/namespaces/schemagroups@2022-01-01-preview' = {
  name: schemaGroupName
  parent: eventHubNamespace
  properties: {
    schemaCompatibility: 'Backward'
    schemaType: 'Avro'
  }
}

output eventHubNamespaceName string = eventHubNamespace.name
output eventHubNamespaceId string = eventHubNamespace.id
output orderEventHubName string = orderHub.name
