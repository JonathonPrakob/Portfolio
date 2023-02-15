resource "azurerm_policy_definition" "Enforce_purpose_tag" {
  name                = "Enforce purpose tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Enforce purpose tag"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.target_management_group}"
  policy_rule         = <<POLICY_RULE
  {
    "if" : {
      "field" : "tags[purpose]",
      "exists" : "false"
    },
    "then" : {
      "effect" : "deny"
    }
  }
  POLICY_RULE
  metadata = <<METADATA
    {
    "category": "tags"
    }
METADATA
}

resource "azurerm_policy_definition" "Enforce_creator_tag" {
  name                = "Enforce creator tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Enforce creator tag"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.target_management_group}"
  policy_rule         = <<POLICY_RULE
  {
    "if" : {
      "allOf" : [
        {
          "field" : "tags[Created By]",
          "exists" : "false"
        },
        {
          "field" : "tags[CreatedBy]",
          "exists" : "false"
        },
        {
          "field" : "tags[Creator]",
          "exists" : "false"
        }
      ]
    },
    "then" : {
      "effect" : "deny"
    }
  }
  POLICY_RULE
  metadata = <<METADATA
    {
    "category": "tags"
    }
METADATA
}

resource "azurerm_policy_definition" "Enforce_created_tag" {
  name                = "Enforce created tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Enforce created tag"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.target_management_group}"
  policy_rule         = <<POLICY_RULE
  {
    "if" : {
      "allOf" : [
        {
          "field" : "tags[Created on]",
          "exists" : "false"
        },
        {
          "field" : "tags[Createdon]",
          "exists" : "false"
        },
        {
          "field" : "tags[Created]",
          "exists" : "false"
        }
      ]
    },
    "then" : {
      "effect" : "append",
      "details" : [
        {
          "field" : "tags[created]",
          "value" : "[utcNow()]"
        }
      ]
    }
  }
  POLICY_RULE
  metadata = <<METADATA
    {
    "category": "tags"
    }
METADATA
}

resource "azurerm_policy_set_definition" "Enforce_tags" {
  name                = "enforce tags"
  policy_type         = "Custom"
  display_name        = "Enforce tags"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.target_management_group}"
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.Enforce_created_tag.id
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.Enforce_creator_tag.id
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.Enforce_purpose_tag.id
  }
  metadata = <<METADATA
    {
    "category": "tags"
    }
METADATA
}

resource "azurerm_management_group_policy_assignment" "enforce_tags" {
  name                 = "enforce tags"
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${var.target_management_group}"
  policy_definition_id = azurerm_policy_set_definition.Enforce_tags.id
  non_compliance_message {
    content = "Required tags: purpose and creator"
  }
  not_scopes = var.exemptions
}
