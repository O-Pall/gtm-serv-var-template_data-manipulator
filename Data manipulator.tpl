___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Data manipulator",
  "description": "Variable permettant de manipuler des données via deux modes :\n1) Simple : accès et conversion de variables/objets\n2) Avancé : transformation conditionnelle avec règles personnalisées (égal, contient,",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "inputConfiguration",
    "displayName": "Donnée à l\u0027entrée",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "inputVariable",
        "displayName": "Votre variable",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "La variable que vous souhaitez retravailler."
      },
      {
        "type": "TEXT",
        "name": "accessKey",
        "displayName": "Nom de la clé à accéder (Uniquement dans le cas d\u0027un objet)",
        "simpleValueType": true,
        "valueHint": "separate.objects.my_item"
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "choiceButton",
    "displayName": "Quel type de manipulation ?",
    "radioItems": [
      {
        "value": "simple",
        "displayValue": "Simple"
      },
      {
        "value": "advanced",
        "displayValue": "Avancé"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "sectionAccessData",
    "displayName": "Accès simple à votre donnée",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "returnFormat",
        "displayName": "Type de sortie souhaité ?",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "string",
            "displayValue": "String"
          },
          {
            "value": "floating",
            "displayValue": "Floating"
          },
          {
            "value": "integer",
            "displayValue": "Integer"
          },
          {
            "value": "boolean",
            "displayValue": "Boolean"
          },
          {
            "value": "native",
            "displayValue": "Native (même format qu\u0027à l\u0027entrée)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "native",
        "alwaysInSummary": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "choiceButton",
        "paramValue": "simple",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "sectionDataManipulator",
    "displayName": "Réécrivez votre donnée selon vos conditions.",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "tableDataManipulator",
        "displayName": "Quel type souhaitez-vous donner à votre valeur en sortie ?",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Condition - Type",
            "name": "conditionType",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "equals",
                "displayValue": "\u003d"
              },
              {
                "value": "contains",
                "displayValue": "Contains"
              },
              {
                "value": "regex",
                "displayValue": "Match Regex"
              },
              {
                "value": "greater_than",
                "displayValue": "Greater than"
              },
              {
                "value": "less_than",
                "displayValue": "Less than"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Condition - Valeur",
            "name": "conditionValue",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Retour - Valeur",
            "name": "returnValue",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Retour - Type",
            "name": "returnType",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "string",
                "displayValue": "String"
              },
              {
                "value": "floating",
                "displayValue": "Floating"
              },
              {
                "value": "integer",
                "displayValue": "Integer"
              },
              {
                "value": "boolean",
                "displayValue": "Boolean"
              },
              {
                "value": "native",
                "displayValue": "Native (même format qu\u0027à l\u0027entrée)"
              }
            ]
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "choiceButton",
        "paramValue": "advanced",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const log            = require("logToConsole");
const makeNumber     = require("makeNumber");
const makeString     = require("makeString");
const makeInteger    = require("makeInteger");
const getType        = require("getType");

/*
** Configuration Sections
*/
const mode = data.choiceButton;
let value;

log("data.inputVariable : " + data.inputVariable);
log("data.accessKey : " + data.accessKey);
log("data.returnFormat : " + data.returnFormat);


/*
** Input Processing based on mode
*/
if (mode === "simple") {
  // Simple mode - Original functionality
  if (!data.inputVariable) {
    log("Missing input variable.");
    return undefined;
  }

  // Handle object access or direct value
  if (typeof data.inputVariable === 'object' && data.inputVariable !== null && data.accessKey) {
    // Handle object case with access key
    let keys = data.accessKey.split(".");
    value = data.inputVariable;

    for (let i = 0; i < keys.length; i++) {
      if (value[keys[i]] === undefined) {
        log("Key not found: " + keys[i]);
        return undefined;
      }
      value = value[keys[i]];
    }
  } else {
    // Handle non-object case - use the input directly
    value = data.inputVariable;
  }

  // Apply return format
  let returnFormat = data.returnFormat;

  /*
  ** Output Formatting for simple mode
  */
  if (returnFormat === "string" && typeof value !== "string") {
    value = makeString(value);
  }
  else if (returnFormat === "floating") {
    if (getType(value) == "string") {
      value = value.replace(",", ".");
    }     
    value = makeNumber(value);
  }
  else if (returnFormat === "integer") {
    if (getType(value) == "string") {
      value = value.replace(",", ".");
    }
    value = makeInteger(value);
  }
  else if (returnFormat === "boolean") {
    let tempValue = makeString(value).toLowerCase();
    let yes = ["1", "true", "oui", "o", "yes", "y", "on", "si", "vrai", "ja", "t", "affirmative", "enabled", "checked", "okay"];
    let no = ["0", "false", "non", "n", "no", "off", "nein", "faux", "f", "negative", "disabled", "unchecked", "nay", "cancel"];

    if (yes.indexOf(tempValue) !== -1) {
      value = true;
    }
    else if (no.indexOf(tempValue) !== -1) {
      value = false;
    }
  }

} else if (mode === "advanced") {
  // Advanced mode - Table data manipulation
  if (!data.inputVariable) {
    log("Missing input variable.");
    return undefined;
  }

  // Get initial value (same as simple mode)
  if (typeof data.inputVariable === 'object' && data.inputVariable !== null && data.accessKey) {
    let keys = data.accessKey.split(".");
    value = data.inputVariable;

    for (let i = 0; i < keys.length; i++) {
      if (value[keys[i]] === undefined) {
        log("Key not found: " + keys[i]);
        return undefined;
      }
      value = value[keys[i]];
    }
  } else {
    value = data.inputVariable;
  }

  // Process table rules
  if (data.tableDataManipulator && data.tableDataManipulator.length > 0) {
    let originalValue = value;
    
    for (let rule of data.tableDataManipulator) {
      let matches = false;
      let stringValue = makeString(originalValue).toLowerCase();
      let compareValue = makeString(rule.conditionValue).toLowerCase();

      switch(rule.conditionType) {
        case "equals":
          matches = stringValue === compareValue;
          break;
        case "contains":
          matches = stringValue.indexOf(compareValue) !== -1;
          break;
        case "regex":
          matches = stringValue.match(makeString(rule.conditionValue)) !== null;
          break;
        case "greater_than":
          matches = makeNumber(originalValue) > makeNumber(rule.conditionValue);
          break;
        case "less_than":
          matches = makeNumber(originalValue) < makeNumber(rule.conditionValue);
          break;
      }

      if (matches) {
        // Apply the matching rule's return value and type
        value = rule.returnValue;
        
        // Convert the return value to the specified type
        switch(rule.returnType) {
          case "string":
            value = makeString(value);
            break;
          case "floating":
            if (getType(value) === "string") {
              value = value.replace(",", ".");
            }
            value = makeNumber(value);
            break;
          case "integer":
            if (getType(value) === "string") {
              value = value.replace(",", ".");
            }
            value = makeInteger(value);
            break;
          case "boolean":
            let tempValue = makeString(value).toLowerCase();
            let yes = ["1", "true", "oui", "o", "yes", "y", "on", "si", "vrai", "ja", "t", "affirmative", "enabled", "checked", "okay"];
            let no = ["0", "false", "non", "n", "no", "off", "nein", "faux", "f", "negative", "disabled", "unchecked", "nay", "cancel"];
            
            if (yes.indexOf(tempValue) !== -1) {
              value = true;
            }
            else if (no.indexOf(tempValue) !== -1) {
              value = false;
            }
            break;
        }
        
        log("Rule matched: " + rule.conditionType + " - New value: " + value + " (" + rule.returnType + ")");
        break; // Stop after first match
      }
    }
  }
}

log("Final value: " + value + " (Type: " + getType(value) + ")");
return value;


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: testSimpleMode_DirectString
  code: |2
      // Setup
      const mockData = {
        choiceButton: "simple",
        inputVariable: "test_value",
        returnFormat: "string"
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isString();
      assertThat(variableResult).isEqualTo("test_value");
- name: testSimpleMode_NumberToBoolean
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "simple",
        inputVariable: 1,
        returnFormat: "boolean"
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isBoolean();
      assertThat(variableResult).isTrue();
- name: testSimpleMode_ObjectAccess
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "simple",
        inputVariable: {
          user: {
            settings: {
              isActive: "yes"
            }
          }
        },
        accessKey: "user.settings.isActive",
        returnFormat: "boolean"
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isBoolean();
      assertThat(variableResult).isTrue();
- name: testSimpleMode_InvalidObjectPath
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "simple",
        inputVariable: {
          user: {
            settings: {}
          }
        },
        accessKey: "user.settings.nonexistent",
        returnFormat: "string"
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isUndefined();
- name: testAdvancedMode_EqualsCondition
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "test",
        tableDataManipulator: [{
          conditionType: "equals",
          conditionValue: "test",
          returnValue: "matched",
          returnType: "string"
        }]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isString();
      assertThat(variableResult).isEqualTo("matched");
- name: testAdvancedMode_ContainsCondition
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "this is a test string",
        tableDataManipulator: [{
          conditionType: "contains",
          conditionValue: "test",
          returnValue: "1",
          returnType: "integer"
        }]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isNumber();
      assertThat(variableResult).isEqualTo(1);
- name: testAdvancedMode_RegexCondition
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "user123@example.com",
        tableDataManipulator: [{
          conditionType: "regex",
          conditionValue: ".*@example\\.com$",
          returnValue: "true",
          returnType: "boolean"
        }]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isBoolean();
      assertThat(variableResult).isTrue();
- name: testAdvancedMode_GreaterThanCondition
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "500",
        tableDataManipulator: [{
          conditionType: "greater_than",
          conditionValue: "100",
          returnValue: "high_value",
          returnType: "string"
        }]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isString();
      assertThat(variableResult).isEqualTo("high_value");
- name: testAdvancedMode_MultipleRules_FirstMatch
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "test_value",
        tableDataManipulator: [
          {
            conditionType: "equals",
            conditionValue: "test_value",
            returnValue: "1",
            returnType: "integer"
          },
          {
            conditionType: "equals",
            conditionValue: "test_value",
            returnValue: "2",
            returnType: "integer"
          }
        ]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isNumber();
      assertThat(variableResult).isEqualTo(1);
- name: testAdvancedMode_NoMatchingRules
  code: |2-
      // Setup
      const mockData = {
        choiceButton: "advanced",
        inputVariable: "test_value",
        tableDataManipulator: [{
          conditionType: "equals",
          conditionValue: "different_value",
          returnValue: "matched",
          returnType: "string"
        }]
      };

      // Run test
      let variableResult = runCode(mockData);

      // Assert
      assertThat(variableResult).isString();
      assertThat(variableResult).isEqualTo("test_value");


___NOTES___

Created on 31/03/2025 15:57:50


