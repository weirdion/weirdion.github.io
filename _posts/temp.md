# Hands-on Guide: Testing AWS Network Firewall Rules [1]

## Understanding Rule Types
Before diving into testing, let's clarify the two types of rules:
• **Stateless Rules**: Inspect individual packets in isolation [2]
• **Stateful Rules**: Consider the context of the traffic flow

## Setting Up Test Environment

### 1. Basic Infrastructure Setup
```yaml
# Example VPC Setup
VPC: 10.0.0.0/16
Protected Subnet: 10.0.1.0/24
Firewall Subnet: 10.0.2.0/24
Internet Gateway: Attached to VPC
```

### 2. Create Test Rule Groups

#### Stateless Rule Group Example
```bash
# Create a stateless rule group that filters specific IPs
aws network-firewall create-rule-group \
    --rule-group-name "test-stateless" \
    --type STATELESS \
    --capacity 100 \
    --rule-group '{
        "RulesSource": {
            "StatelessRulesAndCustomActions": {
                "StatelessRules": [
                    {
                        "RuleDefinition": {
                            "MatchAttributes": {
                                "Sources": [{
                                    "AddressDefinition": "10.0.1.0/24"
                                }],
                                "Destinations": [{
                                    "AddressDefinition": "192.0.2.0/24"
                                }],
                                "Protocols": [6]
                            },
                            "Actions": ["aws:drop"]
                        },
                        "Priority": 10
                    }
                ]
            }
        }
    }'
```

#### Stateful Rule Group Example
```bash
# Create a stateful rule group with Suricata rules
aws network-firewall create-rule-group \
    --rule-group-name "test-stateful" \
    --type STATEFUL \
    --capacity 100 \
    --rule-group '{
        "RulesSource": {
            "RulesString": "alert tcp any any -> any 80 (msg:\"HTTP Traffic\"; sid:1; rev:1;)\npass tcp any any -> any 443 (msg:\"HTTPS Traffic\"; sid:2; rev:1;)"
        }
    }'
```

## Testing Scenarios

### 1. Testing Stateless Rules

```bash
# Test script to verify stateless rules
#!/bin/bash

# Test TCP connection to blocked range
echo "Testing blocked IP range..."
nc -zv 192.0.2.10 80

# Test TCP connection to allowed range
echo "Testing allowed IP range..."
nc -zv 198.51.100.10 80
```

### 2. Testing Stateful Rules

```bash
# Test script for stateful rules
#!/bin/bash

# Test HTTP traffic (should trigger alert)
curl http://example.com

# Test HTTPS traffic (should pass)
curl https://example.com
```

## Monitoring Test Results

### 1. View Firewall Logs
```bash
# Get CloudWatch log insights
aws logs start-query \
    --log-group-name "/aws/network-firewall/my-firewall" \
    --start-time $(date -v-1H +%s) \
    --end-time $(date +%s) \
    --query-string 'fields @timestamp, @message
    | filter event.type = "alert"
    | sort @timestamp desc
    | limit 20'
```

### 2. Check Metrics
```bash
# Monitor dropped packets
aws cloudwatch get-metric-data \
    --metric-data-queries '[{
        "Id": "drops",
        "MetricStat": {
            "Metric": {
                "Namespace": "AWS/NetworkFirewall",
                "MetricName": "DroppedPackets",
                "Dimensions": [{
                    "Name": "FirewallName",
                    "Value": "my-firewall"
                }]
            },
            "Period": 300,
            "Stat": "Sum"
        }
    }]' \
    --start-time $(date -v-1H +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date +%Y-%m-%dT%H:%M:%S)
```

## Common Test Cases

### 1. Domain Filtering Test
```bash
# Stateful rule for domain filtering
aws network-firewall create-rule-group \
    --rule-group-name "domain-filter" \
    --type STATEFUL \
    --capacity 100 \
    --rule-group '{
        "RulesSource": {
            "RulesSourceList": {
                "Targets": ["example.com"],
                "TargetTypes": ["HTTP_HOST", "TLS_SNI"],
                "GeneratedRulesType": "DENYLIST"
            }
        }
    }'
```

### 2. Protocol Inspection Test
```bash
# Test specific protocol blocking
aws network-firewall create-rule-group \
    --rule-group-name "protocol-filter" \
    --type STATEFUL \
    --capacity 100 \
    --rule-group '{
        "RulesSource": {
            "RulesString": "drop tcp any any -> any 21 (msg:\"Block FTP\"; sid:100; rev:1;)"
        }
    }'
```

## Troubleshooting Tips

### 1. Verify Rule Installation
```bash
# Check rule group status
aws network-firewall describe-rule-group \
    --rule-group-name "test-stateful" \
    --type STATEFUL
```

### 2. Check Firewall Status
```bash
# Verify firewall configuration
aws network-firewall describe-firewall \
    --firewall-name "my-firewall"
```

### 3. Common Issues and Solutions
• Rule Priority Conflicts
```bash
  # List rules in priority order
  aws network-firewall describe-firewall-policy \
    --firewall-policy-name "my-policy" \
    | jq '.FirewallPolicy.StatelessRuleGroupReferences[].Priority'
```

• Connectivity Issues
```bash
  # Test basic connectivity
  aws ec2 describe-network-interfaces \
    --filters Name=description,Values="Network Firewall*"
```

## Best Practices for Testing

1. Incremental Testing
   • Start with basic rules
   • Add complexity gradually
   • Document test results

2. Test Environment
   • Use separate test VPC
   • Mirror production setup
   • Create test traffic patterns

3. Logging Strategy
   • Enable detailed logging
   • Set appropriate retention
   • Monitor CloudWatch metrics

Remember to clean up test resources when done:
```bash
# Clean up test resources
aws network-firewall delete-rule-group \
    --rule-group-name "test-stateful" \
    --type STATEFUL

aws network-firewall delete-rule-group \
    --rule-group-name "test-stateless" \
    --type STATELESS
```

This hands-on guide should give you a solid foundation for testing AWS Network Firewall rules. Always test in a controlled environment before applying rules to production workloads.

1 https://repost.aws/questions/QUv0efLqqQQeWjOv4OdYU2Ug/aws-network-firewall-allow-access-only-to-specific-domains
2 https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-rules-engines.html
