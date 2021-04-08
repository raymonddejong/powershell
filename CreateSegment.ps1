#Variables for NSX Manager Connection
$nsxmanagerip = "10.29.12.206"
$nsxuser = "admin"
$nsxpasswd = "VMware1!rdejong"
#General Variables
$description = "Created with VMware PowerCLI"
$tag = "powercli"
#Variables for Segment
$segmentid = "PowerCLI-Test"
$defaultgateway = "192.168.10.1/24"
$transportzone = "/infra/sites/default/enforcement-points/default/transport-zones/8b2474b9-5cbc-4154-b154-a405dd18aa25"
#Connect to NSX Manager
Connect-NsxtServer -Server $nsxmanagerip -User $nsxuser -Password $nsxpasswd
#Retrieve Segment Information
$segmentdata = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.segments
#Set Variables
$segmentspecification = $segmentdata.Help.patch.segment.Create()
$segmentspecification.description = $description
$segmentspecification.id = $segmentid
$segmentspecification.transport_zone_path = $transportzone
#Set Default Gateway Variables
$subnetSpec = $segmentdata.help.patch.segment.subnets.Element.Create()
$subnetSpec.gateway_address = $defaultgateway
$segmentspecification.subnets.Add($subnetSpec) | Out-Null
#Add Tag to the Segment
$segmenttag = $segmentdata.help.patch.segment.tags.Element.Create()
$segmenttag.tag = $tag
$segmentspecification.tags.Add($segmenttag) | Out-Null
#Create Segment
$segmentdata.patch($segmentid, $segmentspecification)